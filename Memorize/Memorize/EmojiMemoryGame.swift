//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by BERKAN NALBANT on 9.06.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    static let emojis = ["✈️","🚂","🚢","🚀","🚗","🚕","🚌","🚜","🚔","🛩","🛵","🚤","🚲"]
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 10) {pairIndex in
            emojis[pairIndex]
    }
    }
    @Published private var model  = createMemoryGame()
    var cards : Array<Card> {
         model.cards
    }
    func choose(_ card: Card){
        model.choose(card: card)
    }
    func shuffle(){
        model.shuffle()
    }
    func restart(){
        model = EmojiMemoryGame.createMemoryGame()
    }
   }


