//
//  BarPlotView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 01.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit


struct BarPlotTextItem {
    
    var value: String
    var basePoint: CGPoint
    var rotation: Float = Float(0).degreesToRadians
    var font: UIFont = UIFont.systemFont(ofSize: 10)
}




class BarPlotItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BarPlotContentView: UIView {
    
    
    var xAxisLabels: [String]?
    var yAxisLabels: [String]?
    
    
    var data:[BarDataPoint]?
    
    weak var containerView: BarPlotView?
    
    var textItems = [BarPlotTextItem]()
    var barPlotItemViews = [BarPlotItemView]()
    
    var lineWidth: CGFloat = 5.0
    var minimumBarWidth: CGFloat = 30.0
    
    var plotInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    var showEstimateValuesOnXAxis = true
    
    var enableHorizontalScrolling: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        plotView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y,
        //                                width: plotWidth,
        //                                height: self.bounds.size.height);
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if let context = UIGraphicsGetCurrentContext() {
            context.setLineCap(.round)
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(lineWidth)

            context.beginPath()
            context.move(to: CGPoint(x: plotInsets.left, y: plotInsets.top))
            context.addLine(to: CGPoint(x: plotInsets.left, y: bounds.height - plotInsets.bottom))

            context.move(to: CGPoint(x: plotInsets.left, y: bounds.height - plotInsets.bottom))
            context.addLine(to: CGPoint(x: bounds.width - plotInsets.left, y: bounds.height - plotInsets.bottom))

            context.strokePath()
            
            for textItem in textItems {
                
                textItem.value.drawWithBasePoint(basePoint: textItem.basePoint, angle: CGFloat(textItem.rotation), font: textItem.font)
            }
        }
    }
    
    func didScroll() {
        plotGraph()
    }
    
    func plotGraph() {
        
        for barItemView in barPlotItemViews {
            barItemView.removeFromSuperview()
        }
        
        guard let data = self.data else {
            return
        }
        
        let maxPoints = data//.prefix(100)
        
        
        var barWidthToUse = self.minimumBarWidth
        
//        if enableHorizontalScrolling {
//            containerView?.plotWidth = self.minimumBarWidth * CGFloat(maxPoints.count) + self.plotInsets.left + self.plotInsets.right
//        }
//        else {
//            let width = superview!.bounds.size.width
//            containerView?.plotWidth = width
//
//            barWidthToUse = (width - self.plotInsets.left - self.plotInsets.right) / CGFloat(maxPoints.count)
//        }
//
        
        
        
        
        
        
        
        
        barPlotItemViews.removeAll()
        
        
        let visibleWidth = (containerView!.bounds.size.width - self.plotInsets.left - self.plotInsets.right - self.lineWidth)
        
        
//        let maxVisibleBar = Int(ceil((self.containerView!.contentOffset.x + visibleWidth) / self.minimumBarWidth))
        
        
        
//        let minVisibleBar = Int(ceil((containerView!.contentOffset.x - self.lineWidth) / self.minimumBarWidth))
        //
        
        //
//        let maxXValue = data.maxXValue()
        let maxYValue = data.maxYValue()
        //        let minXValue = points.minXValue()
        //
        //
        var i = 0
        
//        for p in maxPoints {
//            
////            if i > maxVisibleBar {
////                break
////            }
//            let scaled = ((self.bounds.size.height - self.plotInsets.top - self.plotInsets.bottom - self.lineWidth) * CGFloat(p.y.value)) / CGFloat(maxYValue)
//            
//            
//            let barItemView = BarPlotItemView(frame: CGRect(x: (self.lineWidth + self.plotInsets.left) + (CGFloat(i) * barWidthToUse),
//                                                            y: bounds.height - self.plotInsets.bottom - scaled - self.lineWidth,
//                                                            width: barWidthToUse, height: scaled))
//            
//            let xValue = p.x.label
//            let xStartValue = String(xValue)
//            let font = UIFont.systemFont(ofSize: 10)
//            let attrs = [ NSAttributedString.Key.font: font ]
//            
//            let textSize: CGSize = xStartValue.size(withAttributes: attrs)
//            
//            
//            
//            
//            
//            barItemView.backgroundColor = UIColor.green
//            barPlotItemViews.append(barItemView)
//            self.addSubview(barItemView)
//            i += 1
//            
//            if !showEstimateValuesOnXAxis {
//                let xStartItem = BarPlotTextItem(value: xStartValue, basePoint: CGPoint(x: barItemView.frame.origin.x + (barWidthToUse - 2.0)/2.0,
//                                                                                        y: bounds.height - plotInsets.bottom + textSize.height))
//                textItems.append(xStartItem)
//            }
//            
//            
//        }
//        
//        if let xAxisLabels = xAxisLabels {
//            for i in 1 ..< xAxisLabels.count {
//                let xValue = xAxisLabels[i]
//                let font = UIFont.systemFont(ofSize: 20)
//                let attrs = [ NSAttributedString.Key.font: font ]
//                
//                let textSize: CGSize = xValue.size(withAttributes: attrs)
//
//                
//                let x = (((bounds.size.width - CGFloat(plotInsets.left + plotInsets.right))/4) * CGFloat(i)) + plotInsets.left
//                
//                
//                let xLabelItem = BarPlotTextItem(value: xValue, basePoint: CGPoint(x: x,
//                                                                                   y: bounds.height - plotInsets.bottom + textSize.height))
//                textItems.append(xLabelItem)
//            }
//        }
//        
//        if let yAxisLabels = yAxisLabels {
//            for i in 1 ..< yAxisLabels.count {
//                let yValue = yAxisLabels[i]
//                let font = UIFont.systemFont(ofSize: 20)
//                let attrs = [ NSAttributedString.Key.font: font ]
//                
//                let textSize: CGSize = yValue.size(withAttributes: attrs)
//
//                
////                let x = (((bounds.size.width - CGFloat(plotInsets.left + plotInsets.right))/4) * CGFloat(i)) + plotInsets.left
//                let y = bounds.height - (bounds.height / CGFloat(yAxisLabels.count)) * CGFloat(i) - textSize.height
//                
//                let yLabelItem = BarPlotTextItem(value: yValue, basePoint: CGPoint(x: 40,
//                                                                                   y: y))
//                textItems.append(yLabelItem)
//            }
//        }
        
        self.setNeedsDisplay()
    }
    
    func setData(points: [BarDataPoint]?, xLabel: String = "x", yLabel: String = "y") {

        
        self.data = points
        plotGraph()
        
        
        
        
    }
    
