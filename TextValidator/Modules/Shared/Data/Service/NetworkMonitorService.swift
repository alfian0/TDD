//
//  NetworkMonitorService.swift
//  TextValidator
//
//  Created by Alfian on 24/10/24.
//

import Network

final class NetworkMonitorService {
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let monitor: NWPathMonitor
    private var isMonitoring = false

    init() {
        monitor = NWPathMonitor()
    }

    func isConnected() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            monitor.pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                if path.status == .satisfied {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
                self.stopMonitoring() // Stop the monitor after getting the result
            }
            startMonitoring()
        }
    }

    private func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        monitor.start(queue: queue)
    }

    private func stopMonitoring() {
        guard isMonitoring else { return }
        isMonitoring = false
        monitor.cancel()
    }
}
