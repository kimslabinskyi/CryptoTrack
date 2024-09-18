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
    case xrp //not working
    case ada //not working
    case sol
    case dot //not working
    case doge //not working
    case ltc //not working
    case busd //not working
    
    var urlForChart: String? {
        switch self {
        case .btc:
            return "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
        case .eth:
            return "https://api.coingecko.com/api/v3/coins/ethereum/market_chart"
        case .bnb:
            return "https://api.coingecko.com/api/v3/coins/binancecoin/market_chart"
        case .xrp:
            return "https://api.coingecko.com/api/v3/coins/ripple/market_chart"
        case .ada:
            return "https://api.coingecko.com/api/v3/coins/cardano/market_chart"
        case .sol:
            return "https://api.coingecko.com/api/v3/coins/solana/market_chart"
        case .dot:
            return "https://api.coingecko.com/api/v3/coins/polkadot/market_chart"
        case .doge:
            return "https://api.coingecko.com/api/v3/coins/dogecoin/market_chart"
        case .ltc:
            return "https://api.coingecko.com/api/v3/coins/litecoin/market_chart"
        case .busd:
            return "https://api.coingecko.com/api/v3/coins/binance-usd/market_chart"
        }
    }

    
    var name: String? {
           switch self {
           case .btc:
               return "Bitcoin rate"
           case .eth:
               return "Ethereum rate"
           case .bnb:
               return "Binance Coin"
           case .xrp:
               return "Ripple rate"
           case .ada:
               return "Cardano rate"
           case .sol:
               return "Solana rate"
           case .dot:
               return "Polkadot rate"
           case .doge:
               return "Dogecoin rate"
           case .ltc:
               return "Litecoin rate"
           case .busd:
               return "Binance USD rate"
           }
       }
    
    var urlForMarketCap: String? {
        switch self {
        case .btc:
            return "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_market_cap=true"
        case .eth:
            return "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd&include_market_cap=true"
        case .bnb:
            return "https://api.coingecko.com/api/v3/simple/price?ids=binancecoin&vs_currencies=usd&include_market_cap=true"
        case .xrp:
            return "https://api.coingecko.com/api/v3/simple/price?ids=ripple&vs_currencies=usd&include_market_cap=true"
        case .ada:
            return "https://api.coingecko.com/api/v3/simple/price?ids=cardano&vs_currencies=usd&include_market_cap=true"
        case .sol:
            return "https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd&include_market_cap=true"
        case .dot:
            return "https://api.coingecko.com/api/v3/simple/price?ids=polkadot&vs_currencies=usd&include_market_cap=true"
        case .doge:
            return "https://api.coingecko.com/api/v3/simple/price?ids=dogecoin&vs_currencies=usd&include_market_cap=true"
        case .ltc:
            return "https://api.coingecko.com/api/v3/simple/price?ids=litecoin&vs_currencies=usd&include_market_cap=true"
        case .busd:
            return "https://api.coingecko.com/api/v3/simple/price?ids=binance-usd&vs_currencies=usd&include_market_cap=true"
        }
    }
    
    
    
    
}
