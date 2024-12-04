//
//  PlaceAdvertViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 04.10.22.
//

import UIKit

protocol PlaceAdvertViewDelegate: AnyObject, NavigationBarCustomizing {
    func configureMusicGenreDropdownView(presentation: DropdownPresentation)
    func configureSkillDropdownView(presentation: DropdownPresentation)

    func updateAdvertType(title: String?)
    func updateSkills(title: String?)
    func updateLocation(title: String?)
    func updateMusicGenres(title: String?)
    func updateInstructionType(title: String?)

    func setInformationsStackViewVisibility(isHidden: Bool)

    func startAdvertTypeDropdownViewActivityIndicatorView()
    func stopAdvertTypeDropdownViewActivityIndicatorView()

    func startSkillsDropdownViewActivityIndicatorView()
    func stopSkillsDropdownViewActivityIndicatorView()

    func startMusicGenresDropdownViewActivityIndicatorView()
    func stopMusicGenresDropdownViewActivityIndicatorView()
    func setMusicGenresDropdownViewVisibility(isHidden: Bool)

    func startLocationDropdownViewActivityIndicatorView()
    func stopLocationDropdownViewActivityIndicatorView()

    func startInstructionTypeDropdownViewActivityIndicatorView()
    func stopInstructionTypeDropdownViewActivityIndicatorView()
    func setInstructionTypeDropdownViewVisibility(isHidden: Bool)

    func startSubmitButtonActivityIndicatorView()
    func stopSubmitButtonActivityIndicatorView()

    func updateValidators(validator: PlaceAdvertViewController.Validators)

    func resetTextView()
}

final class PlaceAdvertViewController: UIViewController, ViewController {

    enum Validators {
        case musician
        case brand
        case instructor
        case contractor
        case event
    }

    static var storyboardName: UIStoryboard.Name = .placeAdvert

    @IBOutlet private weak var headerGradientView: GradientView!
    @IBOutlet private weak var navigationSubtitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var advertTypesDropdownView: ValidatableDropdownView!

    @IBOutlet private weak var informationsStackView: UIStackView!
    @IBOutlet private weak var musicGenresDropdownView: ValidatableDropdownView!
    @IBOutlet private weak var skillsDropdownView: ValidatableDropdownView!
    @IBOutlet private weak var locationDropdownView: ValidatableDropdownView!
    @IBOutlet private weak var descriptionTextView: TextView!

    @IBOutlet private weak var submitButton: UIButton!

    private lazy var instructionTypeDropdownView: ValidatableDropdownView = {
        let dropdown = ValidatableDropdownView()
        dropdown.isHidden = true
        dropdown.configure(with: .instructionType)
        return dropdown
    }()

    var viewModel: PlaceAdvertViewModel!

    private lazy var defaultValidationResponders = ValidationResponders(
        required: [
            advertTypesDropdownView, musicGenresDropdownView, skillsDropdownView, locationDropdownView
        ]
    )

    private lazy var instructorValidationResponders = ValidationResponders(
        required: [
            advertTypesDropdownView,
            instructionTypeDropdownView,
            skillsDropdownView,
            locationDropdownView
        ]
    )

