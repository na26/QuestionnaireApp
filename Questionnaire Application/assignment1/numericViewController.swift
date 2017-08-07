//
//  numericViewController.swift
//  assignment1
//  View controller to handle the numeric option choice for a question
//  Created by Na'Eem Auckburally on 24/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import UIKit        //Import frameworks
import CoreData
class numericViewController: UIViewController {
    var num: Int = 0        //integer variable to hold the number entry from the user
    
    //Handles when the save button is clicked
    @IBAction func saveButton(_ sender: AnyObject) {
        //Calls the save data function
        saveData()
        saveButtonOutlet.isEnabled = false
    }
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    //Get context function, handles the core data
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    //This function saves the data that has been entered in the form
    func saveData(){
        //Sets up all the core data settings with the correct entity name
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "NumericOption", in: context)
        
        //Sets and stores the data from the form into the entity, stored in core data
        let data = NSManagedObject(entity: entity!, insertInto: context)
        data.setValue(currentNum, forKey: "questionNum")            //Set the question number of the current question
        data.setValue(Int(numField.text!), forKey: "choice")        //Set the choice of the user from the text field
        
        do {
            try context.save()                  //Saving the data to the core data
            print("saved")
        } catch let error as NSError {
            //Error handling
            print("Could not save \(error), \(error.userInfo)")
            
        } catch {
        }
    }

    //Method to handle decrease button press
    @IBAction func decButton(_ sender: AnyObject) {
        //Checks if it can be decreased
        if( Int(numField.text!)! > 0 ){
            //Decrement variable and update field
            num = num - 1
            numField.text = String(num)
        }
    }
    
    //Method to handle increase button press
    @IBAction func incButton(_ sender: AnyObject) {
        //Increment variable and update field
        num = num + 1
        numField.text = String(num)
        
    }
    @IBOutlet weak var numField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        numField.isEnabled = false  
        numField.text = "0"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
