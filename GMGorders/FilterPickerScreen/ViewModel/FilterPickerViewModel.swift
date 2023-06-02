//
//  FilterPickerViewModel.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/2/23.
//

import Foundation
import Combine

class FilterPickerViewModel: ObservableObject {
    @Published var filterDataSource : [FilterModel]
    weak var filterDelegate : FilterAppliedProtocol?
    
    var appliedFilterIds : [Int] {
        let selectedIds = filterDataSource.filter({$0.isSelected}).map({$0.categoryId})
        return selectedIds.count == filterDataSource.count ? [] : selectedIds
    }
    
    init(filterDataSource: [FilterModel],delegate:FilterAppliedProtocol) {
        self.filterDataSource = filterDataSource
        self.filterDelegate = delegate
    }
    
    func itemSelected(itemId : Int){
        if let index = filterDataSource.firstIndex(where: { item in
            item.categoryId == itemId
        }){
            filterDataSource[index].toggle()
      }
    }

}
