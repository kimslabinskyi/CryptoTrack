//
//  AlertManager.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//
import UIKit

class AlertManager {
    
    static func showCustomAlert( on viewController: UIViewController, delegate: CustomAlertDelegate?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let customAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertView") as? CustomAlertViewController {
            customAlert.delegate = delegate
            customAlert.modalPresentationStyle = .overCurrentContext
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalTransitionStyle = .crossDissolve
            
            viewController.present(customAlert, animated: true, completion: nil)
        }
    }
}
