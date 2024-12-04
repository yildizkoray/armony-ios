//
//  SelectionBottomPopUpViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import UIKit
import BottomPopup

protocol SelectionBottomPopUpViewDelegate: AnyObject, ActivityIndicatorShowing {
    func configureUI()
    func configureTableView(isMultipleSelectionAllowed: Bool)
    func selectRow(at indexPath: IndexPath)
    func reloadData()
}

final class SelectionBottomPopUpViewController: BottomPopupViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .account

    @IBOutlet private weak var headerContainerStackView: UIStackView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: SelectionBottomPopUpViewModel!

    override var popupPresentDuration: Double {
        return Common.Durations.BottomPopUp.present
    }

    override var popupDismissDuration: Double {
        return Common.Durations.BottomPopUp.dismiss
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let possibleHeight = min(
            tableView.contentSize.height + headerContainerStackView.bounds.size.height + UIApplication.safeAreaInsets.bottom,
            UIScreen.main.bounds.height * 0.8
        )
        updatePopupHeight(to: possibleHeight)
    }

    private func setDismissButton() {
        let button = UIButton(type: .system)
        button.setImage(.arrowDownIcon.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        headerContainerStackView.addSubview(button)
        headerContainerStackView.bringSubviewToFront(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28),
            button.topAnchor.constraint(equalTo: headerContainerStackView.topAnchor, constant: 16.0),
            button.trailingAnchor.constraint(equalTo: headerContainerStackView.trailingAnchor, constant: -24)
        ])

        button.touchUpInsideAction = { [unowned self] _ in
            self.viewModel.coordinator.dismiss()
        }
    }

}

// MARK: - ProfileSelectionViewDelegate
extension SelectionBottomPopUpViewController: SelectionBottomPopUpViewDelegate {
    func configureUI() {
        view.backgroundColor = .armonyBlack
        tableView.backgroundColor = .clear
        headerTitleLabel.textColor = .armonyWhite
        headerTitleLabel.font = .semiboldTitle
        headerTitleLabel.text = viewModel.headerTitle
        setDismissButton()
    }

    func configureTableView(isMultipleSelectionAllowed: Bool) {
        tableView.registerSectionHeaderFooters(aClasses: [SelectionBottomPopUpFooterView.self])
        tableView.registerCells(cells: [SelectionCell.self])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = isMultipleSelectionAllowed
    }

    func reloadData() {
        tableView.reloadData()
    }

    func selectRow(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}

// MARK: - UITableViewDelegate
extension SelectionBottomPopUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SelectionCell {
            var item = viewModel.items(at: indexPath)
            if item.isSelected && cell.isSelected {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            item.isSelected.toggle()
            let imageName = viewModel.imageName(for: item)
            cell.updateSelectionStateImageView(imageName: imageName)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var item = viewModel.items(at: indexPath)
        item.isSelected.toggle()
        if let cell = tableView.cellForRow(at: indexPath) as? SelectionCell {
            let imageName = viewModel.imageName(for: item)
            cell.updateSelectionStateImageView(imageName: imageName)
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return viewModel.willSelectItem(at: indexPath, indexPathsForSelectedRows: tableView.indexPathsForSelectedRows)
    }
}

// MARK: - SelectionBottomPopUpViewController
extension SelectionBottomPopUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectionCell = tableView.dequeueReusableCell(for: indexPath)
        let item = viewModel.items(at: indexPath)
        let imageName = viewModel.imageName(for: item)
        cell.configure(with: item, imageName: imageName)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: SelectionBottomPopUpFooterView = tableView.dequeueReusableHeaderFooterView()
        footerView.configure(with: viewModel.footerViewActionButtonTitle)
        footerView.continueButtonTapped = { [weak self] in
            self?.viewModel.continueButtonDidTap()
        }
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let tableFooterView: SelectionBottomPopUpFooterView = tableView.dequeueReusableHeaderFooterView()

        let fittedSize = tableFooterView.systemLayoutSizeFitting(
            CGSize(width: tableView.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return fittedSize.height
    }
}
