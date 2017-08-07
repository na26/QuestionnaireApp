//
//  textViewController.swift
//  assignment1
//  View controller to handle the text option choice for a question
//  Created by Na'Eem Auckburally on 24/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import UIKit        //Import frameworks
import CoreData
class textViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Handles when the save button is clicked
    @IBAction func saveButton(_ sender: AnyObject) {
        //Calls the save data function
        saveData()
        saveButtonOutlet.isEnabled = false      //Disable save button
    }
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    
    @IBOutlet weak var textField: UITextField!
    
    //Get context function, handles the core data
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    //This function saves the data that has been entered in the form
    func saveData(){
        //Sets up all the core data settings with the correct entity name
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "TextOption", in: context)
        
        //Sets and stores the data from the form into the entity, stored in core data
        let data = NSManagedObject(entity: entity!, insertInto: context)
        data.setValue(textField.text!, forKey: "choice")        //Set the text from the field to be saved
        data.setValue(currentNum, forKey: "questionNum")        //Set the question number of the current question
        do {
            try context.save()                      //Saving the data to core data
            print("saved")
        } catch let error as NSError {
            //Error handling
            print("Could not save \(error), \(error.userInfo)")
        } catch {
        }
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
