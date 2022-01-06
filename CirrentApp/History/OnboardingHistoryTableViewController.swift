
import UIKit

class OnboardingHistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Storyboarded {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mTextHint: UILabel!
    
    var onboardingHistory: [OnboardingInfoModel] = []
    
    override func viewDidLoad() {
        onboardingHistory = OnboardingHistoryPrefManager.shared.getOnboardingHistory()
        self.mTableView.dataSource = self;
        self.mTableView.delegate = self;
        self.mTableView.separatorColor = UIColor(named: "separator")
        self.mTableView.separatorInset = .zero
        self.mTableView.tableFooterView = UIView()
        
        if let navBar = navigationController {
            changeNavBarTitleColor(navBar: navBar.navigationBar)
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeNavBarShadowColor()
        updateViews()
    }

    @IBAction func clearHistory(_ sender: Any) {
        showWarningDialogAndClear()
    }
    
    private func showWarningDialogAndClear() {
        let alert = UIAlertController(title: "Clear onboarding history?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let actionOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            OnboardingHistoryPrefManager.shared.clearOnboardingHistory()
            self.updateViews()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        actionOK.setValue(UIColor(named: "light_orange"), forKey: "titleTextColor")
        actionCancel.setValue(UIColor(named: "light_orange"), forKey: "titleTextColor")
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateViews() {
        onboardingHistory = OnboardingHistoryPrefManager.shared.getOnboardingHistory()
        mTableView.reloadData()
        mTableView.isHidden = onboardingHistory.isEmpty
        mTextHint.isHidden = !onboardingHistory.isEmpty
    }
}

extension OnboardingHistoryTableViewController {
    static let historyListCellIdentifier = "OnboardingHistoryListCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.onboardingHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.historyListCellIdentifier, for: indexPath) as! OnboardingHistoryListCell
        let time = Utils.shared.getFormattedTime(timeInMs: self.onboardingHistory[indexPath.row].time)
        let onboardingType = Utils.shared.getFormattedOnboardingType(type: self.onboardingHistory[indexPath.row].onboardingType);
        
        cell.labelDeviceId.text = self.onboardingHistory[indexPath.row].deviceId
        cell.labelAccountId.text = self.onboardingHistory[indexPath.row].accountId
        cell.labelTime.text = time
        cell.labelOnboardingType.text = onboardingType
        return cell
    }

}

class OnboardingHistoryListCell: UITableViewCell {
    @IBOutlet weak var labelDeviceId: UILabel!
    @IBOutlet weak var labelAccountId: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelOnboardingType: UILabel!
}
