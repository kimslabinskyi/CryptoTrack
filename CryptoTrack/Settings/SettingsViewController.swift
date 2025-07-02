//
//  SettingsViewController.swift
//  CryptoTrack
//
//  Created by Kim on 13.10.2024.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var hapticSwitch: UISwitch!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    static var isHapticFeedbackEnabled = UserDefaults().bool(forKey: "isHapticFeedbackEnabled")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewButton.contentHorizontalAlignment = .left
        shareButton.contentHorizontalAlignment = .left
        if UserDefaults.standard.bool(forKey: "isHapticFeedbackEnabled") {
            hapticSwitch.isOn = true
        } else {
            hapticSwitch.isOn = false
        }
    }
    
    @IBAction func switchHaptics(_ sender: UISwitch) {
        if sender.isOn {
            SettingsViewController.isHapticFeedbackEnabled = true
            UserDefaults.standard.set(true, forKey: "isHapticFeedbackEnabled")
        } else {
            SettingsViewController.isHapticFeedbackEnabled = false
            UserDefaults.standard.set(false, forKey: "isHapticFeedbackEnabled")
        }
    }
    
    @IBAction func mailButton(_ sender: Any) {
        if MFMailComposeViewController.canSendMail(){
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients(["kim.sl.developer@gmail.com"])
            mailComposer.setSubject("CryptoTrack")
            mailComposer.setMessageBody("Hello, I'm interested in your app.", isHTML: false)
            
            present(mailComposer, animated: true, completion: nil)
            
        } else {
            print("Cannot send mail")
        }
    }
    
}
