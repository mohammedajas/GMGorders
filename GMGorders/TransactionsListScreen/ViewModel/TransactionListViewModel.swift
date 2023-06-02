//
//  TransactionListViewModel.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation
import Combine


class TransactionListViewModel: ObservableObject {
    
    private var completeTransactions = [Transaction]()
    private var cancellables = Set<AnyCancellable>()
    @Published var filterTransactions = [Transaction]()
    @Published var refeshView = true
    var showLoader = true
    var filterModelDataSources : [FilterModel] = []
    var appliedFilterCategoriesIds : [Int] = []
    var errorText : String?
    var filterTransactionsTotalSum : String {
        guard  filterTransactions.count > 0 else{
            return ""
        }
        let sum =  filterTransactions.reduce(0.0) { partialResult, item in
            partialResult + item.transactionDetail.value.amount
        }
        return  filterTransactions.first!.transactionDetail.value.currency.rawValue + " " + String(format: "%.2f", sum)
    }

    func getTransactionList() {
        self.showLoader = true
        self.refeshView = true
        NetworkManager.shared.getData(endpoint: .transactionList, type: TransactionList.self)
            .sink { [weak self] completion in
                guard let self = self else {return}
                self.showLoader = false
                self.refeshView = true
                switch completion {
                case .failure(_):
                    self.errorText = Constants.networkError
                case .finished:
                    self.errorText = nil
                }
            }
            receiveValue: { [weak self] transactionList in
                guard let self = self else {return}
                self.errorText = nil
                let sortedList = transactionList.items.sorted(by: {
                    $0.formatedBookingDate.compare($1.formatedBookingDate) == .orderedDescending
                })
                
                self.completeTransactions = sortedList
                self.filterTransactions = sortedList
                self.createFilterModel()
            }
            .store(in: &cancellables)
        }
    
    private func createFilterModel(){
        self.filterModelDataSources = Set(completeTransactions.map { $0.category }).map { categoryId in
            let alreadyApplied = (appliedFilterCategoriesIds.first { $0 == categoryId} != nil)
            let filterModel = FilterModel(categoryId: categoryId,isSelected: alreadyApplied)
           return filterModel
        }.sorted(by: {$0.categoryId < $1.categoryId})
    }
    
    private func applyFilter(){
        if appliedFilterCategoriesIds.isEmpty{
            self.filterTransactions = completeTransactions
        }else{
            self.filterTransactions = completeTransactions.filter({ item in
                if #available(iOS 16.0, *) {
                    return appliedFilterCategoriesIds.contains([item.category])
                } else {
                   return (appliedFilterCategoriesIds.first { $0 == item.category} != nil)
                }
            })
        }
        createFilterModel()
        self.refeshView = true
    }
}

extension TransactionListViewModel : FilterAppliedProtocol{
    func appliedFliterItems(categoriesIds: [Int]) {
        if categoriesIds == appliedFilterCategoriesIds{
            return
        }
        appliedFilterCategoriesIds = categoriesIds
        applyFilter()
    }
    
    
}




