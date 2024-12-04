//
//  ProfileViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 31.05.22.
//

import UIKit
import MobileCoreServices

protocol ProfileViewDelegate: AnyObject, NavigationBarCustomizing {
    var newAvatarImageData: Data? { get }

    func configureUI()

    func configureAvatarView(with presentation: AvatarPresentation)
    func configureTitleDropdownView(with presentation: DropdownPresentation)
    func configureSkillsDropdownView(with presentation: DropdownPresentation)
    func configureMusicGenresDropdownView(with presentation: DropdownPresentation)
    func configureLocationDropdownView(with presentation: DropdownPresentation)
    func configureBioTextView(with presentation: TextViewPresentation)
    func updateBioTextView(bio: String)

    func updateTitle(title: String?)
    func updateSkills(title: String?)
    func updateMusicGenres(title: String?)
    func updateLocation(title: String?)

    func startSaveButtonActivityIndicatorView()
    func stopSaveButtonActivityIndicatorView()

    func startTitleDropdownViewActivityIndicatorView()
    func stopTitleDropdownViewActivityIndicatorView()

    func startSkillsDropdownViewActivityIndicatorView()
    func stopSkillsDropdownViewActivityIndicatorView()

    func startMusicGenresDropdownViewActivityIndicatorView()
    func stopMusicGenresDropdownViewActivityIndicatorView()

    func startLocationDropdownViewActivityIndicatorView()
    func stopLocationDropdownViewActivityIndicatorView()
}

final class ProfileViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .account

    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet private weak var avatarView: AvatarView!

    @IBOutlet private weak var titleDropdownView: DropdownView!
    @IBOutlet private weak var skillsDropdown: DropdownView!
    @IBOutlet private weak var musicGenresDropdownView: DropdownView!
    @IBOutlet private weak var locationDropdownView: DropdownView!
    @IBOutlet private weak var bioTextView: TextView!

    @IBOutlet private weak var saveButton: UIButton!

    private var newAvatarImage: UIImage?

    var viewModel: ProfileViewModel!

    private var imagePicker: ImagePickerHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        self.imagePicker = ImagePickerHandler(to: self, delegate: self)
        self.bioTextView.delegate = self
    }

    @IBAction private func saveButtonDidTap() {
        bioTextView.textView.resignFirstResponder()
        viewModel.saveButtonDidTap()
    }

    private func configureTapGestures() {
        titleDropdownView.addTapGestureRecognizer { [weak self] _ in
            self?.bioTextView.textView.resignFirstResponder()
            self?.viewModel.titleDropdownDidTap()
        }

        skillsDropdown.addTapGestureRecognizer { [weak self] _ in
            self?.bioTextView.textView.resignFirstResponder()
            self?.viewModel.skillsDropdownDidTap()
        }

        musicGenresDropdownView.addTapGestureRecognizer { [weak self] _ in
            self?.bioTextView.textView.resignFirstResponder()
            self?.viewModel.musicGenresDropdownDidTap()
        }

        locationDropdownView.addTapGestureRecognizer { [weak self] _ in
            self?.bioTextView.textView.resignFirstResponder()
            self?.viewModel.locationDropdownDidTap()
        }

        avatarView.addTapGestureRecognizer { [weak self] avatarView in
            self?.bioTextView.textView.resignFirstResponder()
            self?.imagePicker.present(from: avatarView)
        }

        view.addTapGestureRecognizer { [weak self] _ in
            self?.bioTextView.textView.resignFirstResponder()
        }
    }
}

// MARK: - ProfileViewDelegate
extension ProfileViewController: ProfileViewDelegate {
    var newAvatarImageData: Data? {
        guard let newAvatarImage = newAvatarImage,
              let data = newAvatarImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        return data
    }

    func configureAvatarView(with presentation: AvatarPresentation) {
        avatarView.configure(with: presentation)
    }

    func updateBioTextView(bio: String) {
        bioTextView.updateText(bio)
    }

    func configureUI() {
        view.backgroundColor = .armonyBlack
        navigationItem.title = String(localized: "Edit.Profile", table: "Account+Localizable")

        gradientView.configure(with: .init(orientation: .vertical, color: .profile))
        configureTapGestures()

        saveButton.setTitle(
            String(localized: "Common.Save", table: "Common+Localizable"),
            for: .normal
        )
        saveButton.backgroundColor = .armonyPurple
        saveButton.makeAllCornersRounded(radius: .medium)
        saveButton.titleLabel?.font = .semiboldHeading
        saveButton.setTitleColor(.armonyWhite, for: .normal)
    }

    func configureTitleDropdownView(with presentation: DropdownPresentation) {
        titleDropdownView.configure(with: presentation)
    }

    func configureSkillsDropdownView(with presentation: DropdownPresentation) {
        skillsDropdown.configure(with: presentation)
    }

    func configureMusicGenresDropdownView(with presentation: DropdownPresentation) {
        musicGenresDropdownView.configure(with: presentation)
    }

    func configureLocationDropdownView(with presentation: DropdownPresentation) {
        locationDropdownView.configure(with: presentation)
    }

    func configureBioTextView(with presentation: TextViewPresentation) {
        bioTextView.configure(with: presentation)
    }

    func updateTitle(title: String?) {
        titleDropdownView.updateText(title)
    }

    func updateSkills(title: String?) {
        skillsDropdown.updateText(title)
    }

    func updateMusicGenres(title: String?) {
        musicGenresDropdownView.updateText(title)
    }

    func updateLocation(title: String?) {
        locationDropdownView.updateText(title)
    }

    func startSaveButtonActivityIndicatorView() {
        saveButton.startActivityIndicatorView()
    }

    func stopSaveButtonActivityIndicatorView() {
        saveButton.stopActivityIndicatorView()
    }

    func startTitleDropdownViewActivityIndicatorView() {
        titleDropdownView.startActivityIndicatorView()
    }

    func stopTitleDropdownViewActivityIndicatorView() {
        titleDropdownView.stopActivityIndicatorView()
    }

    func startSkillsDropdownViewActivityIndicatorView() {
        skillsDropdown.startActivityIndicatorView()
    }

    func stopSkillsDropdownViewActivityIndicatorView() {
        skillsDropdown.stopActivityIndicatorView()
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
}

// MARK: - ImagePickerHandlerDelegate
extension ProfileViewController: ImagePickerHandlerDelegate {
    func imagePicker(_ picker: UIImagePickerController, didSelectImage image: UIImage) {
        newAvatarImage = image
        avatarView.configure(with: AvatarPresentation(kind: .circled(.init(size: .custom(88))), source: .static(image)))
    }
}

// MARK: - TextViewDelegate
extension ProfileViewController: TextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.textViewDidEndEditing(text: textView.text)
    }
}
