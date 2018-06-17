//
//  Main.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/15/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import UIKit
import Charts

class Main: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func reloadWithSegment(_ sender: UISegmentedControl) {
    }
}

