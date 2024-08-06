//
//  NetworkManager.swift
//  Money Manager
//
//  Created by Kim on 05.08.2024.
//

import Foundation
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    
    func getCryptocurrencyRate(_ cryptocurrency: Cryptocurrency, _ completion: @escaping (CryptocurrencyRate?, Error?) -> ()) {
        
        var url: String = ""
        if cryptocurrency == Cryptocurrency.btc {
            url = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
        } else if cryptocurrency == Cryptocurrency.eth{
            url = "https://api.coingecko.com/api/v3/coins/ethereum/market_chart"
        }
        
        let parameters: Parameters = [
            "vs_currency": "usd",
            "days": "30!",
            "interval": "daily"
        ]
        
        AF.request(url, parameters: parameters).responseData { response in
            switch response.result{
            case .success(let data):
                          do {
                              let marketChartData = try JSONDecoder().decode(CryptocurrencyRate.self, from: data)
                              completion(marketChartData, nil)

                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
            
        }
        
    }
    
    
    
    
}


struct CryptocurrencyRate: Codable {
    let prices: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices
    }
}

enum Cryptocurrency {
    case btc
    case eth
    case bnb
    case xrp
    case ada
    case sol
    case dot
    case doge
    case ltc
    case busd
}
