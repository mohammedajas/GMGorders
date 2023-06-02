//
//  NetworkManager.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation
import Combine


enum Endpoint{
    case transactionList
}

class NetworkManager {
    static let shared = NetworkManager()
#if DEBUG
    private let transactionsEndpoint = "https://api-test.gmg.com/transactions"
#else
    private let transactionsEndpoint = "https://api.gmg.com/transactions"
#endif
    let mockEnabled = true
    private let mockJsonfileName = "GMGTransactions"
    private var cancellables = Set<AnyCancellable>()
    private init() {
        
    }
    
    private func getEndPointUrl(endpoint: Endpoint) -> String{
        switch endpoint {
        case .transactionList:
            return transactionsEndpoint
        }
    }
    
    
    func getData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<T, Error> {
        
        let endPointUrl = getEndPointUrl(endpoint: endpoint)
    
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: endPointUrl) else {
                return promise(.failure(NetworkError.invalidURL))
            }
        
            if self.mockEnabled {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if let mockTransactions = self.mockJsonfileName.readLocalJsonFile(),
                       let mockModel = mockTransactions.jsonParser(type: T.self){
                        promise(.success(mockModel))
                    }else{
                        promise(.failure(NetworkError.responseError))
                    }
                }
            }
            else{
                URLSession.shared.dataTaskPublisher(for: url)
                    .tryMap { (data, response) -> Data in
                        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                            throw NetworkError.responseError
                        }
                        return data
                    }
                    .decode(type: T.self, decoder: JSONDecoder())
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { (completion) in
                        if case let .failure(error) = completion {
                            switch error {
                            case let decodingError as DecodingError:
                                promise(.failure(decodingError))
                            case let apiError as NetworkError:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(NetworkError.unknown))
                            }
                        }
                    }, receiveValue: { promise(.success($0)) })
                    .store(in: &self.cancellables)
            }
        }
        
        
    }
}
    
    enum NetworkError: Error {
        case invalidURL
        case responseError
        case unknown
    }
    
    extension NetworkError: LocalizedError {
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return NSLocalizedString("Invalid URL", comment: "Invalid URL")
            case .responseError:
                return NSLocalizedString("Unexpected status code", comment: "Invalid response")
            case .unknown:
                return NSLocalizedString("Unknown error", comment: "Unknown error")
            }
        }
    }
