//
//  NetworkCheck.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/13.
//

import Foundation
import UIKit
import Network

final class NetworkCheck {
    static let shared = NetworkCheck()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    // 연결타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        print("init 호출")
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        print("startMonitoring 호출")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("path : \(path)")
            
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
            
            if self?.isConnected == true {
                print("연결됨!")
            } else {
                print("연결안됨!")
                showNetworkViewController()
            }
        }
    }
    
    public func stopMonitoring() {
        print("stopMonitoring 호출")
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        print("getConnectionType 호출")
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
            print("wifi에 연결")
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")
        } else {
            connectionType = .unknown
            print("unknown..")
        }
    }
}

func showNetworkViewController() {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    DispatchQueue.main.async {
        let networkViewController = storyboard.instantiateViewController(withIdentifier: "NetworkViewController")
        networkViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(networkViewController, sender: nil)
    }
}
