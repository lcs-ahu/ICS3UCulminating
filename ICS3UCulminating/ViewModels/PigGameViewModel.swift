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
    
    // MARK: - Enums
    
    // An enum to represent the different ways the game can be played.
    enum GameMode {
        case humanVsHuman
        case humanVsComputer
    }
    
    // MARK: - Stored properties
    
    // The currently selected game mode.
    // When this is changed, we automatically reset the game state.
    var selectedMode: GameMode = .humanVsHuman {
        didSet {
            // Cancel any computer turn that might be running.
            computerTurnTask?.cancel()
            
            // Start a fresh game whenever the mode changes.
            reset()
        }
    }
    
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
    
    // A Boolean to track if the computer is currently taking its turn.
    // While this is true, the user interface should disable human controls.
    var isComputerThinking: Bool = false
    
    // This stores a reference to the computer's turn task so we can cancel it
    // if the user resets the game or switches modes.
    private var computerTurnTask: Task<Void, Never>?
    
    // A reference to the history manager so we can save records when a game ends.
    var historyViewModel: GameHistoryViewModel?
    
    // MARK: - Computed properties
    
    // Returns the name of Player 2 based on the selected game mode.
    var player2Name: String {
        switch selectedMode {
        case .humanVsHuman:
            return "Player 2"
        case .humanVsComputer:
            return "Computer"
        }
    }
    
    // Returns true if any score or turn total is greater than zero, 
    // or if a roll has occurred.
    var hasGameStarted: Bool {
        return player1Score > 0 || player2Score > 0 || turnTotal > 0 || lastRoll != nil
    }
    
    // This property returns the name of the winner if someone has reached 100 points.
    // If no one has won yet, it returns "nil".
    var winner: String? {
        if player1Score >= 100 {
            return "Player 1"
        } else if player2Score >= 100 {
            return player2Name
        }
        return nil
    }
    
    // This property returns the name of the player whose turn it currently is.
    var currentPlayerName: String {
        if isPlayer1Turn {
            return "Player 1"
        } else {
            return player2Name
        }
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
            saveGameToHistory()
        } else {
            // If no one won, switch to the other player.
            endTurn()
        }
    }
    
    // This function creates a record of the finished game and saves it.
    private func saveGameToHistory() {
        // If we have a winner and a history manager is connected...
        if let winner = winner, let historyManager = historyViewModel {
            
            // Create a new record with the current game details.
            let record = GameRecord(
                datePlayed: Date(),
                gameMode: selectedMode == .humanVsHuman ? "2 Players" : "vs Computer",
                winnerName: winner,
                player1FinalScore: player1Score,
                player2FinalScore: player2Score
            )
            
            // Tell the history manager to save this record.
            historyManager.addRecord(record)
        }
    }
    
    // This function resets the game to its starting state.
    func reset() {
        // Cancel any pending computer actions.
        computerTurnTask?.cancel()
        
        player1Score = 0
        player2Score = 0
        turnTotal = 0
        isPlayer1Turn = true
        lastRoll = nil
        isGameOver = false
        isComputerThinking = false
    }
    
    // A helper function to switch turns between Player 1 and Player 2.
    // 'fileprivate' means it can only be called from within this file.
    fileprivate func endTurn() {
        // toggle() changes true to false, or false to true.
        isPlayer1Turn.toggle()
        
        // After switching turns, check if the computer should take over.
        // We only trigger the computer if:
        // 1. The game is in "Human vs Computer" mode.
        // 2. It is now the computer's turn (Player 2).
        // 3. The game isn't already over.
        if selectedMode == .humanVsComputer && !isPlayer1Turn && !isGameOver {
            // Start the computer's turn logic.
            // We store the task so we can cancel it later if needed.
            computerTurnTask = Task {
                await runComputerTurn()
            }
        }
    }
    
    // This function contains the AI logic for the computer opponent.
    // @MainActor ensures that UI updates happen on the main thread.
    @MainActor
    private func runComputerTurn() async {
        // Indicate that the computer is now "thinking" and playing.
        isComputerThinking = true
        
        // The computer continues to play as long as it's still its turn 
        // and the game hasn't ended.
        while !isPlayer1Turn && !isGameOver {
            
            // If the task has been cancelled (e.g. by a reset or mode switch), stop immediately.
            if Task.isCancelled {
                break
            }
            
            // Wait for about 1 second so the human player can see what's happening.
            // 1,000,000,000 nanoseconds = 1 second.
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Check cancellation again after the sleep.
            if Task.isCancelled {
                break
            }
            
            // Computer strategy:
            // If the turn total is less than 20, roll again.
            // If the turn total is 20 or more, hold the points.
            if turnTotal < 20 {
                roll()
            } else {
                hold()
            }
        }
        
        // Once the loop ends (either by holding or rolling a 1),
        // the computer is finished thinking.
        isComputerThinking = false
        
        // Clear the task reference since it's finished.
        computerTurnTask = nil
    }
}
