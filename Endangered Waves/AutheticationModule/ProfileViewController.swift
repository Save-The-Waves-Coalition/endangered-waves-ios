//
//  ProfileViewController.swift
//  Endangered Waves
//
//  Created by Magnatesage  on 30/01/25.
//  Copyright © 2025 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    // MARK: - UI Elements
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.gray
        return imageView
    }()

    let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name".localized()
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "BrandonGrotesque-Regular", size: 16) // Set custom font here
        return textField
    }()

    let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name".localized()
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "BrandonGrotesque-Regular", size: 16) // Set custom font here
        return textField
    }()

    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile".localized(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Password".localized(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "BrandonGrotesque-Regular", size: 16) // Change to your custom font
        return button
    }()

    let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout".localized(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "BrandonGrotesque-Regular", size: 16) // Change to your custom font
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "PROFILE".localized()
        changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        logOutButton.addTarget(self, action: #selector(logOutButtonTaped), for: .touchUpInside)

        APIManager.fetchCurrentUserData { userData, error in
            if error == nil {
                self.firstNameTextField.text = "\(userData?["firstName"] ?? "")"
                self.lastNameTextField.text = "\(userData?["lastName"] ?? "")"
            }
        }
        setupUI()
        addGestureToProfileImage()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(editButton)
        view.addSubview(changePasswordButton)
        view.addSubview(logOutButton)
        editButton.isHidden = true
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            firstNameTextField.widthAnchor.constraint(equalToConstant: 250),

            lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 15),
            lastNameTextField.widthAnchor.constraint(equalToConstant: 250),

            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),

            changePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePasswordButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 15),

            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 15)
        ])
    }

    // MARK: - Enable Editing
    @objc func editProfile() {
    }

    // MARK: - Change Password Function
    @objc func changePassword() {
        let title = "Change Password".localized()
        if let userInfo = Global.getModelFromUserDefault(model: AuthDataUserModel.self, key: .currentUser) {
            Auth.auth().sendPasswordReset(withEmail: userInfo.email ?? "") { error in
                if let error = error {
                    let alert = UIAlertController(title: title, message: "Error: \(error.localizedDescription)", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok".localized(), style: .cancel))
                    self.present(alert, animated: true)

                } else {
                    let message = "Change password link has been sent to you, please check your email".localized()
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok".localized(), style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: title, message: "Something wen't wrong!".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .cancel))
            self.present(alert, animated: true)
        }
    }

    @objc func logOutButtonTaped() {
        self.showLogoutAlert(in: self)
    }
    // MARK: - Update Password
    private func updatePassword(_ newPassword: String?) {
        guard let newPassword = newPassword, !newPassword.isEmpty else {
            return
        }
        // UserDefaults.standard.set(newPassword, forKey: "userPassword")
    }

    // MARK: - Add Gesture to Profile Image
    private func addGestureToProfileImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Select Profile Image
    @objc func selectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    func showLogoutAlert(in viewController: UIViewController) {
        let alert = UIAlertController(title: "Are you sure?".localized(),
                                      message: "You want to logout?".localized(),
                                      preferredStyle: .alert)
        // Logout Action
        let logoutAction = UIAlertAction(title: "Logout".localized(), style: .destructive) { _ in
            self.performLogout()
        }

        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)

        // Add actions to alert
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)

        // Present alert
        viewController.present(alert, animated: true, completion: nil)
    }
    // Function for Logout Action
    func performLogout() {
        let user: AuthDataUserModel? = nil
        Global.storeModelInUserDefault(obj: user, key: .currentUser)
        self.navigationController?.popToRootViewController(animated: true)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.switchToLogin()
        }
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate {
    // MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true)
    }
}
