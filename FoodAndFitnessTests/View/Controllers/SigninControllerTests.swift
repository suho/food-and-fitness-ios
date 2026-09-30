//
//  SigninControllerTests.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 6/22/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import XCTest
@testable import FoodAndFitness

class SigninControllerTests: XCTestCase {
    var ex: XCTestExpectation?

    override func setUp() {
        super.setUp()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(viewDidUpdated), name: .viewDidUpdated, object: nil)
    }

    override func tearDown() {
        let nc = NotificationCenter.default
        nc.removeObserver(self)
        super.tearDown()
    }
    
    func testLoad() {
        let vm = SignInViewModel.standard
        let vc = SignInController()
        vc.loadViewIfNeeded()
        vc.viewModel = vm
        XCTAssertNotNil(vc.mailField)
        XCTAssertEqual(vc.mailField.text, vm.mail)
        XCTAssertNotNil(vc.passField)
        XCTAssertEqual(vc.passField.text, vm.password)
    }

    func testErrorSignIn() {
        ex = expectation(description: "Signin action")
        let vm = SignInViewModel.error
        let vc = SignInController()
        vc.loadViewIfNeeded()
        vc.mailField.text = vm.mail
        vc.passField.text = vm.password
        vc.signInButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.viewModel.mail, vm.mail)
        XCTAssertEqual(vc.viewModel.password, vm.password)
        waitForExpectations(timeout: Timeout.forRequest)
    }

    func testAction() {
        ex = expectation(description: "Signin action")
        let vm = SignInViewModel.standard
        let vc = SignInController()
        vc.loadViewIfNeeded()
        vc.mailField.text = vm.mail
        vc.passField.text = vm.password
        vc.signInButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.viewModel.mail, vm.mail)
        XCTAssertEqual(vc.viewModel.password, vm.password)
        waitForExpectations(timeout: Timeout.forRequest)
    }

    func testGetData() {
        ex = expectation(description: "Get Data")
        let vm = SignInViewModel.standard
        let vc = SignInController()
        vc.loadViewIfNeeded()
        vc.viewModel = vm
        vc.signInButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: Timeout.forRequest)
    }

    @objc private func viewDidUpdated() {
        ex?.fulfill()
    }
}

extension SignInViewModel {
    static var standard: SignInViewModel {
        let vm = SignInViewModel(user: nil)
        vm.mail = "hovansu0@gmail.com"
        vm.password = "1234" + "5678"
        return vm
    }

    static var error: SignInViewModel {
        let vm = SignInViewModel(user: nil)
        vm.mail = "hovansu10@gmail.com"
        vm.password = "1234" + "567899"
        return vm
    }
}
