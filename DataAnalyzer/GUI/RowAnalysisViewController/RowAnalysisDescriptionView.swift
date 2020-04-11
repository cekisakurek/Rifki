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
    
    private var meanInfoLabel: UILabel!
    private var stdInfoLabel: UILabel!
    private var minInfoLabel: UILabel!
    
    private var twoFivePercentileInfoLabel: UILabel!
    private var fiveZeroPercentileInfoLabel: UILabel!
    private var sevenFivePercentileInfoLabel: UILabel!
    
    private var maxInfoLabel: UILabel!
    
    private var kurtosisInfoLabel: UILabel!
    private var skewnessInfoLabel: UILabel!
    
    private var typeInfoLabel: UILabel!
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        meanInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "mean :")
        self.addSubview(meanInfoLabel)
        meanValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(meanValueLabel)
        
        stdInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "std :")
        self.addSubview(stdInfoLabel)
        stdValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(stdValueLabel)

        minInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "min :")
        self.addSubview(minInfoLabel)
        minValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(minValueLabel)

        twoFivePercentileInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "25% :")
        self.addSubview(twoFivePercentileInfoLabel)
        twoFivePercentileValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(twoFivePercentileValueLabel)

        fiveZeroPercentileInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "50% :")
        self.addSubview(fiveZeroPercentileInfoLabel)
        fiveZeroPercentileValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(fiveZeroPercentileValueLabel)

        sevenFivePercentileInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "75% :")
        self.addSubview(sevenFivePercentileInfoLabel)
        sevenFivePercentileValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(sevenFivePercentileValueLabel)

        maxInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "max :")
        self.addSubview(maxInfoLabel)
        maxValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(maxValueLabel)
        
        
        kurtosisInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "kurtosis :")
        self.addSubview(kurtosisInfoLabel)
        kurtosisValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(kurtosisValueLabel)
        
        skewnessInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "skewness :")
        self.addSubview(skewnessInfoLabel)
        skewnessValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(skewnessValueLabel)
        

        typeInfoLabel = RowAnalysisDescriptionView.infoLabel(text: "type :")
        self.addSubview(typeInfoLabel)
        typeValueLabel = RowAnalysisDescriptionView.valueLabel()
        self.addSubview(typeValueLabel)
        
        NSLayoutConstraint.activate([
            
            meanInfoLabel.topAnchor.constraint(equalTo: self.topAnchor),
            meanInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            meanInfoLabel.bottomAnchor.constraint(equalTo: self.stdInfoLabel.topAnchor),
            meanInfoLabel.trailingAnchor.constraint(equalTo: self.meanValueLabel.leadingAnchor),
            
            stdInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stdInfoLabel.bottomAnchor.constraint(equalTo: self.minInfoLabel.topAnchor),
            stdInfoLabel.trailingAnchor.constraint(equalTo: self.stdValueLabel.leadingAnchor),

            minInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            minInfoLabel.bottomAnchor.constraint(equalTo: self.twoFivePercentileInfoLabel.topAnchor),
            minInfoLabel.trailingAnchor.constraint(equalTo: self.minValueLabel.leadingAnchor),

            twoFivePercentileInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            twoFivePercentileInfoLabel.bottomAnchor.constraint(equalTo: self.fiveZeroPercentileInfoLabel.topAnchor),
            twoFivePercentileInfoLabel.trailingAnchor.constraint(equalTo: self.twoFivePercentileValueLabel.leadingAnchor),

            fiveZeroPercentileInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            fiveZeroPercentileInfoLabel.bottomAnchor.constraint(equalTo: self.sevenFivePercentileInfoLabel.topAnchor),
            fiveZeroPercentileInfoLabel.trailingAnchor.constraint(equalTo: self.fiveZeroPercentileValueLabel.leadingAnchor),

            sevenFivePercentileInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sevenFivePercentileInfoLabel.bottomAnchor.constraint(equalTo: self.maxInfoLabel.topAnchor),
            sevenFivePercentileInfoLabel.trailingAnchor.constraint(equalTo: self.sevenFivePercentileValueLabel.leadingAnchor),

            maxInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            maxInfoLabel.bottomAnchor.constraint(equalTo: self.skewnessInfoLabel.topAnchor),
            maxInfoLabel.trailingAnchor.constraint(equalTo: self.maxValueLabel.leadingAnchor),

            skewnessInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            skewnessInfoLabel.bottomAnchor.constraint(equalTo: self.kurtosisInfoLabel.topAnchor),
            skewnessInfoLabel.trailingAnchor.constraint(equalTo: self.skewnessValueLabel.leadingAnchor),
            
            kurtosisInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            kurtosisInfoLabel.bottomAnchor.constraint(equalTo: self.typeInfoLabel.topAnchor),
            kurtosisInfoLabel.trailingAnchor.constraint(equalTo: self.kurtosisValueLabel.leadingAnchor),
            
            typeInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            typeInfoLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            typeInfoLabel.trailingAnchor.constraint(equalTo: self.typeValueLabel.leadingAnchor),
            
            
            meanValueLabel.topAnchor.constraint(equalTo: meanInfoLabel.topAnchor),
            meanValueLabel.bottomAnchor.constraint(equalTo: meanInfoLabel.bottomAnchor),
            meanValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            stdValueLabel.topAnchor.constraint(equalTo: stdInfoLabel.topAnchor),
            stdValueLabel.bottomAnchor.constraint(equalTo: stdInfoLabel.bottomAnchor),
            stdValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            minValueLabel.topAnchor.constraint(equalTo: minInfoLabel.topAnchor),
            minValueLabel.bottomAnchor.constraint(equalTo: minInfoLabel.bottomAnchor),
            minValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            twoFivePercentileValueLabel.topAnchor.constraint(equalTo: twoFivePercentileInfoLabel.topAnchor),
            twoFivePercentileValueLabel.bottomAnchor.constraint(equalTo: twoFivePercentileInfoLabel.bottomAnchor),
            twoFivePercentileValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            fiveZeroPercentileValueLabel.topAnchor.constraint(equalTo: fiveZeroPercentileInfoLabel.topAnchor),
            fiveZeroPercentileValueLabel.bottomAnchor.constraint(equalTo: fiveZeroPercentileInfoLabel.bottomAnchor),
            fiveZeroPercentileValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            sevenFivePercentileValueLabel.topAnchor.constraint(equalTo: sevenFivePercentileInfoLabel.topAnchor),
            sevenFivePercentileValueLabel.bottomAnchor.constraint(equalTo: sevenFivePercentileInfoLabel.bottomAnchor),
            sevenFivePercentileValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            maxValueLabel.topAnchor.constraint(equalTo: maxInfoLabel.topAnchor),
            maxValueLabel.bottomAnchor.constraint(equalTo: maxInfoLabel.bottomAnchor),
            maxValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            skewnessValueLabel.topAnchor.constraint(equalTo: skewnessInfoLabel.topAnchor),
            skewnessValueLabel.bottomAnchor.constraint(equalTo: skewnessInfoLabel.bottomAnchor),
            skewnessValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            kurtosisValueLabel.topAnchor.constraint(equalTo: kurtosisInfoLabel.topAnchor),
            kurtosisValueLabel.bottomAnchor.constraint(equalTo: kurtosisInfoLabel.bottomAnchor),
            kurtosisValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            typeValueLabel.topAnchor.constraint(equalTo: typeInfoLabel.topAnchor),
            typeValueLabel.bottomAnchor.constraint(equalTo: typeInfoLabel.bottomAnchor),
            typeValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(_ data: [Any], type: GraphColumnDataType) {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = UIColor.black
//        label.textAlignment = .left
        return label
    }
    
    class func valueLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .right
        label.textColor = UIColor.black
        label.text = "Value"
        return label
    }
}
