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

    //MARK: @IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reloadView: UIView!
    
    
    //MARK: var
    var viewModel: WeatherViewModelPrototype = MainViewModel(WeatherManager())
    
    //MARK: private let
    private let disposebag = DisposeBag()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }
    
    //MARK: private func
    private func binding() {
        //bind collection view
        viewModel.cellArray.asDriver().drive(collectionView.rx.items(cellIdentifier: "cell")) {_, viewModel, cell in
            guard let weatherCell = cell as? WeatherCollectionViewCell else { return }
            weatherCell.viewModel = viewModel
            }.disposed(by: disposebag)
        
        //bind from segment
        self.segmentedControl.rx.selectedSegmentIndex.bind { [weak self] (index) in
            guard let currentType = ForecastType(rawValue: index) else { return }
            self?.viewModel.forecastType.accept(currentType)
            }.disposed(by: disposebag)
        
        //bind show load from segment
        self.segmentedControl.rx.selectedSegmentIndex
            .distinctUntilChanged()
            .subscribe { [weak self] (event) in
                switch event {
                case .next:
                    self?.showLoadBlurs()
                    self?.segmentedControl.isEnabled = false
                default: break
                }
            }.disposed(by: disposebag)
        
        //bind charts set
        viewModel.chartDataSet.asDriver().drive {
            $0.subscribe { [weak self] in
                guard let dataSet = $0.element else { return }
                self?.chartSet(dataSet)
                self?.hideLoadBlurs()
                self?.segmentedControl.isEnabled = true
            }
            }.disposed(by: disposebag)
        
        
        //bind swipe
        viewModel.moveTo.asDriver().drive { (observableX) in
            observableX.subscribe({ [weak self] (event) in
                guard let strongSelf = self else { return }
                guard let x = event.element else { return }
                let middle = Int(strongSelf.collectionView.bounds.width / 2 - 50 - 20)
                strongSelf.collectionView.setContentOffset(CGPoint(x: x - middle, y: 0), animated: true)
            })
            }.disposed(by: disposebag)
    }
    
    private func chartSet(_ dataSet: LineChartDataSet) {
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
    
    private func setupUI() {
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.layer.cornerRadius = 10
        setupChartView()
        setupLoadBlurs()
        showLoadBlurs()
    }
    
    private func setupChartView() {
        chartView.layer.cornerRadius = 10
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
    
    private func showLoadBlurs() {
        reloadView.alpha = 0
        reloadView.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.reloadView.alpha = 1
        }
    }
    
    private func hideLoadBlurs() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.reloadView.alpha = 0
        }) { [weak self] (_) in
            self?.reloadView.isHidden = true
        }
    }
    
    private func setupLoadBlurs() {
        addBlur(to: reloadView)
        reloadView.isHidden = true
    }
    
    private func addBlur(to view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
}

//MARK: ChartViewDelegate
extension Main: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        viewModel.selectEntry(entry)
    }
}
