//
//  multiOptionViewController.swift
//  assignment1
//  View controller to handle the multiplw option choice for a question
//  Created by Na'Eem Auckburally on 24/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import UIKit        //Import frameworks
import CoreData
class multiOptionViewController: UIViewController {
    @IBOutlet weak var optionLabel1: UILabel!       //Outlets for the labels and toggles
    @IBOutlet weak var optionLabel2: UILabel!
    @IBOutlet weak var optionLabel3: UILabel!
    @IBOutlet weak var optionLabel4: UILabel!
    @IBOutlet weak var toggle1: UISwitch!
    @IBOutlet weak var toggle2: UISwitch!
    @IBOutlet weak var toggle3: UISwitch!
    @IBOutlet weak var toggle4: UISwitch!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var saveButton: UIButton!
    //Handles when the save button is clicked
    @IBAction func saveButton(_ sender: AnyObject) {
        saveData()                          //call the save data function
        saveButtonOutlet.isEnabled = false  //disable the button, so they can only respond once
        
    }
    
    //Get context function, handles the core data
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    //This function saves the data that has been entered in the form
    func saveData(){
        //Sets up all the core data settings with the correct entity name
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "MultiOption", in: context)
        
        //Sets and stores the data from the form into the entity, stored in core data
        let data = NSManagedObject(entity: entity!, insertInto: context)
        data.setValue(currentNum, forKey: "questionNum")        //Set the question number of the current question
        //Checks if the first option toggle is on
        if(self.toggle1.isOn == true)
        {
            
            data.setValue(1, forKey: "option1")     //Saves that the first option has been selected
            
            do {
                try context.save()
                print("saved")
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
                
            } catch {
            }
        }
        
        //Checks if the second option toggle is on
        if(self.toggle2.isOn == true)
        {
            print("toggle2")
            data.setValue(1, forKey: "option2")     //Saves that the second option has been selected
            
            do {
                try context.save()
                print("saved")
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
                
            } catch {
            }
        }
        
        //Checks if the third option toggle is on
        if(self.toggle3.isOn == true)
        {
            data.setValue(1, forKey: "option3")     //Saves that the third option has been selected
            
            do {
                try context.save()
                print("saved")
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
                
            } catch {
            }
        }
        
        //Checks if the fourth option toggle is on
        if(self.toggle4.isOn == true)
        {
            data.setValue(1, forKey: "option4")     //Saves that the fourth option has been selected
            
            do {
                try context.save()                  //Save the data to the core data
                print("saved")
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
                
            } catch {
            }
        }
    }
    
    //When the view appears, so when other children are hidden
    override func viewWillAppear(_ animated: Bool) {
        
        //Get the label of the choice and set it to the text label
        if let options = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[0] as? NSDictionary)?["label"] as? String {
            print(options)
            optionLabel1.text = options
        }
        
        //Get the label of the choice and set it to the text label
        if let options = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[1] as? NSDictionary)?["label"] as? String {
            print(options)
            optionLabel2.text = options
        }
        
        //Get the label of the choice and set it to the text label
        if let options = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[2] as? NSDictionary)?["label"] as? String {
            print(options)
            optionLabel3.text = options
        }
        
        //Get the label of the choice and set it to the text label
        if let options = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[3] as? NSDictionary)?["label"] as? String {
            print(options)
            optionLabel4.text = options
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
