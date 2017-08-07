//
//  QuestionnaireViewController.swift
//  assignment1
//  View controller to handle the questionnaire and is parent of the choice view controller
//  Created by Na'Eem Auckburally on 20/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import UIKit
    var currentNum: Int = 0     //Variable to track the number of the current question
    var totalNumQuestions: Int! //Variable to store the total number of questions



class QuestionnaireViewController: UIViewController {
    var viewController: multiOptionViewController!
@IBOutlet weak var labelMain: UILabel!
    @IBOutlet weak var qNumLabel: UILabel!
    @IBOutlet weak var singleOptView: UIView!
    @IBOutlet weak var multiOptView: UIView!
    @IBOutlet weak var numOptView: UIView!          //Outlets for all the UI elements
    @IBOutlet weak var textViewOpt: UIView!
    @IBOutlet weak var labelNum: UILabel!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    @IBOutlet weak var toolbarOutlet: UIToolbar!
    @IBOutlet weak var nextButtonOutlet: UIBarButtonItem!
    
    
    
    //This function handles what happens when the previous button is pressed
    @IBAction func previousButton(_ sender: AnyObject) {
        
        //it checks that there is a previous question available
        if currentNum > 0 {
            currentNum = currentNum - 1
            parse(quesNum: currentNum)      //calls the parse method to get the new question
            changeOption()                  //calls the change option method to get the style of question
            
        }
        //else if there isnt a question that is accessible i.e they are on the first question
        else{
            
            //Create an alert with the message to display to the user and the response
            let alert = UIAlertController(title: "Error", message: "No previous questions.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        //Checks if the user is on the last question, in which case it should show the menu button
        if currentNum == (totalNumQuestions - 1){
            menuButtonOutlet.isEnabled = true       //enable and show the button
            menuButtonOutlet.isHidden = false
        }
        //If the user isn't then hide the button
        else{
            menuButtonOutlet.isEnabled = false      //disable and hide the button
            menuButtonOutlet.isHidden = true
        }
    }
    
    //This function handles what happens when the previous button is pressed
    //It checks that there is a next question available
    @IBAction func nextButtonAction(_ sender: AnyObject) {
        if currentNum < (totalNumQuestions - 1) {
            currentNum = currentNum + 1
            print(currentNum)
            parse(quesNum: (currentNum))
            changeOption()
        }
            //else if there isnt a question that is accessible i.e they are on the last question
        else{
            //Create an alert with the message to display to the user and the response
            let alert = UIAlertController(title: "Error", message: "No more questions.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            //show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
        
         //Checks if the user is on the last question, in which case it should show the menu button
        if currentNum == (totalNumQuestions - 1){
            menuButtonOutlet.isEnabled = true
            menuButtonOutlet.isHidden = false
        }
        //If the user isn't then hide the button
        else{
            menuButtonOutlet.isEnabled = false
            menuButtonOutlet.isHidden = true
        }

        
    }
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    //When the view loads this method is called
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a variable and get the device and the devices orientation (portrait and landscape)
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        //If the rotation is landscape
        if (orientation.isLandscape) {
            //Edit the UI elements size and location to fit landscape screen well
            print("landscape")
            
            //Setting the frame dimensions for landscape use
            singleOptView.frame = CGRect(x: 350, y: 45, width: 347, height: 267)
            multiOptView.frame = CGRect(x: 350, y: 45, width: 347, height: 267)
            numOptView.frame = CGRect(x: 350, y: 45, width: 347, height: 267)
            textViewOpt.frame = CGRect(x: 350, y: 45, width: 347, height: 267)
            toolbarOutlet.frame = CGRect(x: 0, y: 329, width: 666, height: 44)
            nextButtonOutlet.width = 1100
        }
            
        //If the rotation is portrait
        else {
            //Reset the UI elements to portrait mode, defined by size and location
            print("portrait")
            singleOptView.frame = CGRect(x: 12, y: 227, width: 347, height: 267)    //Setting the frame dimensions for portrait use
            multiOptView.frame = CGRect(x: 12, y: 227, width: 347, height: 267)
            numOptView.frame = CGRect(x: 12, y: 227, width: 347, height: 267)
            textViewOpt.frame = CGRect(x: 12, y: 227, width: 347, height: 267)
            toolbarOutlet.frame = CGRect(x: 0, y: 623, width: 375, height: 44)
            nextButtonOutlet.width = 517
        }
    

        menuButtonOutlet.isHidden = true
        menuButtonOutlet.isEnabled = false
        //Getting the number of questions by checking the json file for entries
        let questions = (jsonResult?["questions"] as! NSArray?)
        totalNumQuestions = questions?.count        //Get the count of questions and assign to variable
        print(totalNumQuestions)
        
        
        changeOption()  //call the change option method to change the response type
        parse(quesNum: currentNum) //call json parse method to retrieve question

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //This function retrieves the question number and content everytime a new question is loaded
    func parse(quesNum: Int){
        
        //Retrieving the question content from the json file
        if let theQ = ((jsonResult?["questions"] as? NSArray)?[quesNum] as? NSDictionary)?["question"] as? String {
            self.labelMain.text = theQ  //assigning to the label
        }
        //Retrieving the question number from the json fule
        if let qNum = ((jsonResult?["questions"] as? NSArray)?[quesNum] as? NSDictionary)?["title"] as? String {
            self.qNumLabel.text = qNum  //assigning to the label
        }
    }
    
    
    //This function changes the response type depending on what the question type is
    func changeOption(){
        //Retrieving the question type of the current question from the json files
        let questionType = ((jsonResult?["questions"] as? NSArray)?[currentNum] as? NSDictionary)?["type"] as? String
        
        //Checks if the question is single option, removes all other child views and adds the single option view
        if questionType == "single-option"{
            multiOptView.removeFromSuperview()
            numOptView.removeFromSuperview()
            textViewOpt.removeFromSuperview()
            self.view.addSubview(singleOptView)
            
        //Checks if the question is multi option, removes all other child views and adds the multi option view
        } else if questionType == "multi-option"{
            print("multi")
            singleOptView.removeFromSuperview()
            numOptView.removeFromSuperview()
            textViewOpt.removeFromSuperview()
            self.view.addSubview(multiOptView)
            
        //Checks if the question is numeric option, removes all other child views and adds than the numeric option view
        } else if questionType == "numeric" {
            singleOptView.removeFromSuperview()
            multiOptView.removeFromSuperview()
            textViewOpt.removeFromSuperview()
            self.view.addSubview(numOptView)
            
        //Checks if the question is text option, removes all other child views and adds than the text option view
        } else if questionType == "text"{
            singleOptView.removeFromSuperview()
            multiOptView.removeFromSuperview()
            numOptView.removeFromSuperview()
            self.view.addSubview(textViewOpt)
        }
    }
    
    //Function which handles when the device is rotated
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        //If the rotation is landscape
        if (toInterfaceOrientation.isLandscape) {
            //Edit the UI elements size and location to fit landscape screen well
            print("landscape")
            singleOptView.frame = CGRect(x: 350, y: 45, width: 347, height: 267)    //Setting the frame dimensions for landscape use
            multiOptView.frame = CGRect(x: 350, y: 45, width: 347, height: 267)
            numOptView.frame = CGRect(x: 350, y: 45, width: 347, height: 267)
            textViewOpt.frame = CGRect(x: 350, y: 45, width: 347, height: 267)
            
            
            toolbarOutlet.frame = CGRect(x: 0, y: 329, width: 666, height: 44)
            nextButtonOutlet.width = 1100
            
        }
            //If the rotation is portrait
        else {
            //Reset the UI elements to portrait mode, defined by size and location
            print("portrait")
            
            //Setting the frame dimensions for the UI elements for landscape use
            singleOptView.frame = CGRect(x: 12, y: 227, width: 347, height: 267)
            multiOptView.frame = CGRect(x: 12, y: 227, width: 347, height: 267)
            numOptView.frame = CGRect(x: 12, y: 227, width: 347, height: 267)
            textViewOpt.frame = CGRect(x: 12, y: 227, width: 347, height: 267)
            toolbarOutlet.frame = CGRect(x: 0, y: 623, width: 375, height: 44)
            nextButtonOutlet.width = 517
        }
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
