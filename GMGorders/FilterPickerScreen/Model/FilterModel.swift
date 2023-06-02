//
//  FilterModel.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/2/23.
//

import Foundation

struct FilterModel {
    let categoryId : Int
    var isSelected : Bool = false
    
    mutating func toggle(){
        self.isSelected = !isSelected
    }
}
