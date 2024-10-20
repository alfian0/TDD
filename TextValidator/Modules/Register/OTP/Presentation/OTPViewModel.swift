//
//  OTPViewModel.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Combine
import Foundation

@MainActor
final class OTPViewModel: ObservableObject {
    @Published var otpText: String = ""
    @Published private(set) var isEnableOtherAction: Bool = false
    @Published private(set) var canSubmit: Bool = false
    @Published private(set) var timer: String = ""

    var title: String
    var subtitle: String
    var count = 6

    private let didResend: () -> Void
    private let didChange: () -> Void
    private let didSuccess: (String) -> Void

    private var duration = 10
    private var timerCancellable: AnyCancellable?
    private var coordinator: OTPCoordinator
    private var cancellables = Set<AnyCancellable>()

    init(
        title: String,
        subtitle: String,
        count: Int = 6,
        duration: Int = 10,
        coordinator: OTPCoordinator,
        didResend: @escaping () -> Void,
        didChange: @escaping () -> Void,
        didSuccess: @escaping (String) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.count = count
        self.duration = duration
        self.coordinator = coordinator
        self.didResend = didResend
        self.didChange = didChange
        self.didSuccess = didSuccess

        $otpText
            .map { value in
                value.count == count
            }
            .assign(to: &$canSubmit)
    }

    func start() {
        guard timerCancellable == nil else {
            return
        }
        duration = 10
        timerCancellable = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.duration -= 1

                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.minute, .second]
                formatter.zeroFormattingBehavior = [.pad]
                formatter.unitsStyle = .positional
                self.timer = formatter.string(from: TimeInterval(self.duration)) ?? ""
                self.isEnableOtherAction = self.duration <= 0

                if self.duration <= 0 {
                    timerCancellable?.cancel()
                    timerCancellable = nil
                    self.timer = ""
                }
            }
    }

    func next() {
        didSuccess(otpText)
    }

    func resend() {
        didResend()
    }

    func change() {
        didChange()
    }
}
