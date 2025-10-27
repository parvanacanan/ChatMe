 
import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if   let email = emailTextField.text , let password = passwordTextField.text {
            
            
            Auth.auth().createUser(withEmail:  email, password:  password ) {  authResult , error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    // navigate to chat view
                    self.performSegue(withIdentifier: "toChatView", sender: self)
                }
            } }
    }
    
}
