//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Jiva Ram on 09/01/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello core data...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createData()
    }
}

extension ViewController {
    
    func createData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                   print("Error: AppDelegate is nil")
                   return
               }

               let manageContext = appDelegate.persistentContainer.viewContext

               guard let userEntity = NSEntityDescription.entity(forEntityName: "UserEntity", in: manageContext) else {
                   print("Error: User entity not found")
                   return
               }
        
        for i in 1...5 {
            let user = NSManagedObject(entity: userEntity, insertInto: manageContext)
            user.setValue("Jiva Ram \(i)", forKeyPath: "username")
            user.setValue("jivanbh.com \(i)", forKey: "email")
            user.setValue("jiva \(i)", forKey: "password")
        }
        
        do{
            try manageContext.save()
            print("values set successfully..")
            retrieveData()
        } catch let error as NSError{
            print("could not save \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: AppDelegate is nil")
            return
        }
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        
        do{
            let result = try manageContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
                print(data.value(forKey: "password") as! String)
                print(data.value(forKey: "email") as! String)
            }
        } catch {
            print("fetching faild...")
        }
        updateData()
    }
}

extension ViewController {
    func updateData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: AppDelegate is nil")
            return
        }
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Jiva Ram 1")
        do{
            let test = try manageContext.fetch(fetchRequest)
                let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "username")
            objectUpdate.setValue("newPass", forKey: "password")
            objectUpdate.setValue("newEmail", forKey: "email")
            do {
                try manageContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
