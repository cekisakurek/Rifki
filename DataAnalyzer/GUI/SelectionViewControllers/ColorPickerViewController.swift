//
//  ColorPickerViewController.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit

protocol ColorPickerFromTableViewDelegate: class {
    
    func colorPicker(_ picker: ColorPickerViewController, didChange color: UIColor, forIndexPath: IndexPath)
}


class ColorPickerViewController: UIViewController {
    
    var fromIndexPath: IndexPath!
    
    weak var tableColorDelegate: ColorPickerFromTableViewDelegate?
    
    // MARK: - View
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Picked Color", comment: "") + " :"
        self.view.addSubview(label)
        
        let pickedColorView = UIView(frame: .zero)
        pickedColorView.translatesAutoresizingMaskIntoConstraints = false
        pickedColorView.layer.cornerRadius = 4.0
        pickedColorView.layer.borderColor = UIColor.lightGray.cgColor
        pickedColorView.layer.borderWidth = 1.0
        self.view.addSubview(pickedColorView)
        
        let colorPickerView = ColorPickerView()
        colorPickerView.elementSize = CGFloat(10.0)
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorPickerView)
        
        colorPickerView.onColorDidChange = {
            [weak self] color in
            DispatchQueue.main.async {
                
                pickedColorView.backgroundColor = color
                if let delegate = self?.tableColorDelegate,
                    let self = self {
                    delegate.colorPicker(self, didChange: color, forIndexPath: self.fromIndexPath)
                }
            }
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -30.0),
            label.bottomAnchor.constraint(equalTo: colorPickerView.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 50.0),
            label.trailingAnchor.constraint(equalTo: pickedColorView.leadingAnchor, constant: -10.0),
            
            pickedColorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            pickedColorView.widthAnchor.constraint(equalToConstant: 50.0),
            pickedColorView.bottomAnchor.constraint(equalTo: colorPickerView.topAnchor, constant: -10.0),
            
            colorPickerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            colorPickerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            colorPickerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
