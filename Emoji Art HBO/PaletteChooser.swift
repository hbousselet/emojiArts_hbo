//
//  PaletteChooser.swift
//  Emoji Art HBO
//
//  Created by Hugues Bousselet on 20/11/2024.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }
    
    var chooser: some View {
        Button {
            withAnimation {
                store.cursorIndex += 1
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "✚−")
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle") {
                store.palettes.remove(at: store.cursorIndex)
            }
            
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map { String($0) }
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
        
    }
}
