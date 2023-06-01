//
//  TransactionListModel.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation

struct TransactionList: Codable {
    let items: [Transaction]
}

// MARK: - Item
struct Transaction: Codable {
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
    
    var formatedBookingDate : Date{
        let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:transactionDetail.bookingDate)!
        return date
    }
}

// MARK: - Alias
struct Alias: Codable {
    let reference: String
}

// MARK: - TransactionDetail
struct TransactionDetail: Codable {
    let description: String?
    let bookingDate: String
    let value: Value
}

// MARK: - Value
struct Value: Codable {
    let amount: Int
    let currency: Currency
}

enum Currency: String, Codable {
    case aed = "AED"
}
