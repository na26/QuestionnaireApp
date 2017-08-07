//
//  singleOptionViewController.swift
//  assignment1
//  View controller to handle the single option choice for a question
//  Created by Na'Eem Auckburally on 24/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import UIKit        //Import frameworks
import CoreData
class singleOptionViewController: UIViewController {

    @IBOutlet weak var sliderOutlet: UISlider!      //Outlets for the UI elements
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelChoice: UILabel!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    //Handles when the save button is pressed
    @IBAction func saveButton(_ sender: AnyObject)
    {
        saveData()                          //Call the save data function
        saveButtonOutlet.isEnabled = false  //Disable the save button, so they can only respond once
    }
    
    //Handles when the slider changes position
    @IBAction func sliderAction(_ sender: AnyObject) {
        
        //Get the label from the choices array inside the questions array
        //Using the current value of the slider
        if let options = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[Int(sliderOutlet.value) - 1] as? NSDictionary)?["label"] as? String {
            
            labelChoice.text = options     //Set the label of the slider to the option retrieved from json file
            
        }
        
        //Get the value from the choices array inside the questions array
        //
        if let value = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[Int(sliderOutlet.value) - 1] as? NSDictionary)?["value"] as? Int {
            
            //print(options)
            labelValue.text = String(value)     //Set the label of the slider to the option value retrieved from json file
            
        }
    }
    
    //When the view loads, this method is called
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //This function will be called when the view is about to reappear
    override func viewWillAppear(_ animated: Bool) {
        //Get the value of how many choices there are for the question
        let value = (((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)
        //Set the slider maximum to this value
        sliderOutlet.maximumValue = Float((value?.count)!)

        //Sets the first label of the slider
        if let options = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[0] as? NSDictionary)?["label"] as? String {
            
            labelChoice.text = options
            
        }
        
        //Get the value from the choices array inside the questions array
        //
        if let value = ((((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["choices"] as? NSArray)?[0] as? NSDictionary)?["value"] as? Int {
            
            //print(options)
            labelValue.text = String(value)
            
        }
    }
    
    
    //Function to get the context of the core data, used when saving the data
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    //This function saves the data that has been entered in the form
    func saveData(){
        //Sets up all the core data settings with the correct entity name
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "SingleOption", in: context)
        //Sets and stores the data from the form into the entity, stored in core data
        let data = NSManagedObject(entity: entity!, insertInto: context)
        data.setValue(labelChoice.text!, forKey: "choice")  //Set the choice that the user made from the slider
        data.setValue(currentNum, forKey: "questionNum")    //Set the question number of the current question
        
        do {
            try context.save()                      //Save the data to core data
            print("saved")
        } catch let error as NSError {
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
