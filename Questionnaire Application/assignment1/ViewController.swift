//
//  ViewController.swift
//  assignment1
//  View controller for the menu, loads the json file
//  Created by Na'Eem Auckburally on 20/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import UIKit
import CoreData
var jsonResult: AnyObject? = nil    //Declare a variable to store the json in


class ViewController: UIViewController {

    //When the view loads, get the json file as soon as the application launces
    //So that it can be used in all other view controllers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentNum = 0      //Set the numbers to track question number for filling in questionnaire or response
        currentQNum = 0
        //the settings for the json parsing are set for the url etc
        let url = URL(string: "https://intranet.csc.liv.ac.uk/~phil/COMP327/questionnaire.json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                
            } else {
                if let urlContent = data {
                    
                    do {
                        //Get the json file into the json object
                         jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    } catch {
                        print("======\nJSON processing Failed\n=======")
                    }
                    
                }
            }
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Handles when the delete button is pressed, and will delete and reset the core data.
    @IBAction func deleteButton(_ sender: AnyObject) {
        //Call a batch request for deletion of the selected entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SingleOption")
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try getContext().execute(delete)
            print("Entity deleted")
        } catch{
            print("error")
        }
        
        //Call a batch request for deletion of the selected entity
        let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "MultiOption")
        let delete2 = NSBatchDeleteRequest(fetchRequest: request2)
        do{
            try getContext().execute(delete2)
            print("Entity deleted")
        } catch{
            print("error")
        }
        
        //Call a batch request for deletion of the selected entity
        let request3 = NSFetchRequest<NSFetchRequestResult>(entityName: "NumericOption")
        let delete3 = NSBatchDeleteRequest(fetchRequest: request3)
        do{
            try getContext().execute(delete3)
            print("Entity deleted")
        } catch{
            print("error")
        }
        
        //Call a batch request for deletion of the selected entity
        let request4 = NSFetchRequest<NSFetchRequestResult>(entityName: "TextOption")
        let delete4 = NSBatchDeleteRequest(fetchRequest: request4)
        do{
            try getContext().execute(delete4)
            print("Entity deleted")
        } catch{
            print("error")
        }
        
        //Set up the formatting of the alert to show the message to the user
        let alert = UIAlertController(title: "Deleted", message: "Core data has been deleted and reset", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Function to get the context for the core data entities
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    

}

