//
//  URL+Extension.swift
//  TextValidator
//
//  Created by Alfian on 25/10/24.
//

import Foundation

extension URL {
    func handleDeeplinkType(type: DeeplinkType, completion: (Result<[DeeplinkItem], Error>) -> Void) {
        guard scheme == type.scheme else {
            completion(.failure(DeeplinkError.invalid))
            return
        }
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            completion(.failure(DeeplinkError.invalid))
            return
        }
        guard let host = components.host, host == type.host else {
            completion(.failure(DeeplinkError.invalid))
            return
        }
        guard components.path == type.path else {
            completion(.failure(DeeplinkError.invalid))
            return
        }
        let queryItems = components.queryItems?.filter { type.items.contains($0.name) } ?? []
        guard queryItems.count == type.items.count else {
            completion(.failure(DeeplinkError.invalid))
            return
        }
        let items = queryItems.map { DeeplinkItem(name: $0.name, value: $0.value) }
        completion(.success(items))
    }

    func handleDeeplinkType(type: DeeplinkType) async throws -> [DeeplinkItem] {
        return try await withCheckedThrowingContinuation { continuation in
            handleDeeplinkType(type: type) { result in
                continuation.resume(with: result)
            }
        }
    }
}
