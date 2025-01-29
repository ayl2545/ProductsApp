//
//  LogInViewController.swift
//  PruductsApp
//
//  Created by Avraham L on 29/01/2025.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField?
    @IBOutlet weak var passwordTF: UITextField?
    @IBOutlet weak var logInBtn: UIButton?
    @IBOutlet weak var faceIdBtn: UIButton?
    let viewModel = LogInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        userNameTF?.placeholder = "User Name"
        passwordTF?.placeholder = "Password"
        logInBtn?.setTitle("Log In", for: .normal)
        faceIdBtn?.setTitle("Use Face ID", for: .normal)
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        if let userName = userNameTF?.text, !userName.isEmpty,
           let password = passwordTF?.text, !password.isEmpty,
           viewModel.checkPassword(userName, password){
            viewModel.logIn()
        } else {
            let alert = UIAlertController(title: "Error", message: "Wrong user name or password", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.userNameTF?.text = nil
                self?.passwordTF?.text = nil
            }
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func faceIdClicked(_ sender: Any) {
        viewModel.authenticateUser { [weak self] success, error in
            if success {
                self?.viewModel.logIn()
            } else {
                let alert = UIAlertController(title: "Biometric authentication failed", message: "Please use the username and password.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
                self?.present(alert, animated: true)
            }
        }
    }
}
