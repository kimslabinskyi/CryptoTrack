//
//  Cryptocurrency.swift
//  Money Manager
//
//  Created by Kim on 18.08.2024.
//

import Foundation

enum CryptoCurrencyType {
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
    
    var url: String? {
        switch self {
        case .btc:
            return "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
        case .eth:
            return "https://api.coingecko.com/api/v3/coins/ethereum/market_chart"
        default:
             return nil
        }
    }
    
    var name: String? {
        switch self {
        case .btc:
            return "Bitcoin rate"
        case .eth: 
            return "Ethereum rate"
        default:
            return nil
        }
    }
}
