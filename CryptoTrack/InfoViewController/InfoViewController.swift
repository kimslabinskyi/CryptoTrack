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
    let list = [["What is blockchain and how does it work?",
                 "What are the advantages of using blockchain compared to traditional systems?",
                 "How does a public blockchain differ from a private one?",
                 "How is decentralization achieved in blockchain?",
                 "What problems does blockchain technology solve in the financial sector?"
                ], [
                    "What is mining and how does the process of creating new blocks work?",
                    "How does Proof of Work differ from Proof of Stake?",
                    "How does mining affect energy profitability?"
                ], [
                    "What are smart contracts and how do they work?",
                    "Which industries can use smart contracts for process automation?",
                    "How can smart contracts be used to protect against fraud?",
                    "What are the risks associated with smart contracts?",
                ],
                
                
                ["What is the difference between centralized and decentralized exchanges?",
                 "What risks are associated with cryptocurrency trading?",
                 "What are buy and sell orders, and how are they used on exchanges?",
                 "How does algorithmic trading impact cryptocurrency markets?"
                ], [
                    "How do government regulations affect cryptocurrency exchanges?",
                    "What are the legal requirements for cryptocurrency exchanges in different countries?",
                    "How do exchanges protect user's funds and data?"] ,
                
                
                ["What type of cryptocurrency wallets exist (hot and cold), and what are their differences?",
                 "How to choose a secure cryptocurrency wallet for storing your assets?",
                 "What security measures should be followed when using cryptocurrency wallets?",
                ], [
                    "What are private and public keys, and how are they used in cryptocurrency wallets?",
                    "What happens if a private key is lost, and how can it be protected?",
                    "What methods exist for recovering access to cryptocurrency wallets?"
                ], [
                    "How do multi-currency wallets differ from single-currency wallets?",
                    "What advantages do multi-currency wallets offer to users?",
                    "How to ensure security when using multi-currency wallets?"
                ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.textView.text = list[indexPath.section][indexPath.row]
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        
        let cornerRadius: CGFloat = 15.0
        let path = UIBezierPath(roundedRect: cell.bounds,
                                byRoundingCorners: [],
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        if indexPath.row == 0 {
            path.addClip()
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    
}
