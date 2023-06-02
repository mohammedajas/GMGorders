//
//  TransactionDetailVC.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import UIKit
import Combine

class TransactionDetailVC: UIViewController {
    
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var transactionDescriptionLabel: UILabel!
    private var viewModel : TransactionDetailViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coder:NSCoder,viewModel: TransactionDetailViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)!
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel(){
        viewModel.$transaction.receive(on:  DispatchQueue.main)
            .sink { [weak self]item in
                guard let self = self else{
                    return
                }
                self.partnerNameLabel.text = item.partnerDisplayName
                self.transactionDescriptionLabel.text = item.transactionDetail.description
            }.store(in: &cancellables)
    }
    
    
}
