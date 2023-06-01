//
//  InternetConnectionView.swift
//  swan-shopper-ios
//
//  Created by Анатолій Василик on 11/11/18.
//  Copyright © 2018 Algorythma. All rights reserved.
//

import UIKit

class InternetConnectionView: UIView {
    enum Style {
        case normal
        case poorConnection
        case noInternet
    }

    // MARK: - Views
    fileprivate var messageLabel: UILabel! {
        didSet {
            messageLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            messageLabel.textAlignment = .center
            messageLabel.textColor = AppStyles.Color.white
        }
    }
    fileprivate var alertView: UIView!

    // MARK: - Variables
    fileprivate let labelInset: CGFloat = 7
    fileprivate let viewHeight: CGFloat = 28
    fileprivate let labelHeight: CGFloat = 14
    fileprivate let animationTime: Double = 0.3
    fileprivate var isViewInitialized: Bool = false

    fileprivate var hidingDelay: DispatchTime {
        return .now() + 3
    }

    fileprivate var state: Style! {
        didSet {
            if oldValue != state {
                updateViewRegardingState()
            }
        }
    }

    fileprivate var isHidding: Bool = false
    fileprivate var isPresent: Bool {
        return _isPresent
    }
    fileprivate var _isPresent: Bool = false

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }

    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UI
    fileprivate func createUI() {
        let screenSize = UIScreen.main.bounds.size
        let alertViewHeight = SafeAreaHelper.insets().bottom + viewHeight
        self.frame = CGRect(x: 0,
                            y: screenSize.height,
                            width: screenSize.width,
                            height: alertViewHeight)

        alertView = UIView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: screenSize.width,
                                         height: alertViewHeight))

        messageLabel = UILabel(frame: CGRect(x: 0,
                                             y: labelInset,
                                             width: screenSize.width,
                                             height: labelHeight))
        addSubview(alertView)
        alertView.addSubview(messageLabel)
    }

    fileprivate func updateColoredViewHeight() {
        let alertViewHeight = SafeAreaHelper.insets().bottom + viewHeight
        alertView.frame.size.height = alertViewHeight
    }

    // MARK: - Configuration
    func configure(state: Style) {
        self.state = state
    }

    // MARK: - Main methods
    func show() {
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }

        guard !_isPresent,
            let window = window,
            window.rootViewController != nil else {
            return
        }

        if !isViewInitialized {
            isViewInitialized = true

            if case .normal? = state {
                return
            }
        }

        _isPresent = true

        let screenSize = UIScreen.main.bounds.size
        let alertViewHeight = SafeAreaHelper.insets().bottom + viewHeight
        self.frame = CGRect(x: 0,
                            y: screenSize.height,
                            width: screenSize.width,
                            height: alertViewHeight)
        updateColoredViewHeight()

        window.addSubview(self)

        UIView.animate(withDuration: animationTime) {
            self.frame.origin.y = screenSize.height - SafeAreaHelper.insets().bottom - self.viewHeight
        }
    }

    func hide() {
        guard _isPresent else {
            return
        }
        self._isPresent = false
        UIView.animate(withDuration: animationTime, animations: {
            guard !self.isHidding else {
                return
            }
            self.isHidding = true
            let screenSize = UIScreen.main.bounds.size
            self.frame.origin.y = screenSize.height
        }, completion: { _ in
            self.isHidding = false
        })
    }

    // MARK: - State methods
    fileprivate func updateViewRegardingState() {
        show()
        switch state! {
        case .normal:
            updateViewWithNormalState()
        case .poorConnection:
            updateViewWithPoorConnectionState()
        case .noInternet:
            updateViewWithNoInternetState()
        }
    }

    fileprivate func updateView(with color: UIColor, text: String) {
        UIView.animate(withDuration: animationTime) {
            self.alertView.backgroundColor = color
            self.messageLabel.text = text
        }
    }

    fileprivate func updateViewWithNormalState() {
        updateView(with: AppStyles.Color.green, text: "Back online")
        DispatchQueue.main.asyncAfter(deadline: hidingDelay) {
            if case .normal = self.state!,
                self.isPresent {
                self.hide()
            }
        }
    }

    fileprivate func updateViewWithPoorConnectionState() {
        updateView(with: AppStyles.Color.grey, text: "Poor Intenet connection")
    }

    fileprivate func updateViewWithNoInternetState() {
        updateView(with: AppStyles.Color.red, text: "No Intenet connection")
    }
}
