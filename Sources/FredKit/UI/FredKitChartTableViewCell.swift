//
//  FredKitChartTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 22.11.21.
//

#if os(iOS)
import UIKit
import Charts

public struct ChartTimeIntervalConfiguration {
    
    public init(endDate: Date, representedTimeInterval: TimeInterval) {
        self.endDate = endDate.midOfMonth
        self.granularity = .day
        self.startDate = endDate
        self.representedTimeInterval = representedTimeInterval
        self.refreshInternalData()
    }
    
    var startDate: Date
    var endDate: Date
    var granularity: TimeInterval
    
    var representedTimeInterval: TimeInterval {
        didSet {
            self.refreshInternalData()
        }
    }
    
    mutating private func refreshInternalData() {
        if representedTimeInterval == .week {
            startDate = endDate.addingTimeInterval(-.week + .day)
            granularity = .day
        } else if representedTimeInterval == .month {
            startDate = endDate.addingTimeInterval(-.month)
            granularity = .day
        } else if representedTimeInterval == 6 * .month {
            startDate = endDate.addingTimeInterval(-6 * .month)
            granularity = .week
        } else if representedTimeInterval == .year {
            startDate = endDate.addingTimeInterval(-.year + .month)
            granularity = .month
        }
    }
    
    mutating func moveBackward() {
        startDate.addTimeInterval(-granularity)
        endDate.addTimeInterval(-granularity)
    }
    
    mutating func moveForward() {
        startDate.addTimeInterval(granularity)
        endDate.addTimeInterval(granularity)
    }
    
    
    
    var timeInterval: TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
    
    var numberOfSegments: Int {
        return Int(timeInterval / granularity)
    }
    
    var segmentIntervals: [(Date, Date)] {
        var intervals = [(Date, Date)]()
        
        (0..<numberOfSegments).forEach { intervalIndex in
            let startDate = startDate.addingTimeInterval(granularity * Double(intervalIndex))
            let endDate = startDate.addingTimeInterval(granularity)
            intervals.append((startDate, endDate))
        }
        
        return intervals
    }
}

