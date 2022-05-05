//
//  PieChartViewController.swift
//  ExpenseTracker
//
//  Created by student on 5/4/22.
//

import UIKit
import Firebase
import Charts

class PieChartViewController: UIViewController, ChartViewDelegate
{
    @IBOutlet weak var refreshBTN: UIButton!
    let ref = Database.database().reference()
    var expense = NSDictionary()
    var income = NSDictionary()
    var expenseValues:[String] = []
    var incomeValues:[String] = []
    var totalIncome:Double = 0.0
    var totalExpense:Double = 0.0
    
    var pieChart = PieChartView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        pieChart.delegate = self
        pieChart.frame =
            CGRect(x: 0, y: 0,
                   width: self.view.frame.size.width,
                   height: self.view.frame.size.height - 200)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        let set = PieChartDataSet(entries:[PieChartDataEntry(value: 1.0, label: "Default Data")])
        set.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
    
    func fetchData()
    {
        totalExpense = 0.0
        totalIncome = 0.0
        ref.child("income").getData(completion:
        { error, snapshot in guard error == nil else {return;}
            let income = snapshot.value as! NSDictionary
            self.incomeValues = income.allValues as! [String]
            
            for val:String in self.incomeValues
            {
                self.totalIncome += (val as NSString).doubleValue
            }
        });
        
        ref.child("expense").getData(completion:
        { error, snapshot in guard error == nil else{return;}
            let expense = snapshot.value as! NSDictionary
            self.expenseValues = expense.allValues as! [String]
            
            for val:String in self.expenseValues
            {
                self.totalExpense += (val as NSString).doubleValue
            }
        });
    }
    
    @IBAction func refreshBTNOnClick(_ sender: Any)
    {
        var newSet = PieChartDataSet(
            entries: [
                PieChartDataEntry(value: totalIncome, label: "Income"),
                PieChartDataEntry(value: totalExpense, label: "Expense")
            ])
        newSet.colors = ChartColorTemplates.joyful()
        
        var newData = PieChartData(dataSet: newSet)
        pieChart.data = newData
        fetchData()
    }
}



