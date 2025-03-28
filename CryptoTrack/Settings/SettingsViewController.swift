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
    
    
    static var isHapticFeedbackEnabled = UserDefaults().bool(forKey: "isHapticFeedbackEnabled")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "isHapticFeedbackEnabled") {
            hapticSwitch.isOn = true
        } else {
            hapticSwitch.isOn = false
        }
    }
    
    @IBAction func doSwitch(_ sender: UISwitch) {
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
            
            mailComposer.setToRecipients(["kim.slabinskyi@gmail.com"])
            mailComposer.setSubject("CryptoTrack")
            mailComposer.setMessageBody("Hello, I'm interested in your app.", isHTML: false)
            
            present(mailComposer, animated: true, completion: nil)
            
        } else {
            print("Cannot send mail")
        }
    }
    
}
