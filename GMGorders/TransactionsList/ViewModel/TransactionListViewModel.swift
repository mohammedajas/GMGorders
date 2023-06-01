//
//  TransactionListViewModel.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation
import Combine


class TransactionListViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var transactions = [Transaction]()
    @Published var showLoader = true

    func getTransactionList(filterCategory : Int? = nil) {
        self.showLoader = true
        NetworkManager.shared.getData(endpoint: .transactionList, type: TransactionList.self)
            .sink { [weak self] completion in
                self?.showLoader = false
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            }
            receiveValue: { [weak self] transactionList in
                
                let sortedList = transactionList.items.sorted(by: { $0.formatedBookingDate.compare($1.formatedBookingDate) == .orderedDescending })
                
                guard let filterCategory =  filterCategory else{
                    self?.transactions = sortedList
                    return
                }
                self?.transactions = sortedList.filter { item in
                    item.category == filterCategory
                }
                
                
            }
            .store(in: &cancellables)
        
        }
}