    private lazy var othersValidationResponders = ValidationResponders(
        required: [
            advertTypesDropdownView,
            skillsDropdownView,
            locationDropdownView
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .armonyBlack

        configureSubmitButton()
        makeNavigationBarTransparent()
        prepareDropdowns()
        prepareTitleLabels()

        setInformationsStackViewVisibility(isHidden: true)

        headerGradientView.configure(with: .init(orientation: .vertical, color: .profile))
        descriptionTextView.delegate = self
        descriptionTextView.configure(with: .description)

        view.addTapGestureRecognizer(cancelsTouches: false) { [weak self] _ in
            self?.view.endEditing(true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationBarTransparent()

        defaultValidationResponders.didValidate = { [weak self] result in
            self?.submitButton.isEnabled = result.isValid
            self?.submitButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }

        instructorValidationResponders.didValidate = { [weak self] result in
            self?.submitButton.isEnabled = result.isValid
            self?.submitButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }

        othersValidationResponders.didValidate = { [weak self] result in
            self?.submitButton.isEnabled = result.isValid
            self?.submitButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }
    }

    fileprivate func configureSubmitButton() {
        submitButton.isEnabled = false
        submitButton.setTitle(
            String("PlaceAdvert", table: .placeAdvert),
            for: .normal
        )
        submitButton.setTitleColor(.armonyWhite, for: .normal)
        submitButton.setTitleColor(.armonyWhiteMedium, for: .disabled)
        submitButton.titleLabel?.font = .semiboldHeading
        submitButton.backgroundColor = .armonyPurpleLow
        submitButton.makeAllCornersRounded(radius: .medium)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc private func submitButtonTapped() {
        view.endEditing(true)
        viewModel.submitButtonTapped()
    }

    private func prepareDropdowns() {
        advertTypesDropdownView.configure(with: .advertType)
        advertTypesDropdownView.addTapGestureRecognizer(cancelsTouches: false) { [unowned self] _ in
            self.view.endEditing(true)
            self.viewModel.advertTypeDropdownTapped()
        }

        musicGenresDropdownView.configure(with: .musicGenres)
        musicGenresDropdownView.addTapGestureRecognizer { [unowned self] _ in
            self.view.endEditing(true)
            self.viewModel.musicGenresDropdownTapped()
        }

        skillsDropdownView.configure(with: .skill)
        skillsDropdownView.addTapGestureRecognizer { [unowned self] _ in
            self.view.endEditing(true)
            self.viewModel.skillsDropdownTapped()
        }

        locationDropdownView.configure(with: .location)
        locationDropdownView.addTapGestureRecognizer { [unowned self] _ in
            self.view.endEditing(true)
            self.viewModel.locationDropdownTapped()
        }

        informationsStackView.insertArrangedSubview(instructionTypeDropdownView, at: .zero)
        instructionTypeDropdownView.addTapGestureRecognizer { [unowned self] _ in
            self.view.endEditing(true)
            self.viewModel.instructionTypeDropdownView()
        }
    }

    private func prepareTitleLabels() {
        navigationSubtitleLabel.font = .regularSubheading
        navigationSubtitleLabel.textColor = .armonyWhite
        navigationSubtitleLabel.text = String("TitleDescription", table: .placeAdvert)

        titleLabel.font = .semiboldTitle
        titleLabel.textColor = .armonyWhite
        titleLabel.text = String("LargeTitle", table: .placeAdvert)
    }
}

// MARK: - PlaceAdvertViewDelegate
extension PlaceAdvertViewController: PlaceAdvertViewDelegate {
    func startInstructionTypeDropdownViewActivityIndicatorView() {
        instructionTypeDropdownView.startActivityIndicatorView()
    }
    
    func stopInstructionTypeDropdownViewActivityIndicatorView() {
        instructionTypeDropdownView.stopActivityIndicatorView()
    }

    func setInstructionTypeDropdownViewVisibility(isHidden: Bool) {
        instructionTypeDropdownView.isHidden = isHidden
    }

    func setMusicGenresDropdownViewVisibility(isHidden: Bool) {
        musicGenresDropdownView.isHidden = isHidden
    }

    func configureMusicGenreDropdownView(presentation: DropdownPresentation) {
        musicGenresDropdownView.configure(with: presentation)
    }

    func configureSkillDropdownView(presentation: DropdownPresentation) {
        skillsDropdownView.configure(with: presentation)
    }

    func updateAdvertType(title: String?) {
        advertTypesDropdownView.updateText(title)
    }

    func updateSkills(title: String?) {
        skillsDropdownView.updateText(title)
    }

    func updateLocation(title: String?) {
        locationDropdownView.updateText(title)
    }

    func updateMusicGenres(title: String?) {
        musicGenresDropdownView.updateText(title)
    }

    func updateInstructionType(title: String?) {
        instructionTypeDropdownView.updateText(title)
        instructionTypeDropdownView.revalidate()
    }

    func setInformationsStackViewVisibility(isHidden: Bool) {
        informationsStackView.isHidden = isHidden
    }

    func startAdvertTypeDropdownViewActivityIndicatorView() {
        advertTypesDropdownView.startActivityIndicatorView()
    }

    func stopAdvertTypeDropdownViewActivityIndicatorView() {
        advertTypesDropdownView.stopActivityIndicatorView()
    }

    func startSkillsDropdownViewActivityIndicatorView() {
        skillsDropdownView.startActivityIndicatorView()
    }

    func stopSkillsDropdownViewActivityIndicatorView() {
        skillsDropdownView.stopActivityIndicatorView()
    }

    func startMusicGenresDropdownViewActivityIndicatorView() {
        musicGenresDropdownView.startActivityIndicatorView()
    }

    func stopMusicGenresDropdownViewActivityIndicatorView() {
        musicGenresDropdownView.stopActivityIndicatorView()
    }

    func startLocationDropdownViewActivityIndicatorView() {
        locationDropdownView.startActivityIndicatorView()
    }

    func stopLocationDropdownViewActivityIndicatorView() {
        locationDropdownView.stopActivityIndicatorView()
    }

    func startSubmitButtonActivityIndicatorView() {
        submitButton.startActivityIndicatorView()
    }

    func stopSubmitButtonActivityIndicatorView() {
        submitButton.stopActivityIndicatorView()
    }

    func updateValidators(validator: PlaceAdvertViewController.Validators) {
        switch validator {
        case .musician, .brand:
            break
        case .instructor:
            break
        default:
            break
        }
    }

    func resetTextView() {
        descriptionTextView.updateText(.empty)
    }
}

// MARK: - TextViewDelegate
extension PlaceAdvertViewController: TextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.descriptionTextViewDidChange(description: textView.text)
    }
}

