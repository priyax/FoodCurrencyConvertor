//
//  ViewController.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/24/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // Action buttons
  @IBAction func checkoutBtn(_ sender: UIButton) {
  }
  
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
  
  var groceryList: [GroceryItem] = [GroceryItem(name:"Peas: $ 0,95 per bag",price: 0.95, qty: 0),GroceryItem(name:"Eggs: $ 2,10 per dozen",price: 2.10, qty: 0),GroceryItem(name:"Milk: $ 1,30 per bottle",price: 1.30, qty: 0),GroceryItem(name:"Beans: $ 0,73 per can",price: 0.73, qty: 0)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    cell.qtyLabel.text = String(groceryList[row].qty)
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
