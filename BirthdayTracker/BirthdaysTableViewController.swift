//
//  BirthdaysTableViewController.swift
//  BirthdayTracker
//
//  Created by Gorbovtsova Ksenya on 04.09.2018.
//  Copyright © 2018 Gorbovtsova Ksenya. All rights reserved.
//
import CoreData
import UIKit
import UserNotifications
protocol AddBirthdayViewControllerDelegate {
    func addBirthdayViewController(_ addBirthdayViewController:AddBirthdayViewController, didAddBirthday birthday: Birthday)
}
class BirthdaysTableViewController: UITableViewController {
    
    var birthdays = [Birthday] ()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDeligate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeligate.persistentContainer.viewContext
        
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            birthdays = try context.fetch(fetchRequest)
        } catch let error{
            print ("Could not fetch because of \(error)")
        }
        tableView.reloadData()
        
    }

 
    // MARK: - Table view data source
  

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return birthdays.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)

        let birthday = birthdays[indexPath.row]
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
        cell.textLabel?.text = firstName + " " + lastName
        
        if let date = birthday.birthdate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }else{
            cell.detailTextLabel?.text = " "
        }

        return cell
    }
   
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if birthdays.count > indexPath.row{
            let birthday = birthdays[indexPath.row]
            if let identifier = birthday.birthdayId {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            let appDeligate = UIApplication.shared.delegate as!AppDelegate
            let context = appDeligate.persistentContainer.viewContext
            context.delete(birthday)
            birthdays.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do{
                try context.save()
            }catch let error{
                print ("Could not save because of \(error)")
            }
        }
    }
    

   

  

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    

}
