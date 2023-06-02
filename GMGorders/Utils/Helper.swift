//
//  HelperClass.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import UIKit

final class Helper{
    
    static func showLoader(viewController : UIViewController){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
    }
    static func hideLoader(viewController : UIViewController){
        viewController.dismiss(animated: true)
    }
    
    static var getMainStoryBoard  : UIStoryboard{
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
      return mainStoryBoard
    }

}


class SafeAreaHelper {
    static func insets() -> UIEdgeInsets {
        var insets: UIEdgeInsets = .zero
        
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
        
        if  window != nil {
            insets = window!.safeAreaInsets
        }
        return insets
    }
}


