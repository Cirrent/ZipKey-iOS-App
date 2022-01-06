import UIKit
import CirrentSDK


class SignInViewController: BaseLocalViewController {
    
    var coordinator: SignInCoordinator?
    // MARK: @IBOutlet
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var shareDataSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        initStyle()
        keyboardHideWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
        setWindowColor(UIColor.getColorName(.window))
        } else {
            setWindowColor(.white)
        }
        hideNavigationBar()
    }
    
    fileprivate func initStyle() {
        signInButton.layer.cornerRadius = 6
        userNameTextField.placeholderColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.8038045805))
        passwordTextField.placeholderColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.8038045805))
    }
    
    fileprivate func showWarning() {
        infoAlert(title: "Warning", message: "Username or Password is incorrect")
    }
    
    fileprivate func goBack() {
        MobileAppIntelligence.enterStep(
                StepData.create(result: .success, stepName: "waiting_for_first_in_app_action", reason: "back_from_login_screen")
        )
        _ = navigationController?.popViewController(animated: true)
    }
    
    fileprivate func login(_ completion: @escaping() -> ()) {
        LoginRequester(username: userNameTextField.text!, password: passwordTextField.text!).doRequest(success: { (result) in
            if result.status == 401 {
                self.showWarning()
            } else {
                print("Login Requester is Success")
                print("idAccount: \(result.data.user.idAccount)")
                UserModel.shared.setEncodedCredentials(self.userNameTextField.text!, self.passwordTextField.text!)
                UserModel.shared.accountId.value = String(describing: result.data.user.idAccount)
                completion()
            }
        }, failed: { message, code, statusCode in
            print("Login Requester is Failed, message: \(message), code: \(code)")

            MobileAppIntelligence.enterStep(
                    StepData.create(
                            result: .failure,
                            stepName: "starting_login_process",
                            reason: "\(statusCode ?? 0)"
                    ).setDebugInfo(
                            ["error": message]
                    )
            )

            if code == .notConnectedToInternet {
                self.infoAlert(title: "Warning", message: message)
            } else {
                self.showWarning()
            }
        }, progressDialog: CustomActivityIndicator.shared.with(message: "Logging in"))
    }
}

// MARK: @IBAction
extension SignInViewController {
    
    @IBAction func backTap(_ sender: Any) {
        goBack()
    }
    
    @IBAction func backTapGesture(_ sender: UITapGestureRecognizer) {
        goBack()
    }
    
    @IBAction func signInTap(_ sender: Any) {
        if !userNameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            login {
                UserModel.shared.setDefaultValues(appId: self.userNameTextField.text)
                UserModel.shared.onboardingHistory.clearObject()
                MobileAppIntelligence.enterStep(
                        StepData.create(result: .success, stepName: "waiting_for_onboarding", reason: "logged_in")
                )
                self.coordinator?.presentTabBar()
            }
        } else {
            infoAlert(title: "Warning", message: "Username and Password are required")
        }
    }
    
    @IBAction func eyeTaped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            eyeButton.setImage(#imageLiteral(resourceName: "eyeYellow"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeButton.setImage(#imageLiteral(resourceName: "eyeWhite"), for: .normal)
        }
    }
    
    @IBAction func forgotPassworTap(_ sender: Any) {
        coordinator?.presentForgotPassVC()
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
}
