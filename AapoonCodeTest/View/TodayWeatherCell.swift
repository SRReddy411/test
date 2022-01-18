//
//  WeatherManager.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import UIKit

class TodayWeatherCell: UITableViewCell {

    @IBOutlet weak var humidity_lbl: UILabel!
    @IBOutlet weak var wind_lbl: UILabel!
    @IBOutlet weak var cityName_lbl: UILabel!
    @IBOutlet weak var temp_lbl: UILabel!
    @IBOutlet weak var sunImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
