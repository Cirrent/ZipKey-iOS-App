//
//  AppDelegate.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 18.07.17.
//
//

import UIKit
import CirrentSDK
import Firebase
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    var connectViaSoftApLoadingIsActive = false
    var connectViaSoftApLoadingIsContinue = true
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MAIHelper().initializeMobileAppIntelligence()
        PreferenceWrapperFactory.prefix = "CIRRENT_"
        initStyle()
        NotificationModel.shared.enable()
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)

        if (!UserModel.shared.accountId.value.isEmpty) {
            MobileAppIntelligence.enterStep(StepData.create(stepName: "waiting_for_onboarding"))
        } else {
            MobileAppIntelligence.enterStep(StepData.create(stepName: "waiting_for_first_in_app_action"))
        }

        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()

        return true
    }
    
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    connectViaSoftApLoadingIsContinue = true
    
    bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
      UIApplication.shared.endBackgroundTask(self.bgTask)
      self.connectViaSoftApLoadingIsContinue = false
        self.bgTask = UIBackgroundTaskIdentifier.invalid
    })


    notifyConnectedToSoftAp()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    NotificationModel.shared.removePending()
    connectViaSoftApLoadingIsContinue = false
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

extension AppDelegate {
    func notifyConnectedToSoftAp() {
        if connectViaSoftApLoadingIsActive {
            if UserModel.shared.softApSsid.value == NetUtils.shared.getCurrentSsid() {
                self.connectViaSoftApLoadingIsActive = false
                NotificationModel.shared.notifyConnectedToSoftAp()
            } else {
                if connectViaSoftApLoadingIsContinue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.notifyConnectedToSoftAp()
                    })
                }
            }
        }
    }
}