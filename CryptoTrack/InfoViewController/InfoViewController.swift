//
//  InfoViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // Blockchain, mining, smart contracts
    // Cryptocurrency trading, regulations
    // Storing Cryptocurrencies, private keys and security, milti-currency Wallets
    var selectedIndexPath: IndexPath?
    let list = [["What is cryptocurrency trading?",
                 "How cryptocurrency markets work?",
                 "Understanding market volatility"
                ], [
                    "Choose a reputable cryptocurrency exchange",
                    "Create and secure your trading account",
                    "Deposit funds to your account"
                ], [
                    "Trading pairs explained",
                    "Basic order types",
                    "Understanding the order book"
                ], [
                    "Long-term holding (HODL)",
                    "Dollar-cost averaging (DCA)",
                    "Day trading"
                ], [
                    "Set clear risk parameters",
                    "Secure your crypto assets",
                    "Manage emotional responses"
                ], [
                    "Technical analysis basics",
                    "Understanding market sentiment",
                    "Diversification strategies",
                ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func customAlertAction() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TextViewController {
            let indexPath = selectedIndexPath
            destinationVC.indexPath = indexPath
        }
        
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoTableViewCell
        cell.centralText.text = list[indexPath.section][indexPath.row]
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        
        let cornerRadius: CGFloat = 15.0
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.cornerRadius = cornerRadius
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showInfo", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        58
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionNames = ["Understanding Cryptocurrency Markets", "Getting Started with Cryptocurrency Trading", "Understanding Trading Mechanics", "Trading Strategies for Beginners", "Risk Management and Security", "Advanced Concepts"]
        return sectionNames[section]
    }
    
    
    
}
