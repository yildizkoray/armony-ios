//
//  ProfileSelectionViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import Foundation

final class SelectionBottomPopUpViewModel {

    var coordinator: SelectionBottomPopUpCoordinator!
    private weak var view: SelectionBottomPopUpViewDelegate?

    var numberOfRowsInSection: Int {
        return presentation.items.count
    }

    var headerTitle: String {
        return presentation.headerTitle
    }

    var footerViewActionButtonTitle: String {
        return presentation.actionButtonTitle
    }

    private var presentation: any SelectionPresentation {
        didSet {
            view?.reloadData()
        }
    }

    init(view: SelectionBottomPopUpViewDelegate, presentation: any SelectionPresentation) {
        self.view = view
        self.presentation = presentation
    }

    func imageName(for item: SelectionInput) -> String {
        if item.isSelected {
            return presentation.selectedImageName
        }
        return presentation.defaultImageName
    }

    func items(at indexPath: IndexPath) -> SelectionInput {
        return presentation.items[indexPath.row]
    }

    func continueButtonDidTap() {
        coordinator.dismiss { [weak self] in
            guard let self = self else { return }
            self.presentation.continueButtonTapped()
        }
    }

    func willSelectItem(at indexPath: IndexPath, indexPathsForSelectedRows: [IndexPath]?) -> IndexPath? {
        guard let indexPathsForSelectedRows = indexPathsForSelectedRows,
              indexPathsForSelectedRows.count == 10 else {
            return indexPath
        }
        AlertService.show(
            message: String(localized: "Common.SelectionBottomPopUp.Alert.Title", table: "Common+Localizable"),
            actions: [.okay()])
        return nil
    }

    private func selectRow() {
        if let selectedItemIDs = presentation.selectedItemIDs {
            for selectedItemID in selectedItemIDs {
                guard let indexOfSelectedItem = presentation.items.firstIndex(where: { selectedItemID == $0.id }) else { return }
                let indexPathOfSelectedItem = IndexPath(row: indexOfSelectedItem, section: .zero)
                view?.selectRow(at: indexPathOfSelectedItem)
            }
        }
    }
}

// MARK: - ViewModelLifeCycle
extension SelectionBottomPopUpViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.configureUI()
        view?.configureTableView(isMultipleSelectionAllowed: presentation.isMultipleSelectionAllowed)
        selectRow()
        view?.reloadData()
    }
}
