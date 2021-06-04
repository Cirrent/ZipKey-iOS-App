//
//  NotificationModel.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 9/6/17.
//
//

import UIKit
import UserNotifications

class NotificationModel {

  static let shared = NotificationModel()
  fileprivate init() {}
  
  func enable() {
    if #available(iOS 10.0, *) {
      
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
        (granted, error) in
        if !granted {
          print("Notifications enable error: \(String(describing: error))")
        }
      }
      
    } else {
      UIApplication.shared.registerUserNotificationSettings(
        UIUserNotificationSettings(types:[.alert, .sound], categories: nil)
      )
    }
  }
  
  func removePending() {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    } else {
      UIApplication.shared.cancelAllLocalNotifications()
    }
  }
  
  func notifyConnectedToSoftAp() {
    
    // let title = "Return To Cirrent App"
    let body = "Your product was found!"
    let identifier = "notifyConnectedToSoftAp"
    let date = Calendar.current.date(byAdding: .second, value: 1, to: Date())
    let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date!)
    
    if #available(iOS 10.0, *) {
      
      let content = UNMutableNotificationContent()
      content.body = body
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
      
      let request = UNNotificationRequest(identifier: identifier, content: content, trigger:  trigger)
      
      UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
        if let error = error {
          print("Notifications add error: \(error)")
        }
      })
      
    } else {
      
      let notification = UILocalNotification()
      // notification.alertTitle = title
      notification.alertBody = body
      notification.fireDate = Calendar.current.date(from: dateComponents)
      notification.timeZone = TimeZone.current
      notification.repeatInterval = NSCalendar.Unit(rawValue: 0)
      notification.soundName = UILocalNotificationDefaultSoundName
      UIApplication.shared.scheduledLocalNotifications?.append(notification)
      
    }
  }
}
