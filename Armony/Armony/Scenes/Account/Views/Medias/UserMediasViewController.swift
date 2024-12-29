//
//  UserMediasViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 12.10.2023.
//

import UIKit

final class UserMediasViewController: UIViewController, ViewController, UITextFieldDelegate, ActivityIndicatorShowing {

    private var youtubeURLString: String? = nil

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let urlString = textField.text {
            youtubeURLString = urlString
        }
    }

    static var storyboardName: UIStoryboard.Name = .none

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    var viewModel: UserMediasViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviewAndConstraintsToSafeArea(tableView)

        view.backgroundColor = .armonyBlack
        startActivityIndicatorView()

        tableView.registerCells(cells: [YoutubeMediaCell.self])
        tableView.isHidden = true
        viewModel.fetchMedias()

        viewModel.didFetchMedias = { [weak self] in
            safeSync {
                self?.tableView.isHidden = false
                self?.stopActivityIndicatorView()
                self?.tableView.reloadData()
            }
        }

        viewModel.stopEmptyStateActionButtomActivityIndicator = { [weak self] in
            safeSync {
                self?.emptyStateView.actionButton.stopActivityIndicatorView()
            }
        }

        viewModel.toggleEmptyState = { [weak self] isEmpty in
            safeSync {
                if isEmpty {
                    let title = String(localized: "MyPerformances.EmptyState.Button.Title", table: "Account+Localizable")
                    let message = String(localized: "MyPerformances.Alert.Message", table: "Account+Localizable")
                    self?.showEmptyStateView(with: .noContent) { _ in
                        AlertService.show(title: title,
                                          message: message,
                                          actions: [.okay(action: {
                            if let url = self?.youtubeURLString?.url {
                                self?.emptyStateView.actionButton.startActivityIndicatorView()
                                self?.viewModel.addNewVideo(url: url.absoluteString)
                            }
                        }), .cancel()], inputPlaceholder: "YouTube link", textFieldDelegate: self!)
                    }
                }
                else {
                    self?.hideEmptyStateView(animated: false)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension UserMediasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * 0.66
    }
}

// MARK: - UITableViewDataSource
extension UserMediasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.presentation.medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = YoutubeMediaCell()
        let videoID = viewModel.presentation.medias[indexPath.row].videoID
        let mediaID = viewModel.presentation.medias[indexPath.row].id
        let videoURL = viewModel.presentation.medias[indexPath.row].url
        cell.configure(with: videoID) { [weak self] in
            self?.viewModel.deleteMedia(id: mediaID, videoURL: videoURL)
        }
        return cell
    }
}

extension UserMediasViewController: EmptyStateShowing {
    var containerEmptyStateView: UIView {
        return tableView
    }
}

// MARK: - EmptyStatePresentation
private extension EmptyStatePresentation {
    static var noContent: EmptyStatePresentation = {
        let title = String(
            localized: "MyPerformances.EmptyState.Title", table: "Account+Localizable"
        ).emptyStateTitleAttributed

        let buttonTitle = String(
            localized: "MyPerformances.EmptyState.Button.Title", table: "Account+Localizable"
        ).emptyStateButtonAttributed

        let presentation = EmptyStatePresentation(title: title, buttonTitle: buttonTitle)
        return presentation
    }()
}
