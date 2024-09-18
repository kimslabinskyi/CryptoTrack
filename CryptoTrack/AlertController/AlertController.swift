//
//  AlertController.swift
//  CryptoTrack
//
//  Created by Kim on 11.09.2024.
//

import UIKit


class AlertController{
    
    func showAlert(title: String, message: String, on viewController: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
}
