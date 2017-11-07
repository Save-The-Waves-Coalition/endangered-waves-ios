//
//  ReportsTableViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/4/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreUI
import FirebaseAuthUI

class ReportsTableViewController: UITableViewController, FUIAuthDelegate {

    @IBOutlet weak var signInBarButtonItem: UIBarButtonItem!
    var dataSource: FUIFirestoreTableViewDataSource!

    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true;

        let collection = Firestore.firestore().collection("reports")

        dataSource = self.tableView.bind(toFirestoreQuery: collection) { (tableView, indexPath, snapshot) -> UITableViewCell in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? ReportsTableViewCell, let descriptionAny = snapshot.data()["description"], let descriptionString = descriptionAny as? String else {

                // TODO: Return something else here?
                return UITableViewCell()
            }

            cell.descriptionLabel.text = descriptionString
            return cell
        }

        auth = Auth.auth()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
//                self.signInBarButtonItem.title = "Sign In"
                return
            }

//            self.signInBarButtonItem.title = "Sign Out"
        }
    }

    @IBAction func signInWasTapped(_ sender: UIBarButtonItem) {
        if auth?.currentUser != nil {
            do {
                try auth?.signOut()
            } catch {
                print("error")
            }
        } else {
            let authViewController = authUI?.authViewController()
            self.present(authViewController!, animated: true)
        }
    }

    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else { return }

        let errorCode = UInt((authError as NSError).code)

        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break

        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }

}
