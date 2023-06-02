//
//  Approuter.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/2/23.
//

import UIKit

enum NavigationType{
    case push
    case present
}

final class AppRouter {
    
    static let shared = AppRouter()
    
    private init(){
        
    }
    
    func setRootTransactionsListScreen(viewModel: TransactionListViewModel){
        let transactionListVC = Helper.getMainStoryBoard.instantiateViewController(identifier: TransactionListVC.typeName, creator: { coder in
            TransactionListVC(coder: coder, viewModel: viewModel)})
        let rootVC = UINavigationController(rootViewController: transactionListVC)
        rootVC.navigationBar.tintColor = .black
        self.makeViewControllerRoot(rootVC)
        
    }
    
    func  navigateTransactionDetail(currrentViewController: UIViewController,transaction: Transaction,navigationType : NavigationType){
        let transactionDetailVC = Helper.getMainStoryBoard.instantiateViewController(identifier: TransactionDetailVC.typeName,
                                                                                     creator: { coder in
            TransactionDetailVC(coder: coder,
                                viewModel: TransactionDetailViewModel(transaction: transaction))
        })
        routerControllers(currrentViewController: currrentViewController,
                          destinationViewContoller: transactionDetailVC,
                          navigationType: navigationType)
    }
    
    
    func  navigateToListFilter(currrentViewController: UIViewController,filterModelDataSources: [FilterModel], delegate: FilterAppliedProtocol,    navigationType : NavigationType){
        let filterVC = Helper.getMainStoryBoard.instantiateViewController(identifier: FilterPickerVC.typeName,
                                                                          creator: { coder in
            FilterPickerVC(coder: coder, viewModel: FilterPickerViewModel(filterDataSource: filterModelDataSources,
                                                                          delegate: delegate))
        })
        routerControllers(currrentViewController: currrentViewController,
                          destinationViewContoller: filterVC,
                          navigationType: navigationType)
    }
    
    
}


extension AppRouter {
    
    private func routerControllers(currrentViewController: UIViewController,
                                   destinationViewContoller : UIViewController, navigationType : NavigationType){
        DispatchQueue.main.async {
            switch navigationType{
            case .push:
                currrentViewController.navigationController?.pushViewController(destinationViewContoller, animated: true)
            case .present:
                currrentViewController.present(destinationViewContoller, animated: true)
            }
        }
    }
    
    
    private func makeViewControllerRoot(
        _ viewController: UIViewController,
        force: Bool = false) {
            let window = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .last { $0.isKeyWindow }
            
            if window == nil || force {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let window = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window = window
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            } else {
                setRootViewController(viewController)
            }
        }
    
    private func setRootViewController(_ viewController: UIViewController) {
        guard let delegateWindow = UIApplication.shared.delegate?.window, let window = delegateWindow  else {
            return
        }
        viewController.view.frame = UIScreen.main.bounds
        viewController.view.layoutIfNeeded()
        window.rootViewController = viewController
    }
}

