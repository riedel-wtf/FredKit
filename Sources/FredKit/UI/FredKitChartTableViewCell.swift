//
//  FredKitChartTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 22.11.21.
//

#if os(iOS)
import UIKit
import Charts

public enum ChartTimeInterval {
    case day, week, month, sixMonths, year
    
    
    var numberOfSegmentsPerPage: Int {
        switch self {
        case .day:
            return 24
        case .week:
            return 7
        case .month:
            return 30
        case .sixMonths:
            return 6
        case .year:
            return 12
        }
    }
    
    var timeInterval: TimeInterval {
        switch self {
        case .day:
            return .day
        case .week:
            return .week
        case .month:
            return .month
        case .sixMonths:
            return 6 * .month
        case .year:
            return .year
        }
    }
    
    func startDate(for date: Date) -> Date {
        switch self {
        case .day:
            return date.startOfDay
        case .week:
            return date.startOfWeek
        case .month:
            return date.startOfMonth
        case .sixMonths:
            return date.startOfMonth
        case .year:
            return date.startOfYear
        }
    }
    
    func endDate(for date: Date) -> Date {
        switch self {
        case .day:
            return date.endOfDay
        case .week:
            return date.endOfWeek
        case .month:
            return date.endOfMonth
        case .sixMonths:
            return date.endOfMonth
        case .year:
            return date.endOfYear
        }
    }
}

public struct ChartTimeIntervalConfiguration {
    
    var chartTimeInterval: ChartTimeInterval {
        didSet {
            self.refreshInternalData()
        }
    }
    
    var endDate: Date
    var startDate: Date
    
    var numberOfSegmentsPerPage: Int {
        return chartTimeInterval.numberOfSegmentsPerPage
    }
    
    var numberOfPages: Double {
        return totalTimeInterval / pageTimeInterval
    }
    
    var segmentTimeInterval: TimeInterval {
        return totalTimeInterval / Double(totalNumberOfSegments)
    }
    
    public init(dataPoints: [FredKitDataPoint], chartTimeInterval: ChartTimeInterval) {
        self.chartTimeInterval = chartTimeInterval
        self.endDate = chartTimeInterval.endDate(for: dataPoints.endDate)
        self.startDate = chartTimeInterval.startDate(for: dataPoints.startDate)
        self.refreshInternalData()
    }
    
    var pageTimeInterval: TimeInterval {
        return chartTimeInterval.timeInterval
    }
    
    var totalTimeInterval: TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
    
    var totalNumberOfSegments: Int {
        return Int(Double(numberOfSegmentsPerPage) * numberOfPages)
    }
    
    mutating private func refreshInternalData() {
        self.startDate = self.chartTimeInterval.startDate(for: startDate)
        self.endDate = self.chartTimeInterval.endDate(for: endDate)
    }
    
    
    @available(iOS 10.0, *)
    var segmentIntervals: [DateInterval] {
        var intervals = [DateInterval]()
        
        (0..<totalNumberOfSegments).forEach { intervalIndex in
            let startDate = startDate.addingTimeInterval(segmentTimeInterval * Double(intervalIndex))
            let endDate = startDate.addingTimeInterval(segmentTimeInterval)
            intervals.append(DateInterval(start: startDate, end: endDate))
        }
        
        return intervals
    }
}

