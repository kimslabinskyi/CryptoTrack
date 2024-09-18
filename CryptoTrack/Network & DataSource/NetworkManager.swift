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

struct CryptocurrencyMarketCapResponse: Codable {
    let bitcoin: CryptocurrencyMarketCap?
    let ethereum: CryptocurrencyMarketCap?
}

struct CryptocurrencyMarketCap: Codable {
    let usd: Double
    let usdMarketCap: Double
    
    enum CodingKeys: String, CodingKey {
        case usd
        case usdMarketCap = "usd_market_cap"
    }
}

class NetworkManager{
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getCryptocurrencyRate(_ cryptocurrency: CryptoCurrencyType, _ completion: @escaping (String?, CryptocurrencyRate?, Error?) -> ()) {
        
        guard let url = cryptocurrency.urlForChart else {
            fatalError()
        }
        
        guard let name = cryptocurrency.name else {
            fatalError()
        }
        
        let parameters: Parameters = [
            "vs_currency": "usd",
            "days": 364,
            "interval": "daily"
        ]
        
//        let memoryCapacity = 20 * 1024 * 1024
//        let discCapacity = 100 * 1024 * 1024
//        let cache = URLCache(memoryCapacity: memoryCapacity,
//                             diskCapacity: discCapacity)
//        
//        let configuration = URLSessionConfiguration.default
//        configuration.urlCache = cache
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
//        
//        let session = Session(configuration: configuration)
        
        AF.request(url, parameters: parameters).responseData { response in
            switch response.result{
            case .success(let data):
                do {
                    let marketChartData = try JSONDecoder().decode(CryptocurrencyRate.self, from: data)
                    completion(name, marketChartData, nil)
                    print(response)
                    
                } catch {
                    completion(nil, nil, error)
                }
            case .failure(let error):
                completion(nil, nil, error)
            }
            
        }
        
    }
    
    func getMarketCap(_ cryptocurrency: CryptoCurrencyType, _ completion: @escaping (CryptocurrencyMarketCap?, Error?) -> ()){
        
        guard let url = cryptocurrency.urlForMarketCap else {
            fatalError()
        }
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let marketCapDataResponse = try decoder.decode(CryptocurrencyMarketCapResponse.self, from: data)
                    
                    var marketCapData: CryptocurrencyMarketCap?
                    switch cryptocurrency {
                    case .btc:
                        marketCapData = marketCapDataResponse.bitcoin
                    case .eth:
                        marketCapData = marketCapDataResponse.ethereum
                    default:
                        marketCapData = nil
                    }
                    
                    if let marketCapData = marketCapData {
                        completion(marketCapData, nil)
                    } else {
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found for the specified cryptocurrency"]))
                    }
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
    
    
    
}



