//
//  WeatherCollectionViewCell.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/16/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherCollectionViewCell: UICollectionViewCell {

    //MARK: IBOutlet:
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinMaxLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var viewModel: WeatherCellViewModelPrototype! {
        didSet {
            viewModel.dateTime.bind(to: dateTimeLabel.rx.text).disposed(by: disposeBag)
            viewModel.averageTemp.bind(to: tempLabel.rx.text).disposed(by: disposeBag)
            viewModel.minMaxTemp.bind(to: tempMinMaxLabel.rx.text).disposed(by: disposeBag)
            viewModel.windSpeed.bind(to: windSpeedLabel.rx.text).disposed(by: disposeBag)
            viewModel.humidity.bind(to: humidityLabel.rx.text).disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 0.99, green: 0.37, blue: 0.34, alpha: 1)
        layer.cornerRadius = 10
    }

}
