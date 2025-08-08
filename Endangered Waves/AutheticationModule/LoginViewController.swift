//
//  LoginViewController.swift
//  Endangered Waves
//
//  Created by Magnatesage  on 29/11/24.
//  Copyright © 2024 Save The Waves. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
/**

1.  issue was , when send a link for forgot password its not working and sending the error message.

 */

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnResend: UIButton!

    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblEmail: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) // Adjust padding width
        txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) // Adjust padding width
        txtEmail.font =  Style.fontGeorgiaItalic(size: 15)
        txtPassword.font =  Style.fontGeorgiaItalic(size: 15)
        lblEmail.text = "Email".localized()
        txtEmail.placeholder = "Email".localized()
        lblPassword .text = "Password".localized()
        txtPassword.placeholder = "Password".localized()
        txtEmail.delegate = self
        txtPassword.delegate = self
        self.setupTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: - button action methods
    @IBAction func btnSingInClick(_ sender: UIButton) {
        let email = txtEmail.text ?? ""
        let password =  txtPassword.text ?? ""

        if email.isEmpty || !email.isValidEmail() {
            showValidationError(title: "Invalid Email Address".localized(), message: "Please enter a valid email address".localized(),
                                withViewController: self)
            return
        } else if password.isEmpty {
            showValidationError(title: "Invalid Password".localized(), message: "Please enter a proper password.".localized(),
                                withViewController: self)
            return
        } else if password.count < 7 {
            showAlert(message: "Password must be greaterthen of equal to 7 characters!".localized())
            return
        } else {
            SVProgressHUD.showProgress(0)
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                SVProgressHUD.dismiss()
                if let error = error {
                    self.showValidationError(title: "Error".localized(), message: "\(error.localizedDescription)",
                                        withViewController: self, isPushToSignUp: true)
                    return
                } else {

                    guard let user = result?.user else {
                        print("User not found after sign-in")
                        return
                    }
                    user.reload { error in
                        if let error = error {
                            self.showAlert(message: "\(error.localizedDescription)")
                        } else {
                            if user.isEmailVerified {
                                let user: AuthDataUserModel = AuthDataUserModel(user: result!.user)
                                APIManager.updateUserInReports(for: user.email ?? "", newUserID: user.userId)
                                Global.storeModelInUserDefault(obj: user, key: .currentUser)
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.window?.rootViewController = appDelegate?.appCoordinator.rootViewController
                                appDelegate?.appCoordinator.start()
                            } else {
                                let msg = "Check your email for link to varify your email, and login again.".localized()
                                let alert = UIAlertController(title: "Activate  your email".localized(), message: msg, preferredStyle: .alert)
                                let actionT = "Send activation link to email"
                                let action = UIAlertAction(title: actionT, style: .default) { (alertAction) in
                                    self.sendVerificationEmail(user: user)
                                }
                                alert.addAction(action)

                                let cancel = UIAlertAction(title: "Cancel".localized(), style: .default) { (alertAction) in
                                    alert.dismiss(animated: true)

                                }
                                alert.addAction(cancel)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func btnSignUpClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: ContainerViewController.storyboardName, bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.show(signUpVC, sender: nil)
        }
    }

    @IBAction func btnForgotPasswordClick(_ sender: UIButton) {
        let title = "Forgot Password".localized()
        let message = "Please Enter Register email".localized()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Send Email".localized(), style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField

            Auth.auth().sendPasswordReset(withEmail: textField.text!) { error in
                DispatchQueue.main.async {
                    if textField.text?.isEmpty==true || error != nil {
                        let errmsg = "Error \(String(describing: error?.localizedDescription))"
                        let resetFailedAlert = UIAlertController(title: title, message: errmsg, preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    }
                    if error == nil && textField.text?.isEmpty==false {
                        let errmsg = "Reset email has been sent to your  email, please check your email".localized()
                        let resetEmail = UIAlertController(title: title, message: errmsg, preferredStyle: .alert)
                        resetEmail.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: nil))
                        self.present(resetEmail, animated: true, completion: nil)
                    }
                }
            }
        }

        alert.addTextField { (textField) in
            textField.placeholder = "Enter your email".localized()
        }
        alert.addAction(action)

        let actionC = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (alertAction) in
            self.dismiss(animated: true)
        }
        alert.addAction(actionC)

        self.present(alert, animated: true, completion: nil)

    }

    @IBAction func btnResendClick(_ sender: UIButton) {

    }

    func sendVerificationEmail(user: User) {
        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
            } else {
                print("✅ Verification email sent successfully.")
                self.showAlert(message: "A verification email has been sent. Please check your inbox.")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showValidationError(title: String, message: String, withViewController viewController: UIViewController, isPushToSignUp: Bool = false) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.view.tintColor = Style.colorSTWBlue

        alertViewController.addAction(UIAlertAction(title: "Ok".localized(),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            if isPushToSignUp {
                self.btnSignUpClick(self.btnSignUp)
            }
        }))
        viewController.present(alertViewController, animated: true, completion: nil)
    }

    func showAlert(title: String = "Endangered Waves".localized(), message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Ok".localized(),
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allows other interactions
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension LoginViewController: UITextFieldDelegate {
    // Called when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder() // Move to next text field
        } else {
            txtPassword.resignFirstResponder() // Dismiss keyboard
        }
        return true
    }
}
