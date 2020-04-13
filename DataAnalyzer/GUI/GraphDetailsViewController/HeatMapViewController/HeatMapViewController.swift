//
//  HeatMapViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import SigmaSwiftStatistics
import CoreData

@IBDesignable class InsetLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0

    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset

        return adjSize
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset

        return contentSize
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func roundedUp(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded(.up) / divisor
    }
    
    func roundedDown(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded(.down) / divisor
    }
    
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}



class HeatMapLabelContainerView: UIView {
    
    private var labelViews = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelWidth() -> CGFloat {
        return CGFloat(250.0)
    }
    
    func setLabels(_ labels: [String]?, alignment: NSTextAlignment = .left) -> CGFloat {
        
        var totalHeight = CGFloat(0)
        for l in labelViews {
            l.removeFromSuperview()
        }
        labelViews.removeAll()
        
        guard let labels = labels else {
            return totalHeight
        }
                
        let labelHeight = CGFloat(50.0)
        let labelWidth = self.labelWidth()
        
        for (i, text) in labels.enumerated() {
            
            let x = CGFloat(0)
            let y = CGFloat(i) * labelHeight
            let w = labelWidth
            let h = labelHeight
            
            let label = InsetLabel(frame: CGRect(x: x, y: y, width: w, height: h))
            label.insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
            label.text = text
            label.textAlignment = alignment
            labelViews.append(label)
            self.addSubview(label)
            
            totalHeight += (x + labelHeight)
        }
        
        return totalHeight
    }
    
    
    
}


class HeatMapMatrixView: UIView {
    
    var maxColor: UIColor!
    var minColor: UIColor!
    var valuesVisible: Bool = false
    
    var width: Int = 0
    var height: Int = 0
    
    var values: [[Double]]?
    
    let valueFormatter = NumberFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        valueFormatter.minimumFractionDigits = 3
        valueFormatter.maximumFractionDigits = 5
        
    }
    
    func stringFromValue(_ value: Double) -> String {
        return valueFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ frame: CGRect) {
        
        let height = frame.height / CGFloat(self.width)
        let width = frame.width / CGFloat(self.width)
        for w in 0..<self.width {
            for h in 0..<self.height {
                
                UIColor.white.setFill()
                if values!.count > h {
                    let row = values![h]
                    if row.count > w {
                        
                        let drect = CGRect(x: (CGFloat(w) * width), y: (CGFloat(h) * height), width: (CGFloat(width)), height: (CGFloat(height)))
                        let bpath: UIBezierPath = UIBezierPath(rect: drect)
                        
                        let col = row[w]
                        
                        let color = colorForValue(value: col)
                        color.setFill()
                        bpath.fill()
                        
                        if valuesVisible {
                            let valueString = stringFromValue(col)// String(format:"%.2f",col)
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            let font = UIFont.systemFont(ofSize: 10)
                            let attributes = [
                                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                NSAttributedString.Key.font: font,
                                NSAttributedString.Key.foregroundColor: UIColor.black
                            ]
                            
                            let textInset = drect.insetBy(dx: 0, dy: (drect.height - font.pointSize)/2)
                            valueString.draw(in: textInset, withAttributes: attributes)
                        }
                    }
                }
            }
        }
    }
    
    func colorForValue(value: Double) -> UIColor {
                
        let whiteColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if value > 0.0 {
            let min = 0.0
            let max = 1.0
            let percentage = CGFloat( (value - min) / (max - min))
            return whiteColor.interpolateRGBColorTo(maxColor, fraction: percentage)!
        }
        else {
            let min = -1.0
            let max = 0.0
            let percentage = CGFloat( (value - min) / (max - min))
            return minColor.interpolateRGBColorTo(whiteColor, fraction: percentage)!
        }
    }
    
    
    
    func setSize(_ size: Int? = 0) {
        self.width = size!
        self.height = size!
        setNeedsDisplay()
    }
    
    func setValues(_ values: [[Double]]) {
        self.values = values
    }
    
}


