//
//  AppAssembler.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

import Swinject

@MainActor
final class AppAssembler {
    private init() {}
    static let shared: Assembler = .init([
        RepositoryAssembler(),
        UseCaseAssembler(),
        OCRUsecaseAssembler(),
        TextValidationUsecase(),
        ServiceAssembler(),
        LoginViewAssembler(),
        OCRViewAssembler(),
        ContactViewAssembler(),
        CountryCodeViewAssembler(),
        EmailViewAssembler(),
        OTPViewAssembler(),
        PasswordViewAssembler(),
    ])
}
