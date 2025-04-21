//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Kim on 14.04.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), textData: "Empty", isGrowing: true)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), textData: "99999.99", isGrowing: true)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        Task {
            let response = await fetchMessageFromApi()
            
            let entry = SimpleEntry(
                date: Date(),
                textData: response.message,
                isGrowing: response.value
            )
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 20, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }

    
    func fetchMessageFromApi() async -> (message: String, value: Bool) {
        let defaults = UserDefaults.standard
        var isGrowing: Bool = false
        
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
            
            if let lastPrice = decoded.prices[1].last {
                defaults.set(lastPrice, forKey: "lastPrice")
                if (decoded.prices[0].last)! < lastPrice {
                    isGrowing = true
                    defaults.set(isGrowing, forKey: "isGrowing")
                }
                return (message: formatPrice(lastPrice),
                        value: isGrowing)
            } else {
                return (message: "No price data", value: false)
            }
            
        } catch {
            print("ERROR")
            if let lastPrice = defaults.object(forKey: "lastPrice") as? Double {
                return (message: formatPrice(lastPrice) + "U",
                        value: defaults.bool(forKey: "isGrowing"))
            } else {
                return (message: "Error: \(error.localizedDescription)", value: false)
            }
            
            
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
    
    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let textData: String
    let isGrowing: Bool
}

struct ApiResponse: Decodable {
    let prices: [[Double]]
}

struct CryptoWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text("Crypto track")
                    .font(.system(size: 12))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("BTC")
                        .bold()
                        .frame(alignment: .leading)
                    
                    if entry.isGrowing {
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                
                
                
                Spacer()
                
                Text(entry.textData)
                    .font(.system(size: 22))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .containerBackground(.background, for: .widget)
            
            
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Text("\(entry.textData.dropLast(3))")
                    .font(.system(size: 12))
                    .monospacedDigit()
            }
            .containerBackground(.clear, for: .widget)
            
        case .accessoryRectangular:
            ZStack {
                AccessoryWidgetBackground()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                Text("BTC: \(entry.textData)")
                    .font(.system(size: 12))
                    .monospacedDigit()
            }
            .containerBackground(.background, for: .widget)
            
        default:
            Text("\(entry.textData)")
        }
    }
}

struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
        CryptoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Crypto Daily Average")
        .description("View the daily average price of BTC right from your Home Screen.")
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular])
    }
}



#Preview(as: .systemSmall) {
    CryptoWidget()
} timeline: {
    SimpleEntry(date: .now, textData: "84 798.98", isGrowing: true)
    SimpleEntry(date: .now, textData: "0.0", isGrowing: true)
}