extension UIColor {
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
        let f = min(max(0, fraction), 1)

        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }

        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


class HeatMapContainerView: UIView {
    
    private var maxColor: UIColor!
    private var minColor: UIColor!
    private var valuesVisible: Bool = false
    
    
    private(set) var labels: [String]?
    private(set) var corrolation: [[Double]]?
    
    private var leftAxisLabelContainer = HeatMapLabelContainerView()
    private var bottomAxisLabelContainer = HeatMapLabelContainerView()
    private var heatMapMatrixView = HeatMapMatrixView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        self.addSubview(leftAxisLabelContainer)
        self.addSubview(bottomAxisLabelContainer)
        self.addSubview(heatMapMatrixView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColors(max: UIColor, min: UIColor) {
        maxColor = max
        minColor = min
    }
    
    func setValuesVisible(_ visible: Bool) {
        valuesVisible = visible
    }
    
    
    func setLabels(_ labels: [String]?, corrolation: [[Double]]?) {
        
        self.labels = labels
        
        if leftAxisLabelContainer.superview != nil {
            leftAxisLabelContainer.removeFromSuperview()
        }
        if bottomAxisLabelContainer.superview != nil{
            bottomAxisLabelContainer.removeFromSuperview()
        }
        if heatMapMatrixView.superview != nil{
            heatMapMatrixView.removeFromSuperview()
        }
        
        guard let labels = labels else {
            return
        }
        
        
        leftAxisLabelContainer = HeatMapLabelContainerView()
        bottomAxisLabelContainer = HeatMapLabelContainerView()
        heatMapMatrixView = HeatMapMatrixView()
        heatMapMatrixView.minColor = minColor
        heatMapMatrixView.maxColor = maxColor
        heatMapMatrixView.valuesVisible = valuesVisible
        
        self.addSubview(leftAxisLabelContainer)
        self.addSubview(bottomAxisLabelContainer)
        self.addSubview(heatMapMatrixView)
        
        let edgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        
        
        
        let height = leftAxisLabelContainer.setLabels(labels, alignment: .right)
        let width = leftAxisLabelContainer.labelWidth()
        leftAxisLabelContainer.frame = CGRect(x: edgeInsets.left, y: width + edgeInsets.top, width: width, height: height)

        let _ = bottomAxisLabelContainer.setLabels(labels)
        bottomAxisLabelContainer.frame = CGRect(x: ((height + width) / 2.0) + edgeInsets.left, y: (-(height - width)/2.0) + edgeInsets.top, width: width, height: height)
        bottomAxisLabelContainer.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)


        heatMapMatrixView.setSize(labels.count)
        heatMapMatrixView.backgroundColor = UIColor.white

        heatMapMatrixView.setValues(corrolation!)

        heatMapMatrixView.frame = CGRect(x: width + edgeInsets.left, y: width + edgeInsets.top, width: height, height: height)

        
        var frame = self.frame
        frame.size.width = width + height + edgeInsets.left + edgeInsets.right
        frame.size.height = width + height + edgeInsets.top + edgeInsets.bottom
        
        self.frame = frame
    }
    
    
}

class CalculationIndicatorView: UIView {
    
    private var activityIndicator: UIActivityIndicatorView!
    private var activityIndicatorLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.black
        addSubview(activityIndicator)
        
        activityIndicatorLabel = UILabel(frame: .zero)
        activityIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorLabel.textColor = UIColor.black
        activityIndicatorLabel.textAlignment = .center
        addSubview(activityIndicatorLabel)
        
        let defaultConstraints = [
            activityIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: activityIndicatorLabel.topAnchor),
            
            activityIndicatorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            activityIndicatorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            activityIndicatorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(defaultConstraints)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMessage(_ message: String?) {
        activityIndicatorLabel.text = message
    }
    
    class func showFrom(view: UIView, message: String) -> CalculationIndicatorView {
        
        let activityView = CalculationIndicatorView(frame: .zero)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.setMessage(message)
        
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activityView.activityIndicator.startAnimating()
        return activityView
        
    }
        
