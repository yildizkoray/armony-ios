//
//  SettingsViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 27.05.22.
//

import UIKit

protocol SettingsViewDelegate: AnyObject, ActivityIndicatorShowing {
    func reloadData()
}

final class SettingsViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .settings

    @IBOutlet private weak var tableView: UITableView!

    var viewModel: SettingsViewModel!

    private lazy var footerView = SettingsVersionInformationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        startActivityIndicatorView()
        configureUI()
        configureTableView()
        viewModel.fetchSettingsData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }

    func configureUI() {
        tableView.setHidden(true)
        view.backgroundColor = .armonyBlack
        tableView.backgroundColor = .clear
    }

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCells(cells: [SettingCell.self])
        navigationItem.title = String("Settings", table: .common)

        footerView.configure(version: "\(Bundle.main.version)")
        tableView.tableFooterView = footerView
    }
}

// MARK: - SettingsViewDelegate
extension SettingsViewController: SettingsViewDelegate {
    func reloadData() {
        stopActivityIndicatorView()
        tableView.setHidden(false)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingCell = tableView.dequeueReusableCell(for: indexPath)
        let setting = viewModel.setting(at: indexPath)
        cell.configure(with: setting)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectSetting(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let tableFooterView = tableView.tableFooterView else {
            return .zero
        }

        let fittedSize = tableFooterView.systemLayoutSizeFitting(
            CGSize(width: tableView.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return fittedSize.height
    }
}
