//
//  CryptoWidgetLiveActivity.swift
//  CryptoWidget
//
//  Created by Kim on 14.04.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CryptoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CryptoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CryptoWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CryptoWidgetAttributes {
    fileprivate static var preview: CryptoWidgetAttributes {
        CryptoWidgetAttributes(name: "World")
    }
}

extension CryptoWidgetAttributes.ContentState {
    fileprivate static var smiley: CryptoWidgetAttributes.ContentState {
        CryptoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CryptoWidgetAttributes.ContentState {
         CryptoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CryptoWidgetAttributes.preview) {
   CryptoWidgetLiveActivity()
} contentStates: {
    CryptoWidgetAttributes.ContentState.smiley
    CryptoWidgetAttributes.ContentState.starEyes
}
