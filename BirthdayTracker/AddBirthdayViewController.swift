//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Gorbovtsova Ksenya on 04.09.2018.
//  Copyright © 2018 Gorbovtsova Ksenya. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class AddBirthdayViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdatePicker.maximumDate = Date()
    }

    @IBAction func saveTapped( _ sender: UIBarButtonItem){
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        let appDeligate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeligate.persistentContainer.viewContext
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate
        newBirthday.birthdayId = UUID().uuidString
        if let uid=newBirthday.birthdayId{
            print ("uid bd \(uid)")
        }
        do{
            try context.save()
            let message = "Wish \(firstName) \(lastName) a HB today"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default()
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
            dateComponents.hour=9
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newBirthday.birthdayId{
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error{
            print ("Could not save bcause of \(error)")
        }
        
        
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func cancelTapped(_sender: UIBarButtonItem){
        dismiss(animated: true, completion:nil)
    }
    

}

