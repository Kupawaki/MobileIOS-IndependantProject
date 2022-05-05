//
//  BarGraphViewController.swift
//  ExpenseTracker
//
//  Created by student on 5/4/22.
//

import UIKit
import Firebase
import Charts

class BarGraphViewController: UIViewController, ChartViewDelegate
{
    @IBOutlet weak var refreshBTN: UIButton!
    let ref = Database.database().reference()
    var expense = NSDictionary()
    var income = NSDictionary()
    var expenseValues:[String] = []
    var incomeValues:[String] = []
    var totalIncome:Double = 0.0
    var totalExpense:Double = 0.0
    
    var barChart = BarChartView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        barChart.delegate = self
        barChart.frame =
            CGRect(x: 0, y: 0,
                   width: self.view.frame.size.width,
                   height: self.view.frame.size.height - 200)
        barChart.center = view.center
        view.addSubview(barChart)
        
        let set = BarChartDataSet(entries:[BarChartDataEntry(x: 1.0, y: 1.0)])
        set.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: set)
        barChart.data = data
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
        var newSet = BarChartDataSet(
        entries: [
            BarChartDataEntry(x: 0.2, y: totalIncome),
            BarChartDataEntry(x: 0.6, y: totalExpense)
        ])
        newSet.label = "Income / Expense"
        
        newSet.colors = ChartColorTemplates.joyful()
    
        var newData = BarChartData(dataSet: newSet)
        barChart.data = newData
        fetchData()
        
    }
}
