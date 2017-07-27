//
//  FoodCurrencyConvertorTests.swift
//  FoodCurrencyConvertorTests
//
//  Created by Priya Xavier on 7/25/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import XCTest
@testable import FoodCurrencyConvertor


class FoodCurrencyConvertorTests: XCTestCase {
  
  
  //var groceryItemToConvert:
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
    
    func testInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      let groceryItem = GroceryItem(name: "Milk", price: 1.30, qty: 1)
      let currencyExchange = CurrencyExchangeRate(currency: "EUR", rate: 1.1)
      
      XCTAssertEqual(groceryItem.price * currencyExchange.rate, 1.43)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
