//
//  ResultsViewController.swift
//  assignment1
//  View controller for displaying the results of the responses for the questionnaire
//  Created by Na'Eem Auckburally on 20/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import UIKit            //Import all the needed frameworks
import CoreData
import Charts


var optionsArray: [String] = []         //Declaring array to hold the choices and counters for choices
var optionCountArray: [Double] = []
var currentQNum: Int = 0        //Holds the number of the current question


//Class and method for the formatter of the bar chart
@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    //Set the arrays for the choices
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            //Return the array of the choices
            return optionsArray[Int(value)]
    }
}

class ResultsViewController: UIViewController{

    //When the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set variables to get device and device orientation
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        //Check if the rotation is landscape
        if (orientation.isLandscape) {
            nextButtonOutlet.width = 1100       //Adjust UI element for button
        }
        
        //Check if the rotation is portrait
        if(orientation.isPortrait){
            nextButtonOutlet.width = 506        //Adjust UI element for button
        }
        
        
        //Calculate the amount of questions there are from the questionnaire
        let questions = (jsonResult?["questions"] as! NSArray?)
        totalNumQuestions = questions?.count
        //Hide the text response label
        
        textResponse.isHidden = true
        parseQuestion()     //Call the methods to get the question and the data for responses
        getQuesData()
        // Do any additional setup after loading the view.
    }
    
    //Link up the outlets from the ui element to the class
    @IBOutlet weak var labelOutlet: UILabel!            //Outlets for the elements of the UI
    @IBOutlet weak var barChartOutlet: BarChartView!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var textResponse: UITextView!
    @IBOutlet weak var nextButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    
    
     
    //When the next button is pressed
    @IBAction func nextButton(_ sender: AnyObject) {
        //Check if there is another question to go to
        if(currentQNum < totalNumQuestions-1){
            currentQNum = currentQNum + 1       //Increment the question counter
            parseQuestion()
            getQuesData()                       //Call the methods which reload the data for the questions
        }
        
        //else if there isnt a question that is accessible i.e they are on the first question
        else{
            //Create an alert with the message to display to the user and the response
            let alert = UIAlertController(title: "Error", message: "No more questions.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
        
      
    }
    
    //When the previous button is pressed
    @IBAction func prevAction(_ sender: AnyObject) {
        //Check if there is a previous question to go to
        if(currentQNum > 0){
            currentQNum = currentQNum - 1   //Decrement the question counter
            parseQuestion()
            getQuesData()                   //Reload the data for the questions
        }
        //else if there isnt a question that is accessible i.e they are on the last question
        else{
            //Create an alert with the message to display to the user and the response
            let alert = UIAlertController(title: "Error", message: "No previous questions.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    //Function which gets the data for the questions
    func getQuesData() {
        //Remove all entries of the array
        optionCountArray.removeAll()
        
        //Get the question type for the current question so that the corresponding
        //code to retrieve the data can be used
        let questionType = ((jsonResult?["questions"] as? NSArray)?[currentQNum] as? NSDictionary)?["type"] as? String
        let value = (((jsonResult?["questions"] as? NSArray)?[currentQNum] as? NSDictionary)?["choices"] as? NSArray)
        
        let responseNum = value?.count
        for _ in 0..<Int(responseNum!){
            optionCountArray.append(0)        //Check how many responses there are for the question and create that
        }                                     //many entries in the array

        
        //If the question is single option
        if questionType == "single-option" {
            //Show the bar chart, hide other elements
            textResponse.isHidden = true
            barChartOutlet.isHidden = false
            
            //Get a fetch request for the entity of single option question
            let singleOptRequest: NSFetchRequest<SingleOption> = SingleOption.fetchRequest()
            do {
                let searchResults = try getContext().fetch(singleOptRequest)
                //Check if there is no data
                if (searchResults.count == 0) {
                    print("no data")
                }
                getChoices()    //Call the method to get the choice names
                
                //For each entry in the entity
                for counter in searchResults as [NSManagedObject] {
                    print("\(counter.value(forKey: "choice") as! String!)")
                    //For loop from 0 to how many choices there are
                    for counter2 in 0..<Int(responseNum!){
                        //Check if the question number of the response is the current question number
                        if (counter.value(forKey: "questionNum" ) as! Int) == currentQNum{
                            //Check if the response from the core data is equal to any of the choices
                            if (counter.value(forKey: "choice" ) as! String) == optionsArray[counter2]
                            {
                                //Increment the counter for that choice
                                optionCountArray[counter2] = optionCountArray[counter2]  + 1
                                print("added")
                            }
                        }
                    }
                }
                setChart(dataPoints: optionsArray, values: (optionCountArray))   //Call the set data method for the chart
                
            } catch {
                print("Error with request: \(error)")
            }
        }
        
        //Check if the question is multi option
        if questionType == "multi-option" {
            //Show and hide the correct elements
            textResponse.isHidden = true
            barChartOutlet.isHidden = false
            getChoices()        //Call the method to get the choice names
            
            //Get a fetch request for the entity which holds multi option question response
            let multiOptRequest: NSFetchRequest<MultiOption> = MultiOption.fetchRequest()
            do {
                let searchResults2 = try getContext().fetch(multiOptRequest)
                //Check if there is no data
                if (searchResults2.count == 0) {
                    print("no data")
                }
                
                //Check if there was an entry for choice 1 and increment the counter
                for counter in searchResults2 as [NSManagedObject] {
                    print("\(counter.value(forKey: "option1"))")
                    //Check if the question number in the data file is the same as the current question number
                    if (counter.value(forKey: "questionNum" ) as! Int) == currentQNum{
                    if(counter.value(forKey: "option1") as! Int) == 1
                    {
                    optionCountArray[0] = optionCountArray[0] + 1
                    }
                    }
                }
                
                //Check if there was an entry for choice 2 and increment the counter
                for counter in searchResults2 as [NSManagedObject] {
                    print("\(counter.value(forKey: "option2"))")
                     //Check if the question number in the data file is the same as the current question number
                    if (counter.value(forKey: "questionNum" ) as! Int) == currentQNum{
                    if(counter.value(forKey: "option2") as! Int) == 1
                    {
                        optionCountArray[1] = optionCountArray[1] + 1
                    }
                    }
                }
                
                //Check if there was an entry for choice 3 and increment the counter
                for counter in searchResults2 as [NSManagedObject] {
                    print("\(counter.value(forKey: "option3"))")
                     //Check if the question number in the data file is the same as the current question number
                    if (counter.value(forKey: "questionNum" ) as! Int) == currentQNum{
                    if(counter.value(forKey: "option3") as! Int) == 1
                    {
                        optionCountArray[2] = optionCountArray[2] + 1
                    }
                    }
                }
                
                //Check if there was an entry for choice 4 and increment the counter
                for counter in searchResults2 as [NSManagedObject] {
                    print("\(counter.value(forKey: "option4"))")
                     //Check if the question number in the data file is the same as the current question number
                    if (counter.value(forKey: "questionNum" ) as! Int) == currentQNum{
                    if(counter.value(forKey: "option4") as! Int) == 1
                    {
                        optionCountArray[3] = optionCountArray[3] + 1
                    }
                    }
                }
                
                setChart(dataPoints: optionsArray, values: (optionCountArray))       //Call the set data method
                
            } catch {
                print("Error with request: \(error)")
            }
            
        }
        
        //If the question type is numeric
        if questionType == "numeric"{
            //Remove all entries from the array and add entries of how many choices there are (4)
            optionCountArray.removeAll()
            for _ in 0..<4{
                optionCountArray.append(0)
            }
            //Show and hide the correct elements
            textResponse.isHidden = true
            barChartOutlet.isHidden = false
            //Set choices array options
            optionsArray.removeAll()
            optionsArray.append("0")
            optionsArray.append("Between 1 & 3")
            optionsArray.append("Between 4 & 9")
            optionsArray.append("More than 10")
            
            //Get a fetch request for the numeric question response entity
            let numericOptRequest: NSFetchRequest<NumericOption> = NumericOption.fetchRequest()
            
            do {
                let searchResults = try getContext().fetch(numericOptRequest)
                //Check if there is no data
                if (searchResults.count == 0) {
                    print("no data")
                }
                
                //For each entry in the entity
                for counter in searchResults as [NSManagedObject] {
                     //Check if the question number in the data file is the same as the current question number
                    if (counter.value(forKey: "questionNum" ) as! Int) == currentQNum{
                    //Check for a nil value
                    if (counter.value(forKey: "choice") as? Int != nil){
                    
                    //Check the current entry and increment counter of the correct group
                    if (counter.value(forKey: "choice") as! Int == 0) {
                        optionCountArray[0] = optionCountArray[0] + 1           //If the value is equal to 0
                    }
                    
                    if ((counter.value(forKey: "choice") as! Int) <= 3){
                        if ((counter.value(forKey: "choice") as! Int) >= 1){    //If the value is between 1 and 3
                            optionCountArray[1] = optionCountArray[1] + 1
                        }
                    }
                    
                    if ((counter.value(forKey: "choice") as! Int) <= 9){
                        if ((counter.value(forKey: "choice") as! Int) >= 4){    //If the value is betwween 4 and 9
                            optionCountArray[2] = optionCountArray[2] + 1
                        }
                    }
                    
                    if ((counter.value(forKey: "choice") as! Int) >= 10){
                        optionCountArray[3] = optionCountArray[3] + 1           //If the value is greater than or equal to 10
                    }
                    }
                    }
                }
                setChart(dataPoints: optionsArray, values: (optionCountArray))       //Call the set data method for the chart
                
            } catch {
                print("Error with request: \(error)")
            }
        }
        
        //If the question type is of text
        if questionType == "text" {
            //Show and hide the correct element
            barChartOutlet.isHidden = true
            textResponse.isHidden = false
            textResponse.text = ""
            
            //Get fetch request for text question response
            let textOptRequest: NSFetchRequest<TextOption> = TextOption.fetchRequest()
            do {
                let searchResults = try getContext().fetch(textOptRequest)
                if (searchResults.count == 0) {
                    print("no data")
                }
                for counter in searchResults as [NSManagedObject] {
                    //Check if the question number in the response is equal to the current question number
                    if (counter.value(forKey: "questionNum" ) as! Int) == currentQNum{
                        //Add each response to the text view
                        textResponse.text = textResponse.text! + "\n\n" + (counter.value(forKey: "choice") as! String)
                    }
                }
            } catch {
                print("Error with request: \(error)")
            }
            
            
            
        }  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function which gets the context for the core data
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    //This function sets up the bar chart, using the labels and values as paramaters
    func setChart(dataPoints: [String], values: [Double])
    {
        //Formatter of chart to allow for string labels for the x axis
        let formato:BarChartFormatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
        
        //Setting the text for if there is no data
        barChartOutlet.noDataText = "No data available"
        //Set an array for the data of the bar chart
        var dataEntries: [BarChartDataEntry] = []

        //For loop adds all the data to the data entries
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])

            dataEntries.append(dataEntry)
            //Call formatter to change the labels to the strings
            formato.stringForValue(Double(i), axis: xaxis)
        }
        xaxis.valueFormatter = formato
        //Setting chart up
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Number")
        chartDataSet.colors = ChartColorTemplates.pastel()
        chartDataSet.valueFont = UIFont(name: "Helvetica", size: 11.0)!
        
        //Assign data to the chart
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartOutlet.data = chartData
        barChartOutlet.xAxis.valueFormatter = xaxis.valueFormatter
        
        //Formatting and animation
        barChartOutlet.xAxis.granularityEnabled = true
        barChartOutlet.chartDescription?.text = ""
        barChartOutlet.animate(xAxisDuration: 1.2, yAxisDuration: 1.2)
    }
    
    //Function to get the labels for the choices of the question to display the responses
    func getChoices() {
        optionsArray.removeAll()    //Remove all entries from the array
        
        //Get the labels of the choices from the current question from the json file
        //let questionType = ((jsonResult?["questions"] as? NSArray)?[currentQNum] as? NSDictionary)?["type"] as? String
        let value = (((jsonResult?["questions"] as? NSArray)?[currentQNum] as? NSDictionary)?["choices"] as? NSArray)
        let responseNum = value?.count

        //For loop which adds all the choices for the current question to the array which stores them
        for counter in 0..<Int(responseNum!) {
            if let options = ((((jsonResult?["questions"] as? NSArray)?[currentQNum] as? NSDictionary)?["choices"] as? NSArray)?[counter] as? NSDictionary)?["label"] as? String {
                optionsArray.append(options)
            }
        }
    }
    
    //This function gets the current question details from the json file
    func parseQuestion() {
        let theQ = ((jsonResult?["questions"] as? NSArray)?[currentQNum] as? NSDictionary)?["question"] as? String
        //Retrieving the question number from the json fule
      let qNum = ((jsonResult?["questions"] as? NSArray)?[currentQNum] as? NSDictionary)?["title"] as? String
        //Set the question number and actual question to the 2 labels
        labelOutlet.text = qNum
        labelQuestion.text = theQ
    }
    
    //Method which is called when the device is about to rotate
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        //Check if the rotation is landscape
        if (toInterfaceOrientation.isLandscape) {
            nextButtonOutlet.width = 1100       //Adjust the size of UI element for button
        }
        
        //Check if the rotation is portrait
        if (toInterfaceOrientation.isPortrait) {
            nextButtonOutlet.width = 506        //Adjust the size of UI element for button
        }
    }

}
