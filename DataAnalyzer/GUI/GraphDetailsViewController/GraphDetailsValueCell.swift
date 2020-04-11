//
//  GraphDetailsValueCell.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

class GraphDetailsValueCell: UICollectionViewCell {

    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 1.0
        
        
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                label.textColor = UIColor.black
//                self.backgroundColor = UIColor.white
            } else {
                label.textColor = UIColor.black
//                self.backgroundColor = UIColor.black
            }
        } else {
            label.textColor = UIColor.white
//            self.backgroundColor = UIColor.black
        }
        
        
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setString(string: String?) {
        label.text = string
    }
}
