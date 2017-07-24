//
//  ViewController.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/24/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

 
  
  //Outlet labels
  @IBOutlet weak var currencyPicker: UIPickerView!
  
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  //Variables
  struct GroceryItem {
    var name: String
    var price: Float
    var qty: Int
  }
  
  var checkoutTotalUSD: Float = 0.0
  var currencyMultiplier: Float = 1.0
  var currencyData : [String] = ["1.0", "1.2", "1.3", "1.4","1.5"]
  var numberFormatter = NumberFormatter()
  
  var groceryList: [GroceryItem] = [GroceryItem(name:"Peas: $ 0,95 per bag",price: 0.95, qty: 0),GroceryItem(name:"Eggs: $ 2,10 per dozen",price: 2.10, qty: 0),GroceryItem(name:"Milk: $ 1,30 per bottle",price: 1.30, qty: 0),GroceryItem(name:"Beans: $ 0,73 per can",price: 0.73, qty: 0)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    currencyPicker.delegate = self
    loadCurrencyData()
   
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // Action buttons
  @IBAction func checkoutBtn(_ sender: UIButton) {
    self.totalLabel.text = numberFormatter.string(from: NSNumber(value: checkoutTotalUSD * currencyMultiplier)) //String(checkoutTotalUSD * currencyMultiplier)
    
  }
  
  //gets updated currency list
  func loadCurrencyData() {
    
    //make API call
    self.currencyData = ["1.0", "1.2", "1.3", "1.4","1.5"]
    currencyPicker.reloadAllComponents()
  }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate, GroceryCellDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return  self.groceryList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = (indexPath as NSIndexPath).row
    let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as! GroceryCell
    cell.nameLabel.text = groceryList[row].name
    cell.qtyLabel.text = numberFormatter.string(from: NSNumber(value: groceryList[row].qty)) //String(groceryList[row].qty)
    cell.groceryCellDelegate = self
    cell.tag = row
    return cell
  }
  
  func didAddItem(_ tag: Int) {
    print("I have added an item with a price tag \(self.groceryList[tag].price)")
    checkoutTotalUSD +=  self.groceryList[tag].price
    self.groceryList[tag].qty += 1
    print(checkoutTotalUSD)
    tableView.reloadData()
  }
  
  func didRemoveItem(_ tag: Int) {
   
    if self.groceryList[tag].qty > 0  {
      checkoutTotalUSD -= self.groceryList[tag].price
      self.groceryList[tag].qty -= 1
       print(checkoutTotalUSD)
       print("I have removed an item with a price tag \(self.groceryList[tag].price)")
      tableView.reloadData()
    }
  }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return currencyData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return currencyData[row]
  }
 
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currencyMultiplier = numberFormatter.number(from: currencyData[row])!.floatValue
    print(currencyMultiplier)
  }
}
