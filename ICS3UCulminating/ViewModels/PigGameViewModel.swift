//
//  PigGameViewModel.swift
//  ICS3UCulminating
//
//  Created by Gemini on 2026/6/1.
//

import Foundation
import Observation

// The @Observable macro allows SwiftUI views to automatically update
// whenever a property within this class changes.
@Observable
class PigGameViewModel {
    
    // MARK: - Stored properties
    
    // These variables store the long-term score for each player.
    // They only increase when a player chooses to "Hold".
    var player1Score: Int = 0
    var player2Score: Int = 0
    
    // This variable tracks the points accumulated during the CURRENT turn.
    // If the player rolls a 1, this value is reset to 0.
    var turnTotal: Int = 0
    
    // A Boolean (true/false) to keep track of whose turn it is.
    // If true, it is Player 1's turn. If false, it is Player 2's turn.
    var isPlayer1Turn: Bool = true
    
    // An optional integer to store the result of the most recent roll.
    // It is "nil" before any roll has been made.
    var lastRoll: Int? = nil
    
    // A Boolean to track if the game has ended.
    var isGameOver: Bool = false
    
    // MARK: - Computed properties
    
    // This property returns the name of the winner if someone has reached 100 points.
    // If no one has won yet, it returns "nil".
    var winner: String? {
        if player1Score >= 100 {
            return "Player 1"
        } else if player2Score >= 100 {
            return "Player 2"
        }
        return nil
    }
    
    // MARK: - Initializer
    
    init() {
        // Properties are already initialized with default values above.
    }
    
    // MARK: - Functions
    
    // This function is called when the player taps the "Roll" button.
    func roll() {
        // If the game is over, we don't allow any more rolls.
        guard !isGameOver else { return }
        
        // Generate a random number between 1 and 6.
        let result = Int.random(in: 1...6)
        
        // Store the result so we can display the die image in the View.
        lastRoll = result
        
        // Check the "Pig" rule:
        if result == 1 {
            // If they roll a 1, they lose everything they earned this turn.
            turnTotal = 0
            
            // Their turn ends immediately.
            endTurn()
        } else {
            // If they roll 2-6, add that number to their temporary turn total.
            turnTotal += result
        }
    }
    
    // This function is called when the player taps the "Hold" button.
    func hold() {
        // If the game is over, we don't allow holding.
        guard !isGameOver else { return }
        
        // Add the points from this turn to the current player's global score.
        if isPlayer1Turn {
            player1Score += turnTotal
        } else {
            player2Score += turnTotal
        }
        
        // After banking the points, the turn total resets to 0.
        turnTotal = 0
        
        // Check if the current player just won the game.
        if player1Score >= 100 || player2Score >= 100 {
            isGameOver = true
        } else {
            // If no one won, switch to the other player.
            endTurn()
        }
    }
    
    // This function resets the game to its starting state.
    func reset() {
        player1Score = 0
        player2Score = 0
        turnTotal = 0
        isPlayer1Turn = true
        lastRoll = nil
        isGameOver = false
    }
    
    // A helper function to switch turns between Player 1 and Player 2.
    // 'fileprivate' means it can only be called from within this file.
    fileprivate func endTurn() {
        // toggle() changes true to false, or false to true.
        isPlayer1Turn.toggle()
    }
}