//    func imageWithView(view : UIView, text : NSString) -> UIImage {
//
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
//        view.layer.renderInContext(UIGraphicsGetCurrentContext()!);
//        // Setup the font specific variables
//        let attributes :[String:AnyObject] = [
//            NSFontAttributeName : UIFont(name: "Helvetica", size: 12)!,
//            NSStrokeWidthAttributeName : 0,
//            NSForegroundColorAttributeName : UIColor.blackColor()
//        ]
//        // Draw text with CGPoint and attributes
//        text.drawAtPoint(CGPointMake(view.frame.origin.x+10, view.frame.size.height-25), withAttributes: attributes);
//        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
//
//        UIGraphicsEndImageContext();
//        return img;
//    }
}



class BarPlotView3: UIScrollView, UIScrollViewDelegate {
    
    private var plotView: BarPlotContentView!
    
    var enableHorizontalScrolling = false {
        didSet {
            
        }
    }
    
    
    
    var axisLineWidth: CGFloat!
    {
        didSet {
            plotView.lineWidth = axisLineWidth
        }
    }
    
    fileprivate var plotWidth: CGFloat = 0.0 {
        didSet {
//            self.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: plotWidth, height: self.bo);
            
            
            self.contentSize = CGSize(width: plotWidth, height: self.bounds.size.height)
//            self.plotView.frame = CGRect(x: self.plotView.frame.origin.x,
//                                         y: self.plotView.frame.origin.y,
//                                         width: plotWidth,
//                                         height: self.contentSize.height)
            
            self.minimumZoomScale = (self.bounds.size.width - 50.0)  / self.contentSize.width
        }
        
    }
    

