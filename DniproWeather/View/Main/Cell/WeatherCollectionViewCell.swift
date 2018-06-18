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
    
    weak var viewModel: WeatherCVCellViewModel! {
        didSet {
            viewModel.dateTime.bind(to: dateTimeLabel.rx.text).disposed(by: disposeBag)
            viewModel.averageTemp.bind(to: tempLabel.rx.text).disposed(by: disposeBag)
            viewModel.minMaxTemp.bind(to: tempMinMaxLabel.rx.text).disposed(by: disposeBag)
            viewModel.windSpeed.bind(to: windSpeedLabel.rx.text).disposed(by: disposeBag)
            viewModel.averageTemp.bind(to: dateTimeLabel.rx.text).disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
