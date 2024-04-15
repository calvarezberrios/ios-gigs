//
//  LoginViewController.swift
//  Gigs
//
//  Created by Carlos E. Alvarez-Berrios on 4/15/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum LoginType: String  {
        case signIn = "Sign In"
        case signUp = "Sign Up"
    }
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    var authController: AuthController?
    
    var loginType: LoginType = .signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func setLoginType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loginType = .signUp
            signinButton.setTitle(LoginType.signUp.rawValue, for: .normal)
        case 1:
            loginType = .signIn
            signinButton.setTitle(LoginType.signIn.rawValue, for: .normal)
        default:
            break
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
                !username.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty
        else { return }
        
        let user = User(username: username, password: password)
        if loginType == .signUp {
            authController?.signUp(with: user, completion: { error in
                if let error = error {
                    NSLog("There was an error during sign up: \(error)")
                    return
                }
                
                let alert = UIAlertController(title: "Sign Up Successful", message: "Now please Log In", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                        self.loginType =  .signIn
                        self.signinButton.setTitle(LoginType.signIn.rawValue, for: .normal)
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                    }
                    
                }
            })
        } else {
            authController?.signIn(with: user, completion: { error in
                if let error = error {
                    NSLog("There was an error during sign in: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            })
        }
    }
    
}
