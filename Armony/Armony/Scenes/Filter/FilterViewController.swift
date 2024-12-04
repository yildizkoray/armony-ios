//
//  FilterViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 08.06.23.
//

import UIKit

protocol FilterViewDelegate: AnyObject, NavigationBarCustomizing {
    func updateAdvertType(title: String?)
    func updateLocation(title: String?)

    func startAdvertTypeDropdownViewActivityIndicatorView()
    func stopAdvertTypeDropdownViewActivityIndicatorView()

    func startLocationDropdownViewActivityIndicatorView()
    func stopLocationDropdownViewActivityIndicatorView()
}

final class FilterViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .none

    var viewModel: FilterViewModel!

    private lazy var clearFilterLeftButton = UIButton(type: .system)

    private lazy var filtersStackView: UIStackView = {
        let config = UIStackView.Configuration(
            spacing: .sixteen, axis: .vertical, layoutMargins: UIEdgeInsets(edges: .sixteen)
        )
        let stackView = UIStackView(
            arrangedSubviews: [advertTypeDropdownView, locationDropdownView, UIView(), applyButton], config: config
        )
        return stackView
    }()

    private lazy var advertTypeDropdownView: DropdownView = {
        let dropdown = DropdownView()
        dropdown.configure(with: .advertType)
        return dropdown
    }()

    private lazy var locationDropdownView: DropdownView = {
        let dropdown = DropdownView()
        dropdown.configure(with: .location)
        return dropdown
    }()

    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonConfiguration = UIButton.Config(title: String("Apply", table: .common),
                                                  titleColor: .white,
                                                  titleFont: .semiboldSubheading,
                                                  backgroundColor: .purple,
                                                  rounded: .init(radius: .medium),
                                                  border: .init(radius: .default))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.configure(with: buttonConfiguration)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String("Filter.Title", table: .common)
        view.backgroundColor = .armonyBlack
        view.addSubviewAndConstraintsToSafeArea(filtersStackView)
        setNavigationBarBackgroundColor(color: .armonyBlack)

        locationDropdownView.addTapGestureRecognizer { [unowned self] _ in
            self.viewModel.locationDropdownTapped()
        }

        advertTypeDropdownView.addTapGestureRecognizer { [unowned self] _ in
            self.viewModel.advertTypeDropdownTapped()
        }

        applyButton.touchUpInsideAction = { [weak self] _ in
            self?.viewModel.applyButtonTapped()
        }

        clearFilterLeftButton.touchUpInsideAction = { [weak self] _ in
            self?.viewModel.filters = .empty
            self?.updateLocation(title: nil)
            self?.updateAdvertType(title: nil)
        }
        
        let clearTitle = String("Clear", table: .common)
        clearFilterLeftButton.configure(
            with: .init(title: clearTitle, titleColor: .white04, titleFont: .lightBody, backgroundColor: .clear)
        )

        if !viewModel.filters.isEmpty {
            clearFilterLeftButton.configure(
                with: .init(title: clearTitle, titleColor: .white, titleFont: .lightBody, backgroundColor: .clear)
            )
            updateLocation(title: viewModel.filters.location?.title)
            updateAdvertType(title: viewModel.filters.advert?.title)
        }

        viewModel.filterDidUpdate = { [weak self] filters in
            let config = UIButton.Config(
                title: clearTitle,
                titleColor: filters.isEmpty ? .white04 : .white,
                titleFont: .lightBody,
                backgroundColor: .clear
            )
            self?.clearFilterLeftButton.configure(with: config)
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: clearFilterLeftButton)

        setDismissButton { [weak self] in
            self?.viewModel.coordinator.dismiss(animated: true)
        }
    }
}

// MARK: - FilterViewDelegate
extension FilterViewController: FilterViewDelegate {
    func startAdvertTypeDropdownViewActivityIndicatorView() {
        advertTypeDropdownView.startActivityIndicatorView()
    }

    func stopAdvertTypeDropdownViewActivityIndicatorView() {
        advertTypeDropdownView.stopActivityIndicatorView()
    }

    func startLocationDropdownViewActivityIndicatorView() {
        locationDropdownView.startActivityIndicatorView()
    }

    func stopLocationDropdownViewActivityIndicatorView() {
        locationDropdownView.stopActivityIndicatorView()
    }

    func updateAdvertType(title: String?) {
        advertTypeDropdownView.updateText(title)
    }

    func updateLocation(title: String?) {
        locationDropdownView.updateText(title)
    }
}
