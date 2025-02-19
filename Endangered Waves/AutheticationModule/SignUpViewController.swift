//
//  SignUpViewController.swift
//  Endangered Waves
//
//  Created by Magnatesage  on 02/12/24.
//  Copyright © 2024 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!

    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtLastName: UITextField!

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!

    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtPassword: UITextField!

    @IBOutlet weak var lblCPassword: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!

    @IBOutlet weak var isAgreeToSubscribe: UIButton!
    @IBOutlet weak var lblSubscribe: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) // Adjust padding width
        txtLastName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtConfirmPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        txtPassword.passwordRules = UITextInputPasswordRules(descriptor: "NO")
        txtConfirmPassword.passwordRules = UITextInputPasswordRules(descriptor: "NO")

        // Do any additional setup after loading the view.
        lblFirstName.text = "First Name".localized()
        txtFirstName.placeholder = "First Name".localized()

        lblLastName.text = "Last Name".localized()
        txtLastName.placeholder = "Last Name".localized()

        lblEmail.text = "Email".localized()
        txtEmail.placeholder = "Email".localized()

        lblPassword.text = "Password".localized()
        txtPassword.placeholder = "Password".localized()

        lblCPassword.text = "Confirm Password".localized()
        txtConfirmPassword.placeholder = "Confirm Password".localized()

        btnBack.setTitle(" Back ".localized(), for: .normal)
        btnSave.setTitle(" Save ".localized(), for: .normal)
        lblSubscribe.text = "Subscribe to Save The Waves news and information".localized()
        self.isAgreeToSubscribe.isSelected = false
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func btnSaveClick(sender: Any) {
        let firstName = txtFirstName.text ?? ""
        let lastName = txtLastName.text ?? ""
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        let cpassword = txtConfirmPassword.text ?? ""

        // ✅ Validate Inputs First
        guard validateUserInput(firstName: firstName, lastName: lastName, email: email, password: password, cpassword: cpassword) else {
            return
        }

        // ✅ Start User Registration
        SVProgressHUD.showProgress(0)
        registerUser(email: email, password: password, firstName: firstName, lastName: lastName)
    }

    @IBAction func btnSubscribeClick(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    // 🔹 Function for Firebase Registration
    func registerUser(email: String, password: String, firstName: String, lastName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            SVProgressHUD.dismiss()

            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }

            guard let user = result?.user else {
                self.showAlert(message: "User creation failed.")
                return
            }

            // ✅ Send Verification Email
            self.sendVerificationEmail(user: user)
        }
    }

    // 🔹 Function for Sending Verification Email
    func sendVerificationEmail(user: User) {
        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
            } else {
                self.showAlert(message: "A verification email has been sent. Please check your inbox.".localized())
                self.saveUserData(user: user, firstName: self.txtFirstName.text ?? "", lastName: self.txtLastName.text ?? "", isSubscribe: self.isAgreeToSubscribe.isSelected)
            }
        }
    }

    // 🔹 Function for Saving User Data in Firestore
    func saveUserData(user: User, firstName: String, lastName: String, isSubscribe: Bool) {
        let userModel = UserModel(firstName: firstName, lastName: lastName, deviceId: Global.deviceToken, userId: user.uid, isSubscribe: isSubscribe)

        APIManager.createNewUserData(userData: userModel) { ref, error in
            SVProgressHUD.dismiss()

            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                self.showAlert(message: "Check your email for a link to verify your email.".localized())
            }
        }
    }

    func validateUserInput(firstName: String, lastName: String, email: String, password: String, cpassword: String) -> Bool {
        let validationRules: [(Bool, String)] = [
            (firstName.isEmpty, "Please enter first name".localized()),
            (lastName.isEmpty, "Please enter last name".localized()),
            (email.isEmpty, "Please enter email".localized()),
            (!email.isValidEmail(), "Please enter a valid email".localized()),
            (password.isEmpty, "Please enter password".localized()),
            (password.count < 10, "Password must be at least 10 characters!".localized()),
            (cpassword.isEmpty, "Please enter confirm password".localized()),
            (password != cpassword, "Password and Confirm Password must be the same".localized())
        ]

        // ✅ Loop through rules and show the first validation error
        if let failedValidation = validationRules.first(where: { $0.0 }) {
            showAlert(message: failedValidation.1, isDismiss: false)
            return false
        }
        return true
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    @IBAction func btnBackClick(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func showAlert(title: String = "Endangered Waves".localized(), message: String?, isDismiss: Bool = true) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized(),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            if isDismiss {
                self.dismiss(animated: true, completion: nil)
            } else {
                alert.dismiss(animated: true)
            }
        }))

        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
}

class Global {
    static var deviceToken: String = ""

    static func storeModelInUserDefault<T: Codable>(obj: T?, key: UserDefaultKeys) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(obj)
            store_in_userdefault(value: data, key: key)
        } catch {
            debugPrint("Error Storing data in UserDefaults: \(error.localizedDescription)")
        }
    }

    static func getModelFromUserDefault<T: Codable>(model: T.Type, key: UserDefaultKeys) -> T? {
        if let data = UserDefaults.standard.data(forKey: key.rawValue) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode user
                let appleUser = try decoder.decode(T.self, from: data)
                return appleUser
            } catch {
                debugPrint("Error getting data from userDefaults: == \(error.localizedDescription)")
            }
        }
        return nil
    }

}
extension SignUpViewController: UITextFieldDelegate {
    // Called when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        } else if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtConfirmPassword.becomeFirstResponder()
        } else {
            txtConfirmPassword.resignFirstResponder() // Dismiss keyboard
        }
        return true
    }
}
