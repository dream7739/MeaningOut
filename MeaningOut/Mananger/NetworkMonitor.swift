//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/22/24.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    var isConnected = false
    var connectionType = ConnectionType.unknown
    
    private init(){ }
    
    func startMonitoring(){
        monitor.start(queue: queue)
     
        monitor.pathUpdateHandler = { [weak self] path in
            
            if path.status == .satisfied {
                self?.isConnected = true
            }else{
                self?.isConnected = false
            }
        }
    }
    
     func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
            print("wifi에 연결")
            
        }else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")
        }else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")
        }else {
            connectionType = .unknown
            print("unknown")
        }
    }
}

extension NetworkMonitor {
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
}
