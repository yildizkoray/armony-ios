//
//  Localization+Backend.swift
//  Armony
//
//  Created by KORAY YILDIZ on 16.08.2025.
//

extension Localization.Table {
    public enum Backend: String, CustomStringConvertible {
        case settings
        case titles
        case advertSkillTitles
        case advertTypes
        case skills
        case genres
        case serviceTypes
        case reportTopics
        case feedbackTopics

        public var description: String {
            return "Backend" + rawValue.titled
        }
    }
}
