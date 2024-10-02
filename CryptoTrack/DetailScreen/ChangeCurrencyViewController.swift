//
//  ChangeCurrencyViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//

import UIKit

class ChangeCurrencyViewController: UIViewController, CustomAlertDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func customAlertAction() {
        // back start screen
    }

}

extension ChangeCurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "changeCell") as! ChangeCurrencyTableViewCell
        let tableViewList = ["Bitcoin",
                             "Ethereum",
                             "Tether",
                             "BNB",
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
        cell.centralLabel.text = "\(indexPath.row + 1)" + "."
        cell.currencyName.text = tableViewList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AlertManager.showCustomAlert(on: self, delegate: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
