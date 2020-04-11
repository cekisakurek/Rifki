//
//  RowAnalysisTableViewCell.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 05.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class RowAnalysisTableViewCell: UITableViewCell {

    private var titleLabel: UILabel!
    
    private var rowDescriptionView: RowAnalysisDescriptionView!
    
    private var histogramPlotView: RowAnalysisHistogramView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
        
        rowDescriptionView = RowAnalysisDescriptionView(frame: .zero)
        rowDescriptionView.layer.borderColor = UIColor.black.cgColor
        rowDescriptionView.layer.borderWidth = 1.0
        rowDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(rowDescriptionView)
        
        histogramPlotView = RowAnalysisHistogramView(frame: .zero)
        histogramPlotView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(histogramPlotView)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.rowDescriptionView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            rowDescriptionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            rowDescriptionView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
//            rowDescriptionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            rowDescriptionView.widthAnchor.constraint(equalToConstant: 200.0),
//            
            histogramPlotView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            histogramPlotView.leadingAnchor.constraint(equalTo: self.rowDescriptionView.trailingAnchor),
            histogramPlotView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            histogramPlotView.widthAnchor.constraint(equalToConstant: 200.0)
            
        ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        histogramPlotView.setData(nil)
    }
    
    func setHistogramData(data: [BarDataPoint]?) {
         histogramPlotView.setData(data)
    }
    
    func setColumnData(_ data: [Any], type: GraphColumnDataType) {
        
        self.rowDescriptionView.setData(data, type: type)
        
    }
    
    
}
