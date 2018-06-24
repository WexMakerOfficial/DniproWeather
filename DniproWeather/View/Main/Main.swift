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
        setupChartView()
        viewModel.cellArray.asDriver().drive(collectionView.rx.items(cellIdentifier: "cell")) {_, viewModel, cell in
            guard let weatherCell = cell as? WeatherCollectionViewCell else { return }
            weatherCell.viewModel = viewModel
        }.disposed(by: disposebag)
        
        self.segmentedControl.rx.selectedSegmentIndex.bind { [weak self] (index) in
            guard let currentType = ForecastType(rawValue: index) else { return }
            self?.viewModel.forecastType.accept(currentType)
        }.disposed(by: disposebag)
        
        viewModel.chartDataSet.subscribe { [weak self] (event) in
            guard let dataSet = event.element else { return }
            self?.chartSet(dataSet)
        }.disposed(by: disposebag)
        

        viewModel.moveTo.asDriver().drive { (observableX) in
            observableX.subscribe({ [weak self] (event) in
                guard let strongSelf = self else { return }
                guard let x = event.element else { return }
                let middle = Int(strongSelf.collectionView.bounds.width / 2 - 50 - 20)
                strongSelf.collectionView.setContentOffset(CGPoint(x: x - middle, y: 0), animated: true)
            })
        }.disposed(by: disposebag)
        
    }
    
    private func chartSet (_ dataSet: LineChartDataSet) {
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        chartView.animate(xAxisDuration: 0.4)
    }
    
    private func setupChartView () {
        chartView.delegate = self
        chartView.chartDescription?.text = "Forecast"
        chartView.leftAxis.enabled = false
        chartView.leftAxis.spaceTop = 0.4
        chartView.leftAxis.spaceBottom = 0.4
        chartView.leftAxis.drawZeroLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.labelPosition = .outsideChart
    }
}

extension Main: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        viewModel.selectEntry(entry)
    }
}
