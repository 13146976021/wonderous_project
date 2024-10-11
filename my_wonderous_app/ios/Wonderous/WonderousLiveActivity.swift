//
//  WonderousLiveActivity.swift
//  Wonderous
//
//  Created by Morgan on 28.7.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WonderousAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WonderousLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WonderousAttributes.self) { context in
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

extension WonderousAttributes {
    fileprivate static var preview: WonderousAttributes {
        WonderousAttributes(name: "World")
    }
}

extension WonderousAttributes.ContentState {
    fileprivate static var smiley: WonderousAttributes.ContentState {
        WonderousAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WonderousAttributes.ContentState {
         WonderousAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WonderousAttributes.preview) {
   WonderousLiveActivity()
} contentStates: {
    WonderousAttributes.ContentState.smiley
    WonderousAttributes.ContentState.starEyes
}
