
import UIKit
import CirrentSDK


class ConnectViaSoftApLoadingViewController: UIViewController, Storyboarded {
    var coordinator: ConnectViaSoftApLoadingCoordinator?
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var connectingToLabel: UILabel!
    
    fileprivate var softApSsid: String?
    fileprivate var isContinueCallShowNextButton = true
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.coordinator?.popToRootView(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MobileAppIntelligence.setOnboardingType(type: .softap)
        if #available(iOS 11.0, *) {
            loadingView.isHidden = false
            connectingToLabel.text = "Connecting to device via SoftAP…"
        } else {
            (UIApplication.shared.delegate as! AppDelegate).connectViaSoftApLoadingIsActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.hideNavigationBar()
            startLoadingAnimation(imageView: loadingImageView)
        }
        connectToDeviceViaSoftAp()
        self.hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
        isContinueCallShowNextButton = false
    }
    
    func setProperties(softApSsid: String?) {
        self.softApSsid = softApSsid
    }
    
    fileprivate func connectToDeviceViaSoftAp() {
        if #available(iOS 11.0, *) {
            //----- SDK call ------------
            SoftApService.shared
                .connectToDeviceViaSoftAp(UserModel.shared.softApSsid.value, self)
            //---------------------------
        } else {
            if UserModel.shared.softApSsid.value == NetUtils.shared.getCurrentSsid() {
                ChooseNetworkViewCoordinator(navigationController: self.navigationController!).start(isForThirdMethod: true)
            } else if isContinueCallShowNextButton {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.connectToDeviceViaSoftAp()
                })
            }
        }
    }
}

// SDK callback delegate implementation
extension ConnectViaSoftApLoadingViewController: SoftApDeviceConnectionCallback {
    func onDeviceConnectedSuccessfully() {
        ChooseNetworkViewCoordinator(navigationController: self.navigationController!).start(isForThirdMethod: true)
    }
    
    func onConnectionFailed() {
        MobileAppIntelligence.endOnboarding(EndData.create(failureReason: "cant_connect_to_softap_network"))
        let alert = UIAlertController(title: "Warning", message: "Can't connect to Soft AP network", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.coordinator?.popToRootView(viewController: self)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
