//
//  EmojiArt.swift
//  Emoji Art HBO
//
//  Created by Hugues Bousselet on 04/11/2024.
//

import Foundation

struct EmojiArt {
    var background: URL? = URL(string: "https://img.freepik.com/premium-photo/cartoon-landscape-with-country-road-mountains-background_901003-12193.jpg?w=2000")
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmoji: Int = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmoji += 1
        emojis.append(Emoji(string: emoji,
                           position: position,
                           size: size,
                           id: uniqueEmoji))
    }
    
    struct Emoji: Identifiable {
        let string: String
        let position: Position
        let size: Int
        
        let id: Int
        
        struct Position {
            var x: Int
            var y: Int
        }
    }
}
