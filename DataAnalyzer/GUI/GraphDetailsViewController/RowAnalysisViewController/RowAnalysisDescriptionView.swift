//
//  RowAnalysisDescriptionView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit
import SigmaSwiftStatistics

class RowAnalysisDescriptionView: UIView {
    
    private var meanValueLabel: UILabel!
    private var stdValueLabel: UILabel!
    private var minValueLabel: UILabel!
    
    private var twoFivePercentileValueLabel: UILabel!
    private var fiveZeroPercentileValueLabel: UILabel!
    private var sevenFivePercentileValueLabel: UILabel!
    
    private var maxValueLabel: UILabel!
    
    private var kurtosisValueLabel: UILabel!
    private var skewnessValueLabel: UILabel!
    
    private var typeValueLabel: UILabel!
    
    private var swilkPLabel: UILabel!
    private var swilkWLabel: UILabel!
    private var swilkGaussianLabel: UILabel!
    
    
    func stackView(label: String) -> (UIStackView, UILabel) {
        
        let infoLabel = RowAnalysisDescriptionView.infoLabel(text: label)
        let valueLabel = RowAnalysisDescriptionView.valueLabel()
        
        let view = UIStackView(arrangedSubviews: [infoLabel, valueLabel])
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.spacing = 2.0
        
        return (view, valueLabel)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let (meanValueStackView, valueLabel) = stackView(label: NSLocalizedString("mean :", comment: ""))
        meanValueLabel = valueLabel
        
        let (stdValueStackView, valueLabel1) = stackView(label: NSLocalizedString("std :", comment: ""))
        stdValueLabel = valueLabel1
        
        let (minValueStackView, valueLabel2) = stackView(label: NSLocalizedString("min :", comment: ""))
        minValueLabel = valueLabel2

        let (twoFivePercentileValueStackView, valueLabel3) = stackView(label: NSLocalizedString("25% :", comment: ""))
        twoFivePercentileValueLabel = valueLabel3
        
        let (fiveZeroPercentileValueStackView, valueLabel4) = stackView(label: NSLocalizedString("50% :", comment: ""))
        fiveZeroPercentileValueLabel = valueLabel4

        let (sevenFivePercentileValueStackView, valueLabel5) = stackView(label: NSLocalizedString("75% :", comment: ""))
        sevenFivePercentileValueLabel = valueLabel5
        
        let (maxValueStackView, valueLabel6) = stackView(label: NSLocalizedString("max :", comment: ""))
        maxValueLabel = valueLabel6

        let (kurtosisValueStackView, valueLabel7) = stackView(label: NSLocalizedString("kurtosis :", comment: ""))
        kurtosisValueLabel = valueLabel7
        
        let (skewnessValueStackView, valueLabel8) = stackView(label: NSLocalizedString("skewness :", comment: ""))
        skewnessValueLabel = valueLabel8
        
        let (typeValueStackView, valueLabel9) = stackView(label: NSLocalizedString("Type :", comment: ""))
        typeValueLabel = valueLabel9
        
        
        let (swilkPValueStackView, valueLabel10) = stackView(label: NSLocalizedString("Swilk-p :", comment: ""))
        swilkPLabel = valueLabel10
        
        let (swilkWValueStackView, valueLabel11) = stackView(label: NSLocalizedString("Swilk-w :", comment: ""))
        swilkWLabel = valueLabel11
        
        let (swilkGValueStackView, valueLabel12) = stackView(label: NSLocalizedString("Is Gaussian Distr.:", comment: ""))
        swilkGaussianLabel = valueLabel12
        
        
        let stackView1 = UIStackView(arrangedSubviews: [typeValueStackView,
                                                        minValueStackView,
                                                        twoFivePercentileValueStackView,
                                                        fiveZeroPercentileValueStackView,
                                                        sevenFivePercentileValueStackView,
                                                        meanValueStackView,
                                                        maxValueStackView,
                                                        // range
                                                        stdValueStackView,
                                                        // IQR
                                                        kurtosisValueStackView,
                                                        skewnessValueStackView,
                                                        // Coefficient of variation (CV)
                                                        // Median Absolute Deviation (MAD)
                                                        // Sum
                                                        // Variance
                                                        // Monotonicity
                                                        
        ])
        stackView1.alignment = .leading
        stackView1.axis = .vertical
        stackView1.distribution = .equalCentering
        stackView1.spacing = 2.0
        
        
        let stackView2 = UIStackView(arrangedSubviews: [swilkPValueStackView, swilkWValueStackView, swilkGValueStackView, swilkGValueStackView])
        stackView2.alignment = .leading
        stackView2.axis = .vertical
        stackView2.distribution = .equalCentering
        stackView2.spacing = 2.0
        
        
        let stackView = UIStackView(arrangedSubviews: [stackView1, stackView2])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: [Any], type: GraphColumnDataType, p: Double, w: Double, isGaussian: Bool) {
        switch type {
            case .String:
                meanValueLabel.text                 = "-"
                stdValueLabel.text                  = "-"
                minValueLabel.text                  = "-"
                twoFivePercentileValueLabel.text    = "-"
                fiveZeroPercentileValueLabel.text   = "-"
                sevenFivePercentileValueLabel.text  = "-"
                maxValueLabel.text                  = "-"
                kurtosisValueLabel.text             = "-"
                skewnessValueLabel.text             = "-"
                typeValueLabel.text = "String"
            case .Number:
                
                let dataAsInt = data as! [Double]
                let dataAsDouble = dataAsInt.compactMap{ Double($0) }
                
                let avg = Sigma.average(dataAsDouble)
                let std = Sigma.standardDeviationSample(dataAsDouble)
                let min = Sigma.min(dataAsDouble)
                let twoFive = Sigma.percentile(dataAsDouble, percentile: 0.25)
                let fiveZero = Sigma.percentile(dataAsDouble, percentile: 0.5)
                let sevenFive = Sigma.percentile(dataAsDouble, percentile: 0.75)
                let max = Sigma.max(dataAsDouble)
                
                let skew = Sigma.skewnessB(dataAsDouble)
                let kurt = Sigma.kurtosisB(dataAsDouble)
                
                meanValueLabel.text                 = String(format: "%.4f", avg!)
                stdValueLabel.text                  = String(format: "%.4f", std!)
                minValueLabel.text                  = String(format: "%.4f", min!)
                twoFivePercentileValueLabel.text    = String(format: "%.4f", twoFive!)
                fiveZeroPercentileValueLabel.text   = String(format: "%.4f", fiveZero!)
                sevenFivePercentileValueLabel.text  = String(format: "%.4f", sevenFive!)
                maxValueLabel.text                  = String(format: "%.4f", max!)
                kurtosisValueLabel.text             = String(format: "%.4f", kurt!)
                skewnessValueLabel.text             = String(format: "%.4f", skew!)
                
                typeValueLabel.text = "Number"
                
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.scientific
//                let numberString =
                numberFormatter.positiveFormat = "0.###E+0"
                numberFormatter.exponentSymbol = "e"
                
                swilkPLabel.text = numberFormatter.string(from: NSNumber(value: p))
                swilkWLabel.text = numberFormatter.string(from: NSNumber(value: w))
                
                
                swilkGaussianLabel.text = isGaussian ? NSLocalizedString("Yes", comment: "") : NSLocalizedString("No", comment: "")
                
                break
            default:
                meanValueLabel.text                 = "-"
                stdValueLabel.text                  = "-"
                minValueLabel.text                  = "-"
                twoFivePercentileValueLabel.text    = "-"
                fiveZeroPercentileValueLabel.text   = "-"
                sevenFivePercentileValueLabel.text  = "-"
                maxValueLabel.text                  = "-"
                kurtosisValueLabel.text             = "-"
                skewnessValueLabel.text             = "-"
                typeValueLabel.text = "Unknown"
                break
        }
    }
    
    class func infoLabel(text: String) -> UILabel {
        let label = UILabel(frame: .zero)
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }
    
    class func valueLabel() -> UILabel {
        let label = UILabel(frame: .zero)
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Value"
        return label
    }
}
