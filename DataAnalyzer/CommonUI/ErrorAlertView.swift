//
//  ErrorAlertView.swift
//  DataAnalyzer
//
//  Created by Cihan Emre Kisakurek on 11.04.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import UIKit


class ErrorAlertView: UIAlertController {
    
    
    class func showError(with message: String, from: UIViewController) {
    
        let alertView = ErrorAlertView(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
        alertView.addAction(cancelAction)
    
        from.present(alertView, animated: true) {
            
        }
    
    }
    
}