    func hide() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
    
}



class HeatMapViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var heatMapContainer = HeatMapContainerView()
    
    var calculationQueue = CalculationsOperationQueue()
    
    private var heatmapTheme = HeatmapTheme()
    
    private var result: HeatMapResult?
    
    var dataset: GraphRawData? {
        didSet {
            if let dataset = dataset, self.isViewLoaded {
                
                let activityIndicatorView = CalculationIndicatorView.showFrom(view: self.view, message: NSLocalizedString("Generating Heatmap", comment: ""))
                self.heatMapContainer.setLabels(nil, corrolation: nil)
                self.calculationQueue.calculateHeatMap(dataset) {
                    (result, error) in
                    
                    self.result = result
                    self.drawHeatmap()
                    activityIndicatorView.hide()
                }
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return heatMapContainer
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var top: CGFloat = 0.0
        var left: CGFloat = 0.0
        
        if scrollView.contentSize.width < self.view.bounds.size.width {
            left = (self.view.bounds.size.width - scrollView.contentSize.width) * 0.5
        }
        if scrollView.contentSize.height < self.view.bounds.size.height {
            top = (self.view.bounds.size.height - scrollView.contentSize.height) * 0.5
        }
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
    }
    
    @objc func updateTheme() {
        do {
            let context = CoreDataController.shared.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
            let settings = try context!.fetch(fetchRequest) as! [Settings]
            if let settingsObject = settings.first {
                heatmapTheme.maxColor = settingsObject.heatmapMaxColor as! UIColor
                heatmapTheme.minColor = settingsObject.heatmapMinColor as! UIColor
                heatmapTheme.valuesVisible = settingsObject.heatmapValuesVisible
                heatMapContainer.setColors(max: heatmapTheme.maxColor, min: heatmapTheme.minColor)
                heatMapContainer.setValuesVisible(heatmapTheme.valuesVisible)
                drawHeatmap()
            }
        }
        catch {
            ErrorAlertView.showError(with: String(describing: error), from: self)
        }
    }
    

    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: NSNotification.Name(rawValue: "SettingsChanged"), object: nil)
        
        updateTheme()
        
        self.view.backgroundColor = UIColor.white
        
        heatMapContainer.frame = self.view.bounds
        heatMapContainer.layer.borderColor = UIColor.lightGray.cgColor
        heatMapContainer.layer.borderWidth = 1.0

        
        heatMapContainer.setColors(max: heatmapTheme.maxColor, min: heatmapTheme.minColor)
        heatMapContainer.setValuesVisible(heatmapTheme.valuesVisible)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0
        
        
        scrollView.addSubview(heatMapContainer)
        self.view.addSubview(scrollView)
        
        let defaultConstraints = [
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]

        NSLayoutConstraint.activate(defaultConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // if needs scroll
        if heatMapContainer.bounds.size.width > self.view.bounds.size.width  ||
            heatMapContainer.bounds.size.height > self.view.bounds.size.height {

        }
        else {
            heatMapContainer.frame = CGRect(x: (self.view.bounds.size.width - heatMapContainer.bounds.size.width) / 2.0,
                                            y: 0.0,
                                            width: heatMapContainer.bounds.size.width,
                                            height: heatMapContainer.bounds.size.height)
            
        }
        scrollView.contentSize = heatMapContainer.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataset = dataset {
            let activityIndicatorView = CalculationIndicatorView.showFrom(view: self.view, message: NSLocalizedString("Generating Heatmap", comment: ""))
            self.calculationQueue.calculateHeatMap(dataset) {
                
                [weak self] (result, error) in

                guard let self = self else {
                    return
                }
                
                self.result = result
                self.drawHeatmap()
                activityIndicatorView.hide()
            }
        }
    }
    
    func drawHeatmap() {
        self.heatMapContainer.setLabels(result?.labels, corrolation: result?.matrix)
        self.view.setNeedsLayout()
    }
}
