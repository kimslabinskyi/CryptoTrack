//
//  RealmData.swift
//  CryptoTrack
//
//  Created by Kim on 27.09.2024.
//

import RealmSwift

class RealmCryptocurrencyRate: Object {
    @Persisted var name: String = ""
    @Persisted var data: Data? = nil
    @Persisted var lastUpdated: Date = Date()
    
    override static func primaryKey() -> String? {
        "name"
    }
}


class RealmCryptocurrencyMarketCap: Object {
    @Persisted var name: String = ""
    @Persisted var data: Data? = nil
    @Persisted var lastUpdated: Date = Date()
    
    override static func primaryKey() -> String? {
        "name"
    }
}
