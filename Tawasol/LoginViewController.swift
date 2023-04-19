
import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        emailLblOutlet.text = ""
        passwordLblOutlet.text = ""
        confirmPassLblOutlet.text = ""
        forgetPasswordOutlet.isHidden = true
        
        emailTxtFieldOutlet.delegate = self
        passwordTxtFieldOutlet.delegate = self
        confirmPasswordTxtFieldOutlet.delegate = self
        setupBackgroundTap()
    }
    
    var isLogin : Bool = false
    
    
    //Mark:- IBoutlet
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var emailLblOutlet: UILabel!
    @IBOutlet weak var passwordLblOutlet: UILabel!
    @IBOutlet weak var confirmPassLblOutlet: UILabel!
    @IBOutlet weak var emailTxtFieldOutlet: UITextField!
    @IBOutlet weak var passwordTxtFieldOutlet: UITextField!
    @IBOutlet weak var confirmPasswordTxtFieldOutlet: UITextField!
    @IBOutlet weak var forgetPasswordOutlet: UIButton!
    @IBOutlet weak var resendEmailOutlet: UIButton!
    @IBOutlet weak var registerBtnOutlet: UIButton!
    @IBOutlet weak var haveAnAccLblOutlet: UILabel!
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    //Mark:- IBAction
    
    @IBAction func forgetPasswordbtn(_ sender: Any) {
        if isDataInputedFor(mode: "forgetPassword") {
            print("All Data Inputed")
        } else {
            ProgressHUD.showError("Email Fields Are required")
        }
    
    }
    @IBAction func resendEmailBtn(_ sender: Any) {
        print("Resend email")
    }
    @IBAction func registerBtn(_ sender: Any) {
        if isDataInputedFor(mode: isLogin ? "Login" : "Register"){
            print("Data is inputed correctly")
        } else {
           
            ProgressHUD.showError("Error - All Fields Must have Data")
        }
        
    
    }
    @IBAction func loginBtn(_ sender: Any) {
        updateUIMode(mode: isLogin)
    }
    
    private func updateUIMode(mode :Bool){
        
        if !mode {
            titleOutlet.text = "Login"
            confirmPassLblOutlet.isHidden = true
            confirmPasswordTxtFieldOutlet.isHidden = true
            resendEmailOutlet.isHidden = true
            haveAnAccLblOutlet.text = "Don't Have Account"
            registerBtnOutlet.setTitle("Login", for: .normal)
            loginBtnOutlet.setTitle("Register", for: .normal)
            forgetPasswordOutlet.isHidden = false

            

        } else {
            titleOutlet.text = "Register"
            confirmPassLblOutlet.isHidden = false
            confirmPasswordTxtFieldOutlet.isHidden = false
            resendEmailOutlet.isHidden = false
            haveAnAccLblOutlet.text = "Have An Account"
            registerBtnOutlet.setTitle("Register", for: .normal)
            loginBtnOutlet.setTitle("Login", for: .normal)
            forgetPasswordOutlet.isHidden = true
        }
        isLogin.toggle()
    }
    
    //Mark:- Utilites
    
    private func isDataInputedFor (mode : String) -> Bool {
        switch mode {
        case "Login" :
            return emailTxtFieldOutlet.text != "" && passwordTxtFieldOutlet.text != ""
        case "Register" :
            return emailTxtFieldOutlet.text != "" && passwordTxtFieldOutlet.text != "" && confirmPasswordTxtFieldOutlet.text != ""
        case "forgetPassword" :
            return emailTxtFieldOutlet.text != ""
        default:
            return false

        }
    }
    //MARK:- Tap gesture
    
    private func setupBackgroundTap(){
        let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard (){
        view.endEditing(true)
    }


}

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLblOutlet.text = emailTxtFieldOutlet.hasText ? "Email" : ""
        passwordLblOutlet.text = passwordTxtFieldOutlet.hasText ? "Password" : ""
        confirmPassLblOutlet.text = confirmPasswordTxtFieldOutlet.hasText ? "Confirm Password" : ""

    }
}

