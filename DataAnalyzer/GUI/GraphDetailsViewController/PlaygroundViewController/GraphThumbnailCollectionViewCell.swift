//
//  GraphThumbnailCollectionViewCell.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 29.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class GraphThumbnailCollectionViewCell: UICollectionViewCell {

    var label: UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
        let imageView = UIImageView(image: UIImage(named: "graphPlaceholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
        
        let margin = CGFloat(8.0)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -margin),
            label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setName(_ name: String?) {
        label.text = name
    }
    
}

