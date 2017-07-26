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
  
  struct CurrencyList {
    var country: String
    var rate: Float
    
  }
  var checkoutTotalUSD: Float = 0.0
  var currencyMultiplier: Float = 1.0
  var selectedCurrency = "USD"
  var currencyData : [CurrencyList] = [CurrencyList(country:"USD",rate: 1.0)]
  var numberFormatter = NumberFormatter()
  
  var groceryList: [GroceryItem] = [GroceryItem(name:"Peas: $ 0,95 per bag",price: 0.95, qty: 0),GroceryItem(name:"Eggs: $ 2,10 per dozen",price: 2.10, qty: 0),GroceryItem(name:"Milk: $ 1,30 per bottle",price: 1.30, qty: 0),GroceryItem(name:"Beans: $ 0,73 per can",price: 0.73, qty: 0)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    currencyPicker.delegate = self
    loadCurrencyData()
    NotificationCenter.default.addObserver(self, selector: #selector(refreshRatesCall), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  //Make API Call when app returns from background
  func refreshRatesCall() {
    loadCurrencyData()
    currencyPicker.selectRow(0, inComponent: 0, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Action buttons
  @IBAction func checkoutBtn(_ sender: UIButton) {
    self.totalLabel.text = String(format: " %.2f", checkoutTotalUSD * currencyMultiplier) + "  " + selectedCurrency
  }
  
  //gets updated currency list
  func loadCurrencyData() {
    
    //make API call
    
    let urlRates = "http://www.apilayer.net/api/live"
    let parameterString = "access_key=1d5f49755791b82322fc09165b2f1f97&currencies=AUD,CHF,EUR,GBP,PLN&format=1"
    let requestURL = URL(string: "\(urlRates)?\(parameterString)")
    
    print("URL REQUEST =\(String(describing: requestURL))")
    let session = URLSession.shared
    
    
    let task = session.dataTask(with: requestURL!, completionHandler: {(data, response, error) in
      
      if let error = error {
        let alert = UIAlertController(title: "The API returned an error", message: error.localizedDescription, preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)}
      else {
        
          if JSONSerialization.isValidJSONObject(data as Any) {
            do {
              let jSONDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
              
              let rateDictionary = jSONDictionary["quotes"] as! NSDictionary
              let rateAUD = rateDictionary["USDAUD"] as! Float
              let rateCHF = rateDictionary["USDCHF"] as! Float
              let rateEUR = rateDictionary["USDEUR"] as! Float
              let rateGBP = rateDictionary["USDGBP"] as! Float
              let ratePLN = rateDictionary["USDPLN"] as! Float
              
              self.currencyData.append(CurrencyList(country: "AUD", rate: rateAUD))
              self.currencyData.append(CurrencyList(country: "CHF", rate: rateCHF))
              self.currencyData.append(CurrencyList(country: "EUR", rate: rateEUR))
              self.currencyData.append(CurrencyList(country: "GBP", rate: rateGBP))
              self.currencyData.append(CurrencyList(country: "PLN", rate: ratePLN))
              
              DispatchQueue.main.async {
                self.currencyPicker.reloadAllComponents()
              }
            }
            catch {
              let alert = UIAlertController(title: "Data serialization error", message: error.localizedDescription, preferredStyle: .alert)
              
              self.present(alert, animated: true, completion: nil)
              print("\(error.localizedDescription)")}
          }
        
          else {  print("Currency rates not available")}
        
      }})
    
    task.resume()
    
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
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.contentView.backgroundColor = UIColor.white
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
    return currencyData[row].country
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currencyMultiplier = currencyData[row].rate
    selectedCurrency = currencyData[row].country
    print("The currency conversion rate = \(currencyMultiplier)")
  }
}