public class FredKitChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var filterbutton: UIButton!

    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    
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
                timeIntervalConfiguration.chartTimeInterval = .week
            } else if sender.selectedSegmentIndex == 1 {
                timeIntervalConfiguration.chartTimeInterval = .month
            } else if sender.selectedSegmentIndex == 2 {
                timeIntervalConfiguration.chartTimeInterval = .sixMonths
            } else if sender.selectedSegmentIndex == 3 {
                timeIntervalConfiguration.chartTimeInterval = .year
            }
            
            self.timeIntervalConfiguration = timeIntervalConfiguration
        }
        
        
        self.refreshChart()
    }
    
    public override func prepareForReuse() {
        loadingIndicator.stopAnimating()
    }
    
    
    func refreshChart() {
        
        //        chartView.setRoundedCorner(roundedCorner: [.topLeft, .topRight], roundedHeight: 50)
        
        if let timeIntervalConfiguration = timeIntervalConfiguration, let dataPoints = dataPoints {
            
            switch timeIntervalConfiguration.chartTimeInterval {
            case .day:
                timeIntervalSelection.selectedSegmentIndex = 0
            case .week:
                timeIntervalSelection.selectedSegmentIndex = 0
            case .month:
                timeIntervalSelection.selectedSegmentIndex = 1
            case .sixMonths:
                timeIntervalSelection.selectedSegmentIndex = 2
            case .year:
                timeIntervalSelection.selectedSegmentIndex = 3
            }
            
            chartView.xAxis.setLabelCount(timeIntervalConfiguration.numberOfSegmentsPerPage, force: false)
            chartView.xAxis.granularity = timeIntervalConfiguration.segmentTimeInterval
            
            chartView.xAxis.enabled = true
            chartView.xAxis.centerAxisLabelsEnabled = true
            
            
            if #available(iOS 13.0, *) {
                chartView.xAxis.axisLineColor = UIColor.label
                chartView.xAxis.labelTextColor = UIColor.label
            } else {
                chartView.xAxis.axisLineColor = UIColor.black
                chartView.xAxis.labelTextColor = UIColor.black
            }
            
            chartView.xAxis.axisMinimum = timeIntervalConfiguration.startDate.timeIntervalSince1970
            chartView.xAxis.axisMaximum = timeIntervalConfiguration.endDate.timeIntervalSince1970
            
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
            
            chartView.xAxis.avoidFirstLastClippingEnabled = false
            
            chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, base) -> String in
                let date = Date(timeIntervalSince1970: value)
                
                
                switch timeIntervalConfiguration.chartTimeInterval {
                case .day:
                    return date.shortTimeString
                case .week:
                    return date.shortWeekDay
                case .month:
                    return date.shortDayOfMonth
                case .sixMonths:
                    return date.singleCharacterMonth
                case .year:
                    return date.singleCharacterMonth
                }
                
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
            
            loadingIndicator.startAnimating()
            if #available(iOS 10.0, *) {
                dataPoints.accumulate(for: timeIntervalConfiguration, accumulationType: .sum) { accumulatedDataPoints in
                    
                    self.loadingIndicator.stopAnimating()
                    let dataEntries = accumulatedDataPoints.barChartDataEntries
                    
                    
                    let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart")
                    barChartDataSet.colors = [ .systemBlue ]
                    let barChartData = BarChartData(dataSets: [barChartDataSet])
                    barChartData.setDrawValues(false)
                    
                    barChartData.barWidth = timeIntervalConfiguration.segmentTimeInterval * 0.75
                    
                    self.chartView.data = barChartData
                    
                    self.chartView.notifyDataSetChanged()
                    
                    self.chartView.setVisibleXRange(minXRange: timeIntervalConfiguration.pageTimeInterval, maxXRange: timeIntervalConfiguration.pageTimeInterval)
                    self.chartView.dragEnabled = true
                }
            }


            
            
            
            let averageValue = dataPoints.averageValue
            let localizedValue = LocalizedValue(value: "\(Int(averageValue))", unit: "×")
            self.bigValueLabel.attributedText = localizedValue.attributedString(ofSize: 28, weight: .semibold)
            
            
            timeFrameLabel.text = "\(timeIntervalConfiguration.startDate.humanReadableDateString) – \(timeIntervalConfiguration.endDate.humanReadableDateString)"
            
            if timeIntervalConfiguration.chartTimeInterval == .year {
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
        
        //        rightButton.layer.masksToBounds = true
        //        rightButton.layer.cornerRadius = rightButton.frame.height / 2
    }
}

extension FredKitChartTableViewCell: ChartViewDelegate {
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        if #available(iOS 10.0, *) {
            timeFrameLabel.text = self.chartView.dateInterval.humanReadableDateInterval(shouldContainDay: true)
        }
    }
    
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        print("END PANNING")
    }
}

extension BarChartView {
    @available(iOS 10.0, *)
    var dateInterval: NSDateInterval {
        let pageStartDate = Date(timeIntervalSince1970: self.lowestVisibleX)
        let pageEndDate = Date(timeIntervalSince1970: self.highestVisibleX)
        return NSDateInterval(start: pageStartDate, end: pageEndDate)
    }
}

#endif

