//
//  CommonUI+Localizable.swift
//  Armony
//
//  Created by Koray Yildiz on 09.12.22.
//

import Foundation

extension Localization {
    struct CommonUI {
        // MARK: - Dropdown
        enum Dropdown: String, Localizable {
            // Feedback
            case feedbackTitle = "CommonUI.Dropdown.Feedback.Title"
            case feedbackPlaceholder = "CommonUI.Dropdown.Feedback.Placeholder"

            var fileName: String {
                return "CommonUI+Localizable"
            }
        }

        // MARK: - TextView
        enum TextView: String, Localizable {
            // Feedback
            case feedbackPlaceholder = "CommonUI.TextView.Feedback.Placeholder"

            var fileName: String {
                return "CommonUI+Localizable"
            }
        }
    }
}
