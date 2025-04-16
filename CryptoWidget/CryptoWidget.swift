//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Kim on 14.04.2025.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), textData: "Empty", isGrowing: true, configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), textData: "98989.89", isGrowing: true, configuration: ConfigurationAppIntent())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let response = await fetchMessageFromApi()
        
        
        let entry = SimpleEntry(
            date: Date(),
            textData: response.message, isGrowing: response.value, configuration: ConfigurationAppIntent()
        )
            
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 20, to: Date())!
        

        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
    
    func fetchMessageFromApi() async -> (message: String, value: Bool) {
        let defaults = UserDefaults.standard
        
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart")!
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "days", value: "1"),
            URLQueryItem(name: "interval", value: "daily")
        ]
        
        guard let url = components.url else {
            return ("Invalid URL", false)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("jsonString = \(jsonString)")
            }
            
            let decoded = try JSONDecoder().decode(ApiResponse.self, from: data)
            
            if let lastPrice = decoded.prices.last?.last {
                defaults.set(lastPrice, forKey: "lastPrice")
                return (message: "\(String(format: "%.2f", lastPrice))",
                        value: false)
            } else {
                return (message: "No price data", value: false)
            }
        } catch {
            
            if let lastPrice = defaults.object(forKey: "lastPrice") as? Double {
                print(lastPrice)
                return (message: "\(String(format: "%.2f", lastPrice))",
                        value: false)
            } else {
                return (message: "Error: \(error.localizedDescription)", value: false)
            }
            

        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let textData: String
    let isGrowing: Bool
    let configuration: ConfigurationAppIntent
}

struct ApiResponse: Decodable {
    let prices: [[Double]]
}

struct CryptoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Crypto track")
                .font(.system(size: 12))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text(entry.textData)
                    .font(.system(size: 20))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if entry.isGrowing {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "arrowtriangle.down.fill")
                        .foregroundColor(.red)
                }
            }
            
             Text("BTC")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Spacer()
        }
    }
}

struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CryptoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    CryptoWidget()
} timeline: {
    SimpleEntry(date: .now, textData: "84 798.98", isGrowing: false, configuration: .smiley)
    SimpleEntry(date: .now, textData: "0.0", isGrowing: false, configuration: .starEyes)
}
