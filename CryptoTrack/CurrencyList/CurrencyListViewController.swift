//
//  CurrencyListViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//

import UIKit

class CurrencyListViewController: UIViewController, CustomAlertDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewList = [["Bitcoin",
                         "Ethereum",
                         "BNB"], [
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
                         "Stellar"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func sideButtonTapped(_ sender: UIButton) {
        AlertManager.showCustomAlert(on: self, delegate: self)
    }
    
    func customAlertAction() {
        self.navigationController?.popViewController(animated: true)
    }
   
}

extension CurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableViewList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! CurrencyListTableViewCell
        cell.currency.text = tableViewList[indexPath.section][indexPath.row]
        cell.number.text = "\(indexPath.row + 1)" + "."
        
        if indexPath.section == 0 {
            cell.sideButton.setImage(UIImage(systemName: "minus"), for: .normal)
        } else if indexPath.section == 1 {
            cell.sideButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        
        cell.sideButton.addTarget(self, action: #selector(sideButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    
}
