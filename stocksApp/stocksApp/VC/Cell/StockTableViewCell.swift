//
//  StockTableViewCell.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-19.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var lastPriceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
