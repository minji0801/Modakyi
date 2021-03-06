//
//  NetworkCheck.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/13.
//  네트워크 연결 확인

import Foundation
import Network

final class NetworkCheck {
    static let shared = NetworkCheck()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown

    /// 연결타입
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }

    /// monotior 초기화
    private init() {
        monitor = NWPathMonitor()
    }

    /// Network Monitoring 시작
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            self.isConnected = path.status == .satisfied
            self.getConnectionType(path)

            if self.isConnected == true {
                print("연결됨!")
            } else {
                print("연결안됨!")
                showNetworkVCOnRoot()
            }
        }
    }

    /// Network Monitoring 종료
    public func stopMonitoring() {
        monitor.cancel()
    }

    /// Network 연결 타입
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
