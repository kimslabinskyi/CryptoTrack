//
//  NetworkManager.swift
//  Money Manager
//
//  Created by Kim on 05.08.2024.
//

import Foundation
import Alamofire
import RealmSwift

struct CryptocurrencyRate: Codable {
    let prices: [[Double]]
    
    enum CodingKeys: String, CodingKey {
        case prices
    }
}

struct CryptocurrencyMarketCapResponse: Codable {
    let bitcoin: CryptocurrencyMarketCap?
    let ethereum: CryptocurrencyMarketCap?
    let binancecoin: CryptocurrencyMarketCap?
}

struct CryptocurrencyMarketCap: Codable {
    let usd: Double
    let usdMarketCap: Double
    
    enum CodingKeys: String, CodingKey {
        case usd
        case usdMarketCap = "usd_market_cap"
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    
    
    func getCryptocurrencyRate(_ cryptocurrency: CryptoCurrencyType, _ completion: @escaping (String?, CryptocurrencyRate?, Error?) -> ()) {
        let realm = try! Realm()
        
        if let cachedRate = realm.object(ofType: RealmCryptocurrencyRate.self, forPrimaryKey: cryptocurrency.name) {
            if abs(cachedRate.lastUpdated.timeIntervalSinceNow) < 100 {
                if let data = cachedRate.data {
                    do {
                        let rate = try JSONDecoder().decode(CryptocurrencyRate.self, from: data)
                        print("Success: ChartData data loaded from realm")
                        completion(cachedRate.name, rate, nil)
                        return
                    } catch {
                        completion(nil, nil, error)
                        return
                    }
                }
            }
        }
        
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
        
        AF.request(url, parameters: parameters).responseData { response in
            switch response.result{
            case .success(let data):
                print("JSON: \(response.result)")
                do {
                    let marketChartData = try JSONDecoder().decode(CryptocurrencyRate.self, from: data)
                    completion(name, marketChartData, nil)
                    print(response)
                    
                    let realmRate = RealmCryptocurrencyRate()
                    realmRate.name = cryptocurrency.name ?? ""
                    realmRate.data = data
                    realmRate.lastUpdated = Date()
                    
                    try! realm.write {
                        realm.add(realmRate, update: .modified)
                    }
                    
                } catch {
                    completion(nil, nil, error)
                }
            case .failure(let error):
                completion(nil, nil, error)
            }
        }
    }
    
    func getMarketCap(_ cryptocurrency: CryptoCurrencyType, _ completion: @escaping (CryptocurrencyMarketCap?, Error?) -> ()){
        let realm = try! Realm()
        
        if let cachedMarketCap = realm.object(ofType: RealmCryptocurrencyMarketCap.self, forPrimaryKey: cryptocurrency.name) {
              if abs(cachedMarketCap.lastUpdated.timeIntervalSinceNow) < 100 {
                  if let data = cachedMarketCap.data {
                      do {
                          let marketCapResponse = try JSONDecoder().decode(CryptocurrencyMarketCapResponse.self, from: data)
                          
                          let marketCap: CryptocurrencyMarketCap?
                          switch cryptocurrency{
                          case .btc:
                              marketCap = marketCapResponse.bitcoin
                          case .eth:
                              marketCap = marketCapResponse.ethereum
                          case .bnb:
                              marketCap = marketCapResponse.binancecoin
                            default:
                              marketCap = nil
                          }
                          if let marketCap = marketCap {
                              print("Success: MarketCap data loaded from realm")
                              completion(marketCap, nil)
                              return
                          } else {
                              completion(nil, NSError(domain: "", code: 401, userInfo: nil))
                              return
                          }
                                                
                      } catch {
                          completion(nil, error)
                          return
                      }
                  }
              }
          }
        
        guard let url = cryptocurrency.urlForMarketCap else {
            fatalError()
        }
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let marketCapDataResponse = try JSONDecoder().decode(CryptocurrencyMarketCapResponse.self, from: data)
                    
                    var marketCapData: CryptocurrencyMarketCap?
                    switch cryptocurrency {
                    case .btc:
                        marketCapData = marketCapDataResponse.bitcoin
                    case .eth:
                        marketCapData = marketCapDataResponse.ethereum
                    case .bnb:
                        marketCapData = marketCapDataResponse.binancecoin
                    default:
                        marketCapData = nil
                    }
                    
                    if let marketCapData = marketCapData {
                        completion(marketCapData, nil)
                        
                        let realmMarketCap = RealmCryptocurrencyMarketCap()
                        realmMarketCap.name = cryptocurrency.name ?? ""
                        realmMarketCap.data = data
                        realmMarketCap.lastUpdated = Date()
                        
                        try! realm.write {
                            realm.add(realmMarketCap, update: .modified)
                        }
                    } else {
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not found"]))
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
