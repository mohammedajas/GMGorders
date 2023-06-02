//
//  TransactionDetailVC.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation
import Combine


class TransactionDetailViewModel: ObservableObject {
    @Published var transaction : Transaction
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
}
