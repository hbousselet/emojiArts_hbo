//
//  EmojiArtDocumentView.swift
//  Emoji Art HBO
//
//  Created by Hugues Bousselet on 04/11/2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    @ObservedObject var document: EmojiArtDocument

    private let paletteFontSize: CGFloat = 40
    private let paletteEmojiSize: CGFloat = 30
    var body: some View {
        VStack(spacing: 0){
            documentBody
            PaletteChooser()
                .font(.system(size: paletteFontSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
        
    }
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                gestureZoom = inMotionPinchScale
            }
//            .onEnded { endingPinches in
//                zoom *= endingPinches}
//            .onChanged { endingPinches in
//                zoom *= endingPinches}
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                pan += value.translation
            }
            .updating($gesturePan) { value, gesturePan, _ in
                gesturePan = value.translation
            }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContent(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas,at: location, geometry: geometry)
            }
        }
    }
    
    @ViewBuilder
    private func documentContent(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position(x:0, y:0).in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }
    
    private func drop(_ sturldatas: [Sturldata],at location: CGPoint, geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(emoji,
                                  at: emojiPosition(at: location, in: geometry),
                                  size: paletteEmojiSize / zoom)
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(x: Int((location.x - center.x - pan.width) / zoom),
                              y: Int(-((location.y - center.y - pan.height) / zoom)))
    }
}
