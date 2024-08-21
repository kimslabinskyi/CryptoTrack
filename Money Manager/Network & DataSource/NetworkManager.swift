//
//  NetworkManager.swift
//  Money Manager
//
//  Created by Kim on 05.08.2024.
//

import Foundation
import Alamofire

struct CryptocurrencyRate: Codable {
    let prices: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices
    }
}

class NetworkManager{
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getCryptocurrencyRate(_ cryptocurrency: CryptoCurrencyType, _ completion: @escaping (CryptocurrencyRate?, Error?) -> ()) {
        
        guard let url = cryptocurrency.url else {
            fatalError()
        }
        
        let parameters: Parameters = [
            "vs_currency": "usd",
            "days": "30",
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




