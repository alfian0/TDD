//
//  OTPViewModel.swift
//  TextValidator
//
//  Created by Alfian on 07/10/24.
//

import Combine
import Foundation

final class OTPViewModel: ObservableObject {
    @Published var otpText: String = ""
    @Published private(set) var isEnableOtherAction: Bool = false
    @Published private(set) var canSubmit: Bool = false
    @Published private(set) var timer: String = ""

    var title: String
    var subtitle: String
    var count = 6

    private let didSuccess: () -> Void
    private let verificationID: String
    private let otpVerifyUsecase: DefaultOTPVerifyUsecase

    private var timeRemaining = 10
    private var timerCancellable: AnyCancellable?
    private var coordinator: OTPCoordinator
    private var cancellables = Set<AnyCancellable>()

    init(
        type: OTPType,
        verificationID: String,
        otpVerifyUsecase: DefaultOTPVerifyUsecase,
        coordinator: OTPCoordinator,
        didSuccess: @escaping () -> Void
    ) {
        title = type.title
        subtitle = type.subtitle
        self.coordinator = coordinator
        self.verificationID = verificationID
        self.otpVerifyUsecase = otpVerifyUsecase
        self.didSuccess = didSuccess

        $otpText
            .map { [weak self] value in
                guard let self = self else { return false }
                return value.count == count
            }
            .assign(to: &$canSubmit)

        start()
    }

    func start() {
        timeRemaining = 10
        timerCancellable = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.timeRemaining -= 1

                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.minute, .second]
                formatter.zeroFormattingBehavior = [.pad]
                formatter.unitsStyle = .positional
                self.timer = formatter.string(from: TimeInterval(self.timeRemaining)) ?? ""
                self.isEnableOtherAction = self.timeRemaining <= 0

                if self.timeRemaining <= 0 {
                    timerCancellable?.cancel()
                    timerCancellable = nil
                    self.timer = ""
                }
            }
    }

    func next() {
        otpVerifyUsecase.execute(verificationID: verificationID, verificationCode: otpText)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    didSuccess()
                case let .failure(error):
                    coordinator.present(.error(title: "Error", subtitle: error.localizedDescription, didDismiss: {}))
                }
            }
            .store(in: &cancellables)
    }
}
