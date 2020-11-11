//
//  UIViewControllerConnectivity.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 11/11/20.
//

import UIKit
import Network

extension UIViewController {
    
    func checkInternetConnectivity(monitor: NWPathMonitor) {
        // Configure completion for whenever connection status changes
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    self.present(AlertManager().poorNetworkConnection, animated: true)
                }
            }
        }
        // Start monitoring status
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
}
