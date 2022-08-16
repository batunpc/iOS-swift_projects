//
//  WeatherImgTableViewCell.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-15.
//

import UIKit

class WeatherImgTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var cityTempLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
