//
//  groceryCell.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/24/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import UIKit

class GroceryCell: UITableViewCell {
  
    var groceryCellDelegate : GroceryCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  @IBAction func selectBtn(_ sender: UIButton) {
    groceryCellDelegate?.didSelectBtn(self.tag)
  }
  
  @IBOutlet weak var nameLabel: UILabel!

  @IBOutlet weak var priceLabel: UILabel!
  
  
}
