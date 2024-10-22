//
//  OTPViewAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

@MainActor
final class OTPViewAssembler: @preconcurrency Assembly {
    func assemble(container: Swinject.Container) {
        container.register(OTPCoordinator.self) { _, n in
            OTPCoordinator(navigationController: n)
        }

        container.register(OTPViewModel.self) {
            (_, t: String, s: String, c: Int, d: Int, cr: OTPCoordinator, dr: @escaping () -> Void, dc: @escaping () -> Void, ds: @escaping (String) -> Void) in
            OTPViewModel(
                title: t,
                subtitle: s,
                count: c,
                duration: d,
                coordinator: cr,
                didResend: dr,
                didChange: dc,
                didSuccess: ds
            )
        }

        container.register(OTPView.self) {
            (r, t: String, s: String, c: Int, d: Int, cr: OTPCoordinator, dr: @escaping () -> Void, dc: @escaping () -> Void, ds: @escaping (String) -> Void) in
            guard let viewModel = r.resolve(OTPViewModel.self, arguments: t, s, c, d, cr, dr, dc, ds) else {
                fatalError()
            }
            return OTPView(viewModel: viewModel)
        }
    }
}
