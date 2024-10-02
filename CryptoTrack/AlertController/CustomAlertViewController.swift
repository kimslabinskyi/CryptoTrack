//
//  CustomAlertViewController.swift
//  CryptoTrack
//
//  Created by Kim on 01.10.2024.
//

import UIKit

protocol CustomAlertDelegate {
    func buttonTapped()
}

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    var delegate: CustomAlertDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setUpView(){
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView(){
        alertView.alpha = 0
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 0
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.alertView.alpha = 1
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 0
            
        })
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.buttonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
  

}
