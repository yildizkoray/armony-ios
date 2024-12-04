//
//  DropdownViewSnapshotTests.swift
//  ArmonyTests
//
//  Created by KORAY YILDIZ on 26/07/2024.
//


import XCTest
@testable import Armony
import SnapshotTesting

final class DropdownViewSnapshotTests: XCTestCase {

    var sut: DropdownView!

    override func setUp() {
        super.setUp()

        sut = DropdownView(frame: .init(origin: .zero, size: .init(width: 300, height: 40)))
        sut.backgroundColor = .armonyBlack
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testDropdownWithPlaceholder() {
        sut.configure(with: .feedback)

        assertSnapshot(of: sut, as: .image)
    }

    func testDropdownWithTextAndTitle() {
        sut.configure(with: .feedback)
        sut.updateText("Text 1-2-3-4")

        assertSnapshot(of: sut, as: .image)
    }

    func testDropdownWithTextAndTitleLoadingState() {
        sut.configure(with: .feedback)
        sut.updateText("Text 1-2-3-4")
        sut.startActivityIndicatorView()

        assertSnapshot(of: sut, as: .image)
    }
}
