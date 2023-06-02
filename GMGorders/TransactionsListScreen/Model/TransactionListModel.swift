//
//  TransactionListModel.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation

struct TransactionList: Decodable {
    let items: [Transaction]
}

// MARK: - Item
struct Transaction: Decodable {
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: TransactionDetail
    
    var formatedBookingDate : Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Constants.Formatter.localeFormatter)
        dateFormatter.dateFormat = Constants.Formatter.apiFormatter
        let date = dateFormatter.date(from:transactionDetail.bookingDate)!
        return date
    }
    
    var regionalCurrency : String{
        return transactionDetail.value.currency.rawValue + " " + String(format: "%.2f", transactionDetail.value.amount)
    }
}

// MARK: - Alias
struct Alias: Decodable {
    let reference: String
}

// MARK: - TransactionDetail
struct TransactionDetail: Decodable {
    let description: String?
    let bookingDate: String
    let value: Value
}

// MARK: - Value
struct Value: Decodable {
    let amount: Double
    let currency: Currency
}

enum Currency: String, Decodable {
    case aed = "AED"
}
