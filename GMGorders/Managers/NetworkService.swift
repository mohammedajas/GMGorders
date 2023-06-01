//
//  NetworkService.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation
import CoreTelephony

final class NetworkService {

    static let instance = NetworkService()

    // MARK: - Variables

    private lazy var internetView = InternetConnectionView()
    private let reachability = try! Reachability()

    // MARK: - Init
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(note:)),
            name: .reachabilityChanged,
            object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            NSLog("could not start reachability notifier")
        }
    }

    // MARK: - Methods
    func checkInternetConnectionSpeed() {
        if case .cellular = reachability.connection {
            checkCellularSpeed()
        }
    }

    // MARK: - Private Methods
    private func checkCellularSpeed() {
        _ = CTTelephonyNetworkInfo()
        
        let dict = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology

        guard let carrierType = dict?.values.first  else {
            return
        }

        switch carrierType {
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            internetView.configure(state: .poorConnection)
            NSLog("2G")

        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            internetView.configure(state: .normal)
            NSLog("3G")

        case CTRadioAccessTechnologyLTE:
            internetView.configure(state: .normal)
            NSLog("4G")

        default:
            NSLog("default")
        }
    }

    // MARK: - Handlers
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {
            return
        }
        
        DispatchQueue.main.async {
            switch reachability.connection {
            case .wifi:
                self.internetView.configure(state: .normal)
                NSLog("Reachable via WiFi")
            case .cellular:
                self.checkCellularSpeed()
                NSLog("Reachable via Cellular")
            case .unavailable:
                self.internetView.configure(state: .noInternet)
                NSLog("Network not reachable")
            case .none:
                self.internetView.configure(state: .noInternet)
                NSLog("Network not reachable")
            }
        }
    }
}
