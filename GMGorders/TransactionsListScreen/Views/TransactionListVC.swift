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
    @IBOutlet weak var filterIndicator: UIView!
    @IBOutlet weak var amountTotalView: AmoutTotalView!
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
        viewModel.$refeshView.receive(on: DispatchQueue.main).sink { [weak self] isRefreshRequired in
            guard let self = self else{return}
            if isRefreshRequired {
                self.refreshMyView()
            }
        }.store(in: &cancellables)
    }
    
    private func refreshMyView(){
        self.tableView.reloadData()
        _ =  self.viewModel.showLoader ? Helper.showLoader(viewController:self) : Helper.hideLoader(viewController:self)
        filterIndicator.isHidden =  !(viewModel.appliedFilterCategoriesIds.count > 0)
        amountTotalView.isHidden = self.viewModel.filterTransactionsTotalSum.isEmpty
        amountTotalView.totalAmountLabel.text = self.viewModel.filterTransactionsTotalSum
    }
    
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        let filterVC = Helper.getMainStoryBoard.instantiateViewController(identifier: FilterPickerVC.typeName,
         creator: { coder in
            FilterPickerVC(coder: coder, viewModel: FilterPickerViewModel(filterDataSource: self.viewModel.filterModelDataSources,
                                                                          delegate: self.viewModel))
        })
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.present(filterVC, animated: true)
        }
    }
    
}


extension TransactionListVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(TransactionItemCell.self, indexPath: indexPath)
        let itemModel = viewModel.filterTransactions[indexPath.row]
        cell.namelabel.text = itemModel.partnerDisplayName
        cell.bookingDateLabel.text = GMGDateFormatter.formatDateToShortDayMonthYearString(itemModel.formatedBookingDate)
        cell.amountLabel.text = itemModel.regionalCurrency
        cell.descriptionLabel.text = itemModel.transactionDetail.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transactionDetailVC = Helper.getMainStoryBoard.instantiateViewController(identifier: TransactionDetailVC.typeName,
         creator: { coder in
            TransactionDetailVC(coder: coder,
                                viewModel: TransactionDetailViewModel(transaction: self.viewModel.filterTransactions[indexPath.row]))
        })
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.navigationController?.pushViewController(transactionDetailVC, animated: true)
        }
    }
    
    
}

