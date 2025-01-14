//
//  VisitedAccountMediasViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 18.10.2023.
//

import UIKit

final class VisitedAccountMediasViewController: UIViewController, ViewController, ActivityIndicatorShowing, EmptyStateShowing {

    static var storyboardName: UIStoryboard.Name = .none

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    var viewModel: VisitedAccountMediasViewModel!

    var containerEmptyStateView: UIView {
        tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViews()
        viewModel.fetchMedias()

        viewModel.didFetchMedias = { [weak self] in
            safeSync {
                self?.tableView.isHidden = false
                self?.stopActivityIndicatorView()
                self?.tableView.reloadData()
                self?.toggleEmptyState()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }

    fileprivate func prepareViews() {
        view.addSubviewAndConstraintsToSafeArea(tableView)

        view.backgroundColor = .armonyBlack
        startActivityIndicatorView()

        tableView.registerCells(cells: [VisitedAccountYoutubeMediaCell.self])
        tableView.isHidden = true
    }

    private func toggleEmptyState() {
        if viewModel.presentation.medias.isEmpty {
            let noContent = EmptyStatePresentation(title: String("VisitedAccount.Medias.EmptyState.Title", table: .account))
            showEmptyStateView(with: noContent)
        }
        else {
            hideEmptyStateView(animated: false)
        }
    }
}

// MARK: - UITableViewDelegate
extension VisitedAccountMediasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * 0.6
    }
}

// MARK: - UITableViewDataSource
extension VisitedAccountMediasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.presentation.medias.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = VisitedAccountYoutubeMediaCell()
        let videoID = viewModel.presentation.medias[indexPath.row].videoID
        cell.configure(with: videoID)
        return cell
    }
}
