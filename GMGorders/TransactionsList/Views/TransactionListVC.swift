//
//  ViewController.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import UIKit
import Combine


class TransactionListVC: UIViewController {
    private var viewModel: TransactionListViewModel!
    private var cancellables = Set<AnyCancellable>()

    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerCell(TransactionItemCell.self)
        }
    }
  
    init(coder:NSCoder,viewModel: TransactionListViewModel!) {
        self.viewModel = viewModel
        super.init(coder: coder)!
    }
    
    required init?(coder: NSCoder) {
           super.init(coder: coder)
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Orders"
        bindViewModel()
        
    }
    
    
    private func bindViewModel(){
        viewModel.getTransactionList()
        
//        viewModel.$transactions.receive(on: DispatchQueue.main)
//            .sink { completion in
//            switch completion{
//            case .failure:
//                print("faliure")
//            case .finished:
//                print("completed")
//            }
//        }
//       receiveValue: { [weak self] list in
//            guard let self = self else {
//                return
//            }
//            self.transactions = list
//           self.tableView.reloadData()
//        }.store(in: &cancellables)
                
        
        viewModel.$showLoader.receive(on: DispatchQueue.main).sink { [weak self] show in
            guard let self = self else{
                return
            }
            self.tableView.reloadData()
            _ =  show ? Helper.showLoader(viewController:self) : Helper.hideLoader(viewController:self)
        }.store(in: &cancellables)
    }
    


}


extension TransactionListVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(TransactionItemCell.self, indexPath: indexPath)
        let itemModel = viewModel.transactions[indexPath.row]
        cell.namelabel.text = itemModel.partnerDisplayName
        cell.bookingDateLabel.text = GMGDateFormatter.formatDateToShortDayMonthYearString(itemModel.formatedBookingDate)
        cell.amountLabel.text = "\(itemModel.transactionDetail.value.amount) " + itemModel.transactionDetail.value.currency.rawValue
        cell.descriptionLabel.text = itemModel.transactionDetail.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transactionDetailVC = Helper.getMainStoryBoard.instantiateViewController(identifier: TransactionDetailVC.typeName, creator: { coder in
            TransactionDetailVC(coder: coder, viewModel: TransactionDetailViewModel(transaction: self.viewModel.transactions[indexPath.row]))})
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController?.pushViewController(transactionDetailVC, animated: true)
        }
    }
    
    
}

