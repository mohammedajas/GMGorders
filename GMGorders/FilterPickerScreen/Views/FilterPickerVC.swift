//
//  FilterPickerVC.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import UIKit
import Combine


class FilterPickerVC: UIViewController {
    private var viewModel: FilterPickerViewModel!
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var selectCategoryTitle: UILabel!
    @IBOutlet weak var viewOrdersButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerCell(FilterItemCell.self)
        }
    }
    init(coder:NSCoder,viewModel: FilterPickerViewModel!) {
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
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        viewModel.filterDelegate?.appliedFliterItems(categoriesIds:[])
        self.dismiss(animated: true)
    }
    
    @IBAction func viewOrderButtonAction(_ sender: UIButton) {
        viewModel.filterDelegate?.appliedFliterItems(categoriesIds:viewModel.appliedFilterIds)
        self.dismiss(animated: true)
    }
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func bindViewModel(){
        closeButton.setTitle(Constants.close, for: .normal)
        resetButton.setTitle(Constants.resetFilter, for: .normal)
        viewOrdersButton.setTitle(Constants.viewOrders, for: .normal)
        selectCategoryTitle.text = Constants.selectCategories
        viewModel.$filterDataSource.receive(on: DispatchQueue.main).sink { [weak self] list in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
  
}

extension FilterPickerVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(FilterItemCell.self, indexPath: indexPath)
        let model = viewModel.filterDataSource[indexPath.row]
        cell.filterNameLabel.text = "\(model.categoryId)\(Constants.filteritemAppend)"
        cell.selectedStatusImageView.image = UIImage(named: model.isSelected ? Constants.Images.checkbox :  Constants.Images.unchecked)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexItem  =  viewModel.filterDataSource[indexPath.row]
        viewModel.itemSelected(itemId: indexItem.categoryId)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
}
    
