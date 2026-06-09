//
//  GameRecord.swift
//  ICS3UCulminating
//
//  Created by Gemini on 2026/6/1.
//

import Foundation

// A model that represents the results of a single Pig game.
// We conform to 'Identifiable' so it can be easily displayed in SwiftUI lists.
// We conform to 'Codable' so it can be converted to JSON and saved to disk.
struct GameRecord: Identifiable, Codable {
    
    // MARK: - Stored properties
    
    // A unique identifier for this specific record.
    var id = UUID()
    
    // The date and time when the game was completed.
    let datePlayed: Date
    
    // The mode the game was played in (Human vs Human or Human vs Computer).
    // We store this as a String to make it easier to save/load.
    let gameMode: String
    
    // The name of the player who won the match.
    let winnerName: String
    
    // The final score for Player 1.
    let player1FinalScore: Int
    
    // The final score for Player 2 (either a Human or the Computer).
    let player2FinalScore: Int
    
    // MARK: - Initializer
    
    init(datePlayed: Date, gameMode: String, winnerName: String, player1FinalScore: Int, player2FinalScore: Int) {
        self.datePlayed = datePlayed
        self.gameMode = gameMode
        self.winnerName = winnerName
        self.player1FinalScore = player1FinalScore
        self.player2FinalScore = player2FinalScore
    }
}
