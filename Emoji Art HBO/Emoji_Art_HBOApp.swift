//
//  Emoji_Art_HBOApp.swift
//  Emoji Art HBO
//
//  Created by Hugues Bousselet on 04/11/2024.
//

import SwiftUI

@main
struct Emoji_Art_HBOApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)
        }
    }
}
