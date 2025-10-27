//
//  LoginViewController.swift
//  ChatMe
//
//  Created by parvana on 24.10.25.
//
import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ppasswordTextField: UITextField!
    @IBAction func loginPressed(_ sender: UIButton) {
        if  let email = emailTextField.text , let password = ppasswordTextField.text {
            Auth.auth().signIn(withEmail: email , password: password) {  authResult , error in
                if let   e  = error {
                    print(e)
                }
                else {
                    self.performSegue(withIdentifier: "toChatView", sender: self )
                }
            }
            
            }
        }
    }
    


