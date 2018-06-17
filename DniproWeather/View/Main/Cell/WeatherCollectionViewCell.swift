//
//  WeatherCollectionViewCell.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/16/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    //MARK: IBOutlet:
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinMaxLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
