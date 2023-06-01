//
//  AppDelegate.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let _ = NetworkService.instance
        homeViewController()
        return true
    }


}


extension AppDelegate{
    
    private func homeViewController(){
        let transactionListVC = Helper.getMainStoryBoard.instantiateViewController(identifier: TransactionListVC.typeName, creator: { coder in
            TransactionListVC(coder: coder, viewModel: TransactionListViewModel())})
                let rootVC = UINavigationController(rootViewController: transactionListVC)
             rootVC.navigationBar.tintColor = .black
                makeViewControllerRoot(rootVC)
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

