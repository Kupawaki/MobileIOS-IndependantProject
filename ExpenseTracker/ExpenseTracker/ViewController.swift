//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by Student on 5/4/22.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var mainTV: UITableView!
    @IBOutlet weak var switchBTN: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var addBTN: UIButton!
    
    let ref = Database.database().reference()
    
    var expenseKeys:[String] = []
    var incomeKeys:[String] = []
    
    var expenseValues:[String] = []
    var incomeValues:[String] = []
    
    var expense = NSDictionary()
    var income = NSDictionary()
    
    var child = "expense"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        fetchData()
        mainTV.delegate = self
        mainTV.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(child == "income")
        {
            return incomeKeys.count
        }
        else if(child == "expense")
        {
            return expenseKeys.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = mainTV.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        
        if(child == "income")
        {
            cell.textLabel?.text = incomeKeys[indexPath.row] + ", " + String(incomeValues[indexPath.row])
        }
        else if(child == "expense")
        {
            cell.textLabel?.text = expenseKeys[indexPath.row] + ", " + String(expenseValues[indexPath.row])
        }
        
        return cell
    }
    
    func fetchData()
    {
        if(child == "income")
        {
            ref.child("income").observeSingleEvent(of: .value)
            { [self] snapshot in
                let income = snapshot.value as! NSDictionary
                self.incomeKeys = income.allKeys as! [String]
                self.incomeValues = income.allValues as! [String]
                self.mainTV.reloadData()
            }
        }
        else if(child == "expense")
        {
            ref.child("expense").observeSingleEvent(of: .value)
            { [self] snapshot in
                let expense = snapshot.value as! NSDictionary
                self.expenseKeys = expense.allKeys as! [String]
                self.expenseValues = expense.allValues as! [String]
                self.mainTV.reloadData()
            }
        }
    }
    
    @IBAction func switchBTNOnClick(_ sender: Any)
    {
        if(child == "income")
        {
            child = "expense"
            switchBTN.setTitle("Switch to Income", for: .normal)
            nameTF.placeholder = "Enter Expense Name"
            valueTF.placeholder = "Enter Expense Value"
            fetchData()
        }
        else if(child == "expense")
        {
            child = "income"
            switchBTN.setTitle("Switch to Expense", for: .normal)
            nameTF.placeholder = "Enter Income Name"
            valueTF.placeholder = "Enter Income Value"
            fetchData()
        }
    }
    
    @IBAction func addBTNOnClick(_ sender: Any)
    {
        if(nameTF.text!.isEmpty || valueTF.text!.isEmpty)
        {
            print("Both value and name cannot be empty")
            return
        }
        
        if(child == "income")
        {
            self.ref.child("income").child(nameTF.text!).setValue(valueTF.text!)
        }
        else if(child == "expense")
        {
            self.ref.child("expense").child(nameTF.text!).setValue(valueTF.text!)
        }
        fetchData()
    }
}

