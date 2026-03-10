//
//  ChangeCurrencyViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//

import UIKit
import MessageUI


class ChangeCurrencyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    var shouldTrimInitialElements = false
    private let CurrenciesList = ["Bitcoin",
                                 "Ethereum",
                                 "BNB",
                                 "Tether",
                                 "USD Coin",
                                 "XRP",
                                 "Cardano",
                                 "Dogecoin", 
                                 "Solana",
                                 "TRON",
                                 "Polygon",
                                 "Litecoin",
                                 "Polkadot",
                                 "Avalanche",
                                 "Shiba Inu",
                                 "Chainlink",
                                 "Uniswap",
                                 "Cosmos",
                                 "Toncoin",
                                 "Stellar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .zero



        separator.layer.cornerRadius = 2
    }
    
    
    @IBAction func dismissViewController(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }

}

extension ChangeCurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return shouldTrimInitialElements ? 3 : 0
        } else {
            return shouldTrimInitialElements ? (CurrenciesList.count - 3 ) : (CurrenciesList.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "changeCell") as! ChangeCurrencyTableViewCell
        
        if indexPath.section == 0 {
            cell.numberLabel.text = ""
            cell.currencyName.text = CurrenciesList[indexPath.row]
            cell.signImage.image = UIImage(systemName: "minus")
        } else if indexPath.section == 1 {
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.signImage.image = UIImage(systemName: "plus")
            
            if shouldTrimInitialElements == false {
                cell.currencyName.text = CurrenciesList[indexPath.row]
            } else {
                let display = Array(CurrenciesList.dropFirst(3))
                cell.currencyName.text = display[indexPath.row]
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(UIAlertController.apiMessage(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let hasRows = (section == 0) ? shouldTrimInitialElements : true
        return hasRows ? 0.01 : .leastNormalMagnitude
    }
    
    
    
   

    
}