    var minimumBarWidth: CGFloat = 20.0 {
        didSet {
            plotView.minimumBarWidth = minimumBarWidth
        }
    }
    
    var plotInsets: UIEdgeInsets = UIEdgeInsets(top: 50, left: 80, bottom: 50, right: 50) {
        didSet {
            plotView.plotInsets = plotInsets
            plotView.setNeedsDisplay()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        
        self.axisLineWidth = 5.0
    
        self.minimumZoomScale = 0.1
        self.maximumZoomScale = 2.0
        
        
        plotView = BarPlotContentView(frame: frame);
        plotView.plotInsets = self.plotInsets
//        plotView.containerView = self
        self.addSubview(plotView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if plotWidth == 0 {
            plotView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y,
                                    width: self.bounds.size.width,
                                    height: self.bounds.size.height);
        }
        else {
            plotView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y,
                                    width: plotWidth,
                                    height: self.bounds.size.height);
        }
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.plotView
    }
//
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var top: CGFloat = 0.0
        var left: CGFloat = 0.0
        
        if self.contentSize.width < self.bounds.size.width {
            left = (self.bounds.size.width - self.contentSize.width) * 0.5
        }
        if self.contentSize.height < self.bounds.size.height {
            top = (self.bounds.size.height - self.contentSize.height) * 0.5
        }
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        plotView.didScroll()
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        plotView.didScroll()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(points: [BarDataPoint]?, xLabel: String = "x", yLabel: String = "y") {
        
        plotView.setData(points: points)
        self.setNeedsDisplay()
    }
    
    func setXAxisLabels(labels: [String]) {
        plotView.xAxisLabels = labels
    }
    
    func setYAxisLabels(labels: [String]) {
        plotView.yAxisLabels = labels
        print(labels)
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

extension String {

    
    func drawWithBasePoint(basePoint: CGPoint, angle: CGFloat, font:UIFont = UIFont.systemFont(ofSize: 20)) {

        let attributes = [
            NSAttributedString.Key.font: font
        ]
//
//        let textSize: CGSize = self.size(withAttributes: attributes)
//        let context: CGContext = UIGraphicsGetCurrentContext()!
//        let t: CGAffineTransform = CGAffineTransform(translationX: basePoint.x, y: basePoint.y)
//        let r: CGAffineTransform = CGAffineTransform(rotationAngle: angle)
//        context.concatenate(t)
//        context.concatenate(r)
//        self.draw(at: CGPoint(x: textSize.width / 2, y: -textSize.height / 2), withAttributes: attributes)
//        context.concatenate(r.inverted())
//        context.concatenate(t.inverted())
        
//        let attrs = [
//            NSAttributedString.Key.font: font
//        ]
//
        var textSize: CGSize = self.size(withAttributes: attributes)
        textSize.width += 10.0
        // sizeWithAttributes is only effective with single line NSString text
        // use boundingRectWithSize for multi line text

        let context: CGContext =   UIGraphicsGetCurrentContext()!

        let t:CGAffineTransform   =   CGAffineTransform(translationX: basePoint.x, y: basePoint.y)
        let r:CGAffineTransform   =   CGAffineTransform(rotationAngle: angle)


        context.concatenate(t)
        context.concatenate(r)
        
        var m = CGFloat(0.0)
        let a = angle.radiansToDegrees / 90.0
        m = a * textSize.height
        
        
//
//
//        self.draw(at: CGPoint(x: basePoint.x, y: basePoint.y), withAttributes: attrs)
        self.draw(at: CGPoint(x: (-1 * textSize.width / 2) + m, y: (-1 * textSize.height / 2)), withAttributes: attributes)
//
//
        context.concatenate(r.inverted())
        context.concatenate(t.inverted())


    }
    
    


}
