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
        print(#function)
        monitor.start(queue: queue)
        
        //네트워크 경로 변경 시 호출할 블록. start가 호출될 때까지 호출되지 않음
        //NWPath.Status
        //해당 경로 네트워크가 가능 > satisfied
        //해당 경로 네트워크가 불가능 > unsatisfied
        //해당 경로 네트워크 불가능하지만 연결을 시도 > requiresConnection
        monitor.pathUpdateHandler = { [weak self] path in
            print("path: \(path)")
            
            if path.status == .satisfied {
                self?.isConnected = true
            }else{
                self?.isConnected = false
            }
            
            self?.getConnectionType(path)
            
            if self?.isConnected == true {
                print("연결이 된 상태")
            }else{
                print("연결이 안된 상태")
            }
            
        }
    }
    
     func stopMonitoring(){
        print(#function)
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
