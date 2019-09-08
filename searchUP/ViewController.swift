//
//  ViewController.swift
//  searchUP
//
//  Created by Chris Lee on 2019-08-09.
//  Copyright © 2019 ChrisLee0727. All rights reserved.
//


import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    
    //variables
    let time:TimeInterval = 1.0
    let snooze:TimeInterval = 5.0
    var isGrantedAccess = false
    @IBOutlet weak var statusLabel: UILabel!
    
    let method: String = "Dictionary" // Dictionary: 1 , Internet: 2,
    
    
    
    
    func searchUP(){
        let dictionaryAction = UNTextInputNotificationAction(identifier: "dictionary", title: "dictinoary", options: [], textInputButtonTitle: "Search", textInputPlaceholder: "Type the Word Here")
        
        let searchUPCategory = UNNotificationCategory(identifier: "search.category", actions: [dictionaryAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([searchUPCategory])
    }
    
    
//
//    func setCategories(){
//        let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Snooze 5 Sec", options: [])
//        let commentAction = UNTextInputNotificationAction(identifier: "comment", title: "Add Comment", options: [], textInputButtonTitle: "Add", textInputPlaceholder: "Add Comment Here")
//
//
//        let alarmCategory = UNNotificationCategory(identifier: "alarm.category",actions: [snoozeAction,commentAction],intentIdentifiers: [], options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
//
//    }
    
    
    
    
    func addNotification(content:UNNotificationContent,trigger:UNNotificationTrigger?, indentifier:String){
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (errorObject) in
            if let error = errorObject{
                print("Error \(error.localizedDescription) in notification \(indentifier)")
            }
        })
    }
    
    func dictNotification() {
        let content = UNMutableNotificationContent()
        //            content.title = "searchUP"
        //            content.subtitle = method
        content.body = method
        content.sound = UNNotificationSound.default
        
        //            content.categoryIdentifier = "alarm.category"
        content.categoryIdentifier = "search.category"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        addNotification(content: content, trigger: trigger , indentifier: "Alarm")
    }
    
    @IBAction func enableSwitch(_ sender: UISwitch) {
        if sender.isOn {
            if isGrantedAccess{
                statusLabel.text = "Now POP is up and running"
                dictNotification()
            } else {
                statusLabel.text = "Please turn on notification permissions to use the application."
            }
        } else {
            statusLabel.text = "POP off"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedAccess = granted
                if granted{
//                    self.setCategories()
                    self.searchUP()
                } else {
                    let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permissions.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert , animated: true, completion: nil)
                }
        })
    }
    
    // MARK: - Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        let request = response.notification.request
        
//        if identifier == "snooze"{
//            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
//            newContent.body = "Snooze 5 Seconds"
//            newContent.subtitle = "Snooze 5 Seconds"
//            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snooze, repeats: false)
//            addNotification(content: newContent, trigger: newTrigger, indentifier: request.identifier)
//        }
//
//        if identifier == "comment"{
//            let textResponse = response as! UNTextInputNotificationResponse
//            commentsLabel.text = textResponse.userText
//            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
//            newContent.body = textResponse.userText
//            addNotification(content: newContent, trigger: request.trigger, indentifier: request.identifier)
//        }
        
        if identifier == "dictionary"{
            let textResponse = response as! UNTextInputNotificationResponse
            let word = textResponse.userText
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
//            newContent.attachments = UIReferenceLibraryViewController(term: word)
            
            let reference = UIReferenceLibraryViewController.init(term: word)

//            addNotification(content: newContent, trigger: request.trigger, indentifier: request.identifier)
            self.present(reference, animated: true, completion: nil)
            dictNotification()
        }
        
        completionHandler()
    }
}
