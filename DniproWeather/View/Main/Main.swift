//
//  Main.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/15/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class Main: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel = MainViewModel()
    
    let disposebag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionLayout.itemSize = CGSize(width: 100, height: collectionView.bounds.size.height * 0.8)
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        viewModel.cellArray.asDriver().drive(collectionView.rx.items(cellIdentifier: "cell")) {_, viewModel, cell in
            guard let weatherCell = cell as? WeatherCollectionViewCell else { return }
            weatherCell.viewModel = viewModel
        }.disposed(by: disposebag)
        
        self.segmentedControl.rx.selectedSegmentIndex.bind { [weak self] (index) in
            guard let currentType = ForecastType(rawValue: index) else { return }
            self?.viewModel.forecastType.accept(currentType)
        }.disposed(by: disposebag)
        
        viewModel.chartPoints.subscribe { [weak self] (event) in
            guard let points = event.element else { return }
            self?.chartSet(points)
        }.disposed(by: disposebag)
        
    }
    
    private func chartSet (_ points: [Double]) {
        var entrys = [ChartDataEntry]()
        var x : Double = 0
        for point in points {
            x += 50
            entrys.append(ChartDataEntry(x: x, y: point))
        }
        let dataset = LineChartDataSet(values: entrys, label: "test")
        let data = LineChartData(dataSet: dataset)
        chartView.data = data
    }
}