public class FredKitChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var filterbutton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var leftButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var rightButtonBackgroundView: UIVisualEffectView!
    
    @IBOutlet weak var dateSelectionBackgroundView: UIStackView!
    
    
    @IBOutlet weak var bigValueLabel: UILabel!
    
    
    @IBOutlet weak var filterBackground: UIVisualEffectView!
    @IBOutlet weak var timeIntervalSelection: UISegmentedControl!
    @IBOutlet weak var timeFrameLabel: UILabel!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    public var timeIntervalConfiguration: ChartTimeIntervalConfiguration? {
        didSet {
            self.refreshChart()
        }
    }
    
    public var dp: FredKitDataPoint?
    
    public var dataPoints: [FredKitDataPoint]? {
        didSet {
            self.refreshChart()
        }
    }
    
    
    @IBAction func didChangeTimeInterval(_ sender: UISegmentedControl) {
        
        if var timeIntervalConfiguration = timeIntervalConfiguration {
            if sender.selectedSegmentIndex == 0 {
                timeIntervalConfiguration.representedTimeInterval = .week
            } else if sender.selectedSegmentIndex == 1 {
                timeIntervalConfiguration.representedTimeInterval = .month
            } else if sender.selectedSegmentIndex == 2 {
                timeIntervalConfiguration.representedTimeInterval = 6 * .month
            } else if sender.selectedSegmentIndex == 3 {
                timeIntervalConfiguration.representedTimeInterval = .year
            }
            
            self.timeIntervalConfiguration = timeIntervalConfiguration
        }
        
        
        self.refreshChart()
    }
    
    @IBAction func moveBackward(_ sender: Any) {
        self.timeIntervalConfiguration?.moveBackward()
        self.refreshChart()
    }
    
    @IBAction func moveForward(_ sender: Any) {
        self.timeIntervalConfiguration?.moveForward()
        self.refreshChart()
    }
    
    
    func refreshChart() {
        
        //        chartView.setRoundedCorner(roundedCorner: [.topLeft, .topRight], roundedHeight: 50)
        
        if let timeIntervalConfiguration = timeIntervalConfiguration, let dataPoints = dataPoints {
            
            if timeIntervalConfiguration.representedTimeInterval == .week {
                timeIntervalSelection.selectedSegmentIndex = 0
                chartView.xAxis.setLabelCount(7, force: true)
                chartView.setVisibleXRange(minXRange: .week, maxXRange: .week)
            } else if timeIntervalConfiguration.representedTimeInterval == .month {
                timeIntervalSelection.selectedSegmentIndex = 1
                chartView.xAxis.setLabelCount(5, force: true)
                chartView.setVisibleXRange(minXRange: .month, maxXRange: .month)
            } else if timeIntervalConfiguration.representedTimeInterval == 6 * .month {
                timeIntervalSelection.selectedSegmentIndex = 2
                chartView.xAxis.setLabelCount(6, force: true)
                chartView.setVisibleXRange(minXRange: 6 * .month, maxXRange: 6 * .month)
            } else if timeIntervalConfiguration.representedTimeInterval == .year {
                timeIntervalSelection.selectedSegmentIndex = 3
                chartView.xAxis.setLabelCount(12, force: true)
                chartView.setVisibleXRange(minXRange: .year, maxXRange: .year)
            }
            
            
            chartView.xAxis.enabled = true
            
            
            if #available(iOS 13.0, *) {
                chartView.xAxis.axisLineColor = UIColor.label
                chartView.xAxis.labelTextColor = UIColor.label
            } else {
                chartView.xAxis.axisLineColor = UIColor.black
                chartView.xAxis.labelTextColor = UIColor.black
            }
            
            chartView.xAxis.axisMinimum = timeIntervalConfiguration.startDate.startOfDay.timeIntervalSince1970
            chartView.xAxis.axisMaximum = timeIntervalConfiguration.endDate.startOfDay.timeIntervalSince1970
            
            chartView.xAxis.labelPosition = .bottom
            
            
            chartView.xAxis.gridAntialiasEnabled = true
            
            
            
            
            chartView.rightAxis.enabled = true
            if #available(iOS 13.0, *) {
                chartView.rightAxis.axisLineColor = UIColor.label
                chartView.rightAxis.labelTextColor = UIColor.label
            } else {
                chartView.rightAxis.axisLineColor = UIColor.black
                chartView.rightAxis.labelTextColor = UIColor.black
            }
            
            chartView.leftAxis.axisMinimum = 0
            chartView.rightAxis.axisMinimum = 0
            chartView.rightAxis.labelCount = 4
            
            if #available(iOS 13.0, *) {
                chartView.rightAxis.gridColor = UIColor.label.withAlphaComponent(0.5)
                chartView.xAxis.gridColor = UIColor.label.withAlphaComponent(0.5)
            } else {
                chartView.rightAxis.gridColor = UIColor.black.withAlphaComponent(0.5)
                chartView.xAxis.gridColor = UIColor.black.withAlphaComponent(0.5)
            }
            
            chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, base) -> String in
                return "\(Int(value))"
            })
            
            chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, base) -> String in
                let date = Date(timeIntervalSince1970: value)
                
                
                if timeIntervalConfiguration.representedTimeInterval == .week {
                    return date.shortWeekDay
                } else if timeIntervalConfiguration.representedTimeInterval == .month {
                    return date.shortDayOfMonth
                } else if timeIntervalConfiguration.representedTimeInterval == 6 * .month {
                    return date.shortMonth
                } else if timeIntervalConfiguration.representedTimeInterval == .year {
                    return date.shortMonth
                }
                
                return date.humanReadableDateString
            })
            
            chartView.leftAxis.enabled = false
            
            chartView.chartDescription.enabled = false
            
            chartView.dragEnabled = false
            chartView.setScaleEnabled(false)
            
            chartView.backgroundColor = UIColor.clear
            chartView.legend.enabled = false
            chartView.pinchZoomEnabled = false
            chartView.drawGridBackgroundEnabled = false
            chartView.delegate = self
            
            let accumulatedDataPoints = dataPoints.accumulate(for: timeIntervalConfiguration, accumulationType: .average)
            let dataEntries = accumulatedDataPoints.barChartDataEntries
            
            
            let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart")
            barChartDataSet.colors = [ .systemBlue ]
            let barChartData = BarChartData(dataSets: [barChartDataSet])
            barChartData.setDrawValues(false)
            
            
            
            barChartData.barWidth = timeIntervalConfiguration.granularity * 0.75
            
            
            
            //            let combinedData = CombinedChartData()
            
            //            combinedData.barData = barChartData
            chartView.data = barChartData
            chartView.notifyDataSetChanged()
            
            
            let averageValue = dataPoints.averageValue
            let localizedValue = LocalizedValue(value: "\(Int(averageValue))", unit: "×")
            self.bigValueLabel.attributedText = localizedValue.attributedString(ofSize: 28, weight: .semibold)
            
            
            timeFrameLabel.text = "\(timeIntervalConfiguration.startDate.humanReadableDateString) – \(timeIntervalConfiguration.endDate.humanReadableDateString)"
            
            if timeIntervalConfiguration.timeInterval == .year {
                timeIntervalLabel.text = "MONTHLY AVERAGE"
            } else {
                timeIntervalLabel.text = "DAILY AVERAGE"
            }
            
        }
    }
    
    public static var nib: UINib {
        return UINib(nibName: "FredKitChartTableViewCell", bundle: Bundle.module)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        
        leftButton.setTitle("", for: .normal)
        rightButton.setTitle("", for: .normal)
        
        
        
        
        if #available(iOS 14.0, *) {
            let menuElements = [
                UIAction(title: "Bouldering", handler: { _ in
                    
                }),
                UIAction(title: "Top Rope", handler: { _ in
                    
                }),
                UIAction(title: "Sport Climbing", handler: { _ in
                    
                })
            ]
            
            filterbutton.menu = UIMenu(title: "Chart Filter Options", image: nil, identifier: nil, options: [], children: menuElements)
            filterbutton.showsMenuAsPrimaryAction = true
        } else {
            filterBackground.isHidden = true
        }
        
        self.refreshChart()
        // Initialization code
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        filterBackground.layer.masksToBounds = true
        filterBackground.layer.cornerRadius = filterBackground.frame.height / 2
        
        dateSelectionBackgroundView.layer.masksToBounds = true
        dateSelectionBackgroundView.layer.cornerRadius = dateSelectionBackgroundView.frame.height / 2
        
        //        rightButton.layer.masksToBounds = true
        //        rightButton.layer.cornerRadius = rightButton.frame.height / 2
    }
}

extension FredKitChartTableViewCell: ChartViewDelegate {
    
}

#endif

