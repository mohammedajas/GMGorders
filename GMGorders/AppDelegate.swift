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
         _ = NetworkService.instance
        AppRouter.shared.setRootTransactionsListScreen(viewModel: TransactionListViewModel())
        return true
    }


}
