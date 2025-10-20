//
//  MockLoginCoordinator.swift
//  Armony
//
//  Created by KORAY YILDIZ on 20.10.2025.
//


@testable import Armony

public final class MockLoginCoordinator: LoginCoordinator {

    convenience init() {
        self.init(navigator: nil)
    }

    var invokedNavigatorSetter = false
    var invokedNavigatorSetterCount = 0
    var invokedNavigator: Navigator?
    var invokedNavigatorList = [Navigator?]()
    var invokedNavigatorGetter = false
    var invokedNavigatorGetterCount = 0
    var stubbedNavigator: Navigator!

    public override var navigator: Navigator? {
        set {
            invokedNavigatorSetter = true
            invokedNavigatorSetterCount += 1
            invokedNavigator = newValue
            invokedNavigatorList.append(newValue)
        }
        get {
            invokedNavigatorGetter = true
            invokedNavigatorGetterCount += 1
            return stubbedNavigator
        }
    }

    var invokedStart = false
    var invokedStartCount = 0
    var invokedStartParameters: (loginCompletion: VoidCallback?, registrationCompletion: VoidCallback?)?
    var invokedStartParametersList = [(loginCompletion: VoidCallback?, registrationCompletion: VoidCallback?)]()
    var shouldInvokeLoginCompletion = false
    var shouldInvokeRegistrationCompletion = false

    public override func start(loginCompletion: VoidCallback?, registrationCompletion: VoidCallback?) {
        invokedStart = true
        invokedStartCount += 1
        invokedStartParameters = (loginCompletion, registrationCompletion)
        invokedStartParametersList.append((loginCompletion, registrationCompletion))

        if shouldInvokeLoginCompletion {
            loginCompletion?()
        }

        if shouldInvokeRegistrationCompletion {
            registrationCompletion?()
        }
    }

    var invokedRegistration = false
    var invokedRegistrationCount = 0
    var invokedRegistrationParameters: (registrationCompletion: VoidCallback?, loginCompletion: VoidCallback?)?
    var invokedRegistrationParametersList = [(registrationCompletion: VoidCallback?, loginCompletion: VoidCallback?)]()

    public override func registration(registrationCompletion: VoidCallback?, loginCompletion: VoidCallback?) {
        invokedRegistration = true
        invokedRegistrationCount += 1
        invokedRegistrationParameters = (registrationCompletion, loginCompletion)
        invokedRegistrationParametersList.append((registrationCompletion, loginCompletion))
    }

    var invokedShowForgotPasswordView = false
    var invokedShowForgotPasswordViewCount = 0
    var invokedShowForgotPasswordViewParameters: (email: String, actionButtonTapped: Callback<String>?)?
    var invokedShowForgotPasswordViewParametersList = [(email: String, actionButtonTapped: Callback<String>?)]()

    public override func showForgotPasswordView(email: String, actionButtonTapped: Callback<String>?) {
        invokedShowForgotPasswordView = true
        invokedShowForgotPasswordViewCount += 1
        invokedShowForgotPasswordViewParameters = (email, actionButtonTapped)
        invokedShowForgotPasswordViewParametersList.append((email, actionButtonTapped))
    }
}
