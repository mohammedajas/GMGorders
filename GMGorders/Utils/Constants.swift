//
//  Constants.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/2/23.
//

import Foundation
struct Constants {
    private init(){
        
    }
     static let noOrdersToshow = "No orders to show"
     static let networkError =  "Something went Wrong"
     static let transactionListTitle = "My Orders"
     static let totalSum = "Orders Total Sum"
     static let close = "Close"
     static let resetFilter = "Reset Filter"
     static let viewOrders = "View Orders"
     static let selectCategories = "Select the Categories"
     static let filteritemAppend = " - Category"
     static let waitText = "Please wait..."
    
    struct Formatter{
        static let dateFormatter = "EEEE, dd MMMM yyyy"
        static let localeFormatter = "en_US_POSIX"
        static let apiFormatter =  "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    struct Images{
        static let checkbox = "checkbox"
        static let unchecked = "unchecked"
    }
    
 }
