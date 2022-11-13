//
//  MemorizeGame.swift
//  Memorize
//
//  Created by BERKAN NALBANT on 9.06.2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array <Card>
    private var indexOfTheOneAndOnlyFaceUpCard : Int?{
    get {cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
    set {cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}}
    }
    mutating func shuffle(){
        cards.shuffle()
    }
    
    mutating func choose ( card: Card){
        if let choosenIndex = cards.firstIndex(where: { $0.id == card.id}), !cards[choosenIndex].isFaceUp, !cards[choosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                if cards[choosenIndex].content == cards[potentialMatchIndex].content {
                    cards[choosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[choosenIndex].isFaceUp = true
              }else {}
                indexOfTheOneAndOnlyFaceUpCard = choosenIndex
            }
        }
    init(numberOfPairsOfCards: Int , createCardContent: (Int) ->CardContent){
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content : CardContent = createCardContent(pairIndex)
            cards.append(Card( id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
        cards.shuffle()
    }
    struct Card: Identifiable {
        var id : Int
        var isFaceUp = false{
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false{
            didSet{
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        
        
        
        
        
        var bonusTimeLimit : TimeInterval = 6

        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
        var bonusTimeRemaining : TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime,lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly : Element? {
        if count == 1{
            return first
        }else {
            return nil
        }
    }
}

