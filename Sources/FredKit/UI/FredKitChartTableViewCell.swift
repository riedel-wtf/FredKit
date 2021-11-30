//
//  FredKitChartTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 22.11.21.
//

#if os(iOS)
import UIKit
import Charts

public enum ChartType {
    case seasonal, timeline
}

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
            return 24
        case .year:
            return 12
        }
    }
    
    var numberOfLabelsPerPage: Int {
        switch self {
        case .day:
            return 6
        case .week:
            return 7
        case .month:
            return 5
        case .sixMonths:
            return 6
        case .year:
            return 12
        }
    }
    
    func formattedLabel(for value: Double) -> String {
        let date = Date(timeIntervalSince1970: value)
        switch self {
        case .day:
            return date.shortTimeString
        case .week:
            return date.shortWeekDay
        case .month:
            return date.shortDayOfMonth
        case .sixMonths:
            return date.shortMonth
        case .year:
            return date.shortMonth
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

public struct FredKitChartConfiguration {
    
    var chartTimeInterval: ChartTimeInterval {
        didSet {
            self.refreshInternalData()
        }
    }
    
    var endDate: Date
    var startDate: Date
    var accumulationType: AccumulationType
    let chartTitle: String
    let availableFilterOptions: [String]
    let dataPointFilter: ((String?) -> [FredKitDataPoint])?
    var localizedValueFormatter: (Double) -> String
    let chartType: ChartType
    
    var dataPoints: [FredKitDataPoint] {
        didSet {
            print("did set dataPoints: \(dataPoints.count)")
        }
    }
    
    var numberOfSegmentsPerPage: Int {
        return chartTimeInterval.numberOfSegmentsPerPage
    }
    
    var numberOfPages: Double {
        return totalTimeInterval / pageTimeInterval
    }
    
    var segmentTimeInterval: TimeInterval {
        return totalTimeInterval / Double(totalNumberOfSegments)
    }
    
    var isFilteringAvailable: Bool {
        return availableFilterOptions.count > 0 && dataPointFilter != nil
    }
    
    public init(chartTitle: String, dataPoints: [FredKitDataPoint], availableFilterOptions: [String] = [], chartTimeInterval: ChartTimeInterval, chartType: ChartType, accumulationType: AccumulationType, localizedValueFormatter: @escaping (Double) -> String, dataPointFilter: ((String?) -> [FredKitDataPoint])? ) {
        self.dataPoints = dataPoints
        self.availableFilterOptions = availableFilterOptions
        self.dataPointFilter = dataPointFilter
        self.chartTitle = chartTitle
        self.chartTimeInterval = chartTimeInterval
        self.endDate = chartTimeInterval.endDate(for: dataPoints.endDate)
        
        switch chartType {
        case .seasonal:
            self.startDate = chartTimeInterval.startDate(for: dataPoints.endDate)
        case .timeline:
            self.startDate = chartTimeInterval.startDate(for: dataPoints.startDate)
        }
        
        self.localizedValueFormatter = localizedValueFormatter
        self.accumulationType = accumulationType
        self.chartType = chartType
    }
    
    var pageTimeInterval: TimeInterval {
        return chartTimeInterval.timeInterval
    }
    
    var totalTimeInterval: TimeInterval {
        return endDate.timeIntervalSince(startDate)
    }
    
    var totalNumberOfSegments: Int {
        return Int(ceil(Double(numberOfSegmentsPerPage) * numberOfPages))
    }
    
    mutating private func refreshInternalData() {
        self.endDate = chartTimeInterval.endDate(for: dataPoints.endDate)
        switch chartType {
        case .seasonal:
            self.startDate = chartTimeInterval.startDate(for: dataPoints.endDate)
        case .timeline:
            self.startDate = chartTimeInterval.startDate(for: dataPoints.startDate)
        }
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
    
    @IBOutlet weak var chartSubtitleLabel: UILabel!
    
    @IBOutlet weak var bigValueLabel: UILabel!
    
    @IBOutlet weak var filterBackground: UIVisualEffectView!
    @IBOutlet weak var timeIntervalSelection: UISegmentedControl!
    @IBOutlet weak var timeFrameLabel: UILabel!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    var currentlyActiveFilterOption: String? {
        didSet {
            if let timeIntervalConfiguration = self.timeIntervalConfiguration {
                if let currentlyActiveFilterOption = currentlyActiveFilterOption {
                    self.timeIntervalConfiguration?.dataPoints = timeIntervalConfiguration.dataPointFilter!(currentlyActiveFilterOption)
                    self.filterbutton.setTitle(currentlyActiveFilterOption, for: .normal)
                } else {
                    self.timeIntervalConfiguration?.dataPoints = timeIntervalConfiguration.dataPointFilter!(nil)
                    self.filterbutton.setTitle("Filter", for: .normal)
                }
                self.refreshChart()
            }
        }
    }
    
    public var timeIntervalConfiguration: FredKitChartConfiguration? {
        didSet {
            self.refreshChart()
        }
    }
    
    var accumulatedDataPoints: [FredKitDataPoint]?
    
    
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
            } else if sender.selectedSegmentIndex == 4 {
                timeIntervalConfiguration.chartTimeInterval = .day
            }
            
            self.timeIntervalConfiguration = timeIntervalConfiguration
        }
        
        self.refreshChart()
    }
    
    public override func prepareForReuse() {
        self.filterbutton.setTitle("Filter", for: .normal)
        loadingIndicator.stopAnimating()
    }
    
    
    func refreshChart() {
        
        if let timeIntervalConfiguration = timeIntervalConfiguration {
            
            if #available(iOS 14.0, *) {
                
                if !timeIntervalConfiguration.isFilteringAvailable {
                    filterBackground.isHidden = true
                } else {
                    filterBackground.isHidden = false
                    
                    var menuElements = [UIAction]()
                    
                    let showAll = UIAction(title: "Show All") { _ in
                        self.currentlyActiveFilterOption = nil
                    }
                    
                    menuElements.append(showAll)
                    
                    let filterOptionActions = timeIntervalConfiguration.availableFilterOptions.map({ filterOption in
                        UIAction(title: filterOption, handler: { _ in
                            self.currentlyActiveFilterOption = filterOption
                        })
                    })
                    
                    menuElements.append(contentsOf: filterOptionActions)
                    
                    filterbutton.menu = UIMenu(title: "Available Filter Options", image: nil, identifier: nil, options: [], children: menuElements)
                    filterbutton.showsMenuAsPrimaryAction = true
                }
                
                
            } else {
                filterBackground.isHidden = true
            }
            
            self.chartSubtitleLabel.text = timeIntervalConfiguration.chartTitle
            
            switch timeIntervalConfiguration.chartTimeInterval {
            case .day:
                timeIntervalSelection.selectedSegmentIndex = 4
            case .week:
                timeIntervalSelection.selectedSegmentIndex = 0
            case .month:
                timeIntervalSelection.selectedSegmentIndex = 1
            case .sixMonths:
                timeIntervalSelection.selectedSegmentIndex = 2
            case .year:
                timeIntervalSelection.selectedSegmentIndex = 3
            }
            
            chartView.xAxis.setLabelCount(timeIntervalConfiguration.chartTimeInterval.numberOfLabelsPerPage, force: false)
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
                return timeIntervalConfiguration.localizedValueFormatter(value)
            })
            
            chartView.xAxis.avoidFirstLastClippingEnabled = false
            
            chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, base) -> String in
                return timeIntervalConfiguration.chartTimeInterval.formattedLabel(for: value)
            })
            
            chartView.leftAxis.enabled = false
            
            chartView.chartDescription.enabled = false
            
            chartView.setScaleEnabled(false)
            
            chartView.backgroundColor = UIColor.clear
            chartView.legend.enabled = false
            chartView.pinchZoomEnabled = false
            chartView.drawGridBackgroundEnabled = false
            chartView.delegate = self
            
            loadingIndicator.startAnimating()
            if #available(iOS 10.0, *) {
                timeIntervalConfiguration.dataPoints.accumulate(for: timeIntervalConfiguration, accumulationType: timeIntervalConfiguration.accumulationType) { accumulatedDataPoints in
                    DispatchQueue.main.async {
                        self.accumulatedDataPoints = accumulatedDataPoints
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
                        self.chartView.dragYEnabled = false
                        self.chartView.dragXEnabled = true
                        self.refreshValuesForCurrentChartRange()
                        self.refreshYAxisForCurrentlyVisibleData()
                        self.chartView.moveViewTo(xValue: self.chartView.chartXMax, yValue: 0, axis: .right)
                    }
                }
            }
            
            let averageValue = timeIntervalConfiguration.dataPoints.averageValue
            let localizedValue = LocalizedValue(value: "\(Int(averageValue))", unit: "×")
            self.bigValueLabel.attributedText = localizedValue.attributedString(ofSize: 28, weight: .semibold)
            
            
            timeFrameLabel.text = "\(timeIntervalConfiguration.startDate.humanReadableDateString) – \(timeIntervalConfiguration.endDate.humanReadableDateString)"
            
            
            timeIntervalLabel.text = timeIntervalConfiguration.accumulationType.rangeTitle
            
            
        }
    }
    
    public static var nib: UINib {
        return UINib(nibName: "FredKitChartTableViewCell", bundle: Bundle.module)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        self.refreshChart()
        // Initialization code
    }
    
    func refreshValuesForCurrentChartRange() {
        if #available(iOS 10.0, *) {
            let visibleDateInterval = self.chartView.visibleDateInterval
            
            timeFrameLabel.text = visibleDateInterval.humanReadableDateInterval(shouldContainDay: true)
            
            if let dataPoints = self.timeIntervalConfiguration?.dataPoints, let accumulationType = timeIntervalConfiguration?.accumulationType {
                let visibleDataPoints = dataPoints.filteredDataPoints(for: visibleDateInterval)
                let accumulatedValue = visibleDataPoints.accumulated(for: accumulationType)
                self.bigValueLabel.text = self.timeIntervalConfiguration?.localizedValueFormatter(accumulatedValue)
            }
        }
    }
    
    func refreshYAxisForCurrentlyVisibleData() {
        if #available(iOS 10.0, *) {
            if let accumulatedDataPoints = self.accumulatedDataPoints {
                let visibleDateInterval = self.chartView.visibleDateInterval
                let visibleDataPoints = accumulatedDataPoints.filteredDataPoints(for: visibleDateInterval)
                let maximum = visibleDataPoints.maximumValue
                
                //                UIView.animate(withDuration: 0.25) {
                //                    self.chartView.setVisibleYRangeMaximum(maximum, axis: .right)
                //                    self.chartView.setVisibleYRangeMinimum(maximum, axis: .right)
                //                    self.chartView.moveViewTo(xValue: self.chartView.lowestVisibleX, yValue: 0, axis: .right)
                //                }
            }
        }
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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let value = self.chartView.valueForTouchPoint(point: touch.location(in: self.chartView), axis: .right)
            print("value: \(value.x)")
        }
    }
    
    var panningEndTimer: Timer?
    var lastDx: CGFloat = 0.0
}

extension FredKitChartTableViewCell: ChartViewDelegate {
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        self.refreshValuesForCurrentChartRange()
        print(self.chartView.viewPortHandler.transY)
        
        if abs(lastDx - dX) > 0.1 {
            panningEndTimer?.invalidate()
            lastDx = dX
            if #available(iOS 10.0, *) {
                panningEndTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { _ in
                    self.refreshYAxisForCurrentlyVisibleData()
                })
            }
        }
        
        
        print("dx: \(dX) dy: \(dY)")
        
        
    }
    
    public func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.x)
        self.chartView.highlightValues(nil)
    }
    
    public func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        print("STOP SCROLLING?!")
    }
}

extension BarChartView {
    @available(iOS 10.0, *)
    var visibleDateInterval: DateInterval {
        let pageStartDate = Date(timeIntervalSince1970: self.lowestVisibleX)
        let pageEndDate = Date(timeIntervalSince1970: self.highestVisibleX)
        return DateInterval(start: pageStartDate, end: pageEndDate)
    }
}

#endif

