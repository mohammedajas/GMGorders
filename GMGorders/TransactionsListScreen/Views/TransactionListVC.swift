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
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerCell(TransactionItemCell.self)
            tableView.registerCell(EmptySpaceCell.self)
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
        self.title = Constants.transactionListTitle
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
        filterView.isHidden = self.viewModel.filterTransactions.isEmpty
        filterIndicator.isHidden =  !(viewModel.appliedFilterCategoriesIds.count > 0)
        amountTotalView.isHidden = self.viewModel.filterTransactionsTotalSum.isEmpty
        amountTotalView.totalAmountLabel.text = self.viewModel.filterTransactionsTotalSum
    }
    
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        AppRouter.shared.navigateToListFilter(currrentViewController: self, filterModelDataSources: self.viewModel.filterModelDataSources, delegate: self.viewModel, navigationType: .present)
        
    }
    
}


extension TransactionListVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterTransactions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.filterTransactions.count == indexPath.row{
            let cell = tableView.dequeueCell(EmptySpaceCell.self, indexPath: indexPath)
            cell.emptyMessageLabel.text = viewModel.errorText ??  Constants.noOrdersToshow
            cell.emptyMessageLabel.isHidden = (indexPath.row > 0) || viewModel.showLoader
            return cell
        }
        
        let cell = tableView.dequeueCell(TransactionItemCell.self, indexPath: indexPath)
        let itemModel = viewModel.filterTransactions[indexPath.row]
        cell.namelabel.text = itemModel.partnerDisplayName
        cell.bookingDateLabel.text = GMGDateFormatter.formatDateToShortDayMonthYearString(itemModel.formatedBookingDate)
        cell.amountLabel.text = itemModel.regionalCurrency
        cell.descriptionLabel.text = itemModel.transactionDetail.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppRouter.shared.navigateTransactionDetail(currrentViewController: self,
                                                   transaction: self.viewModel.filterTransactions[indexPath.row],
                                                   navigationType: .push)
        
    }
    
    
}

