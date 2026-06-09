//
//  GameHistoryViewModel.swift
//  ICS3UCulminating
//
//  Created by Gemini on 2026/6/1.
//

import Foundation
import Observation

// This ViewModel is responsible for managing the collection of previous game results.
// it handles saving the data to the device's storage so it persists between app launches.
@Observable
class GameHistoryViewModel {
    
    // MARK: - Stored properties
    
    // The list of all games played.
    var history: [GameRecord] = []
    
    // The URL where the history file is stored on the device.
    private let savePath: URL
    
    // MARK: - Initializer
    
    init() {
        // Find the "Documents" directory for this app.
        // This is a safe place to store user data permanently.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        self.savePath = paths[0].appendingPathComponent("PigGameHistory.json")
        
        // Load any existing history when the ViewModel is created.
        load()
    }
    
    // MARK: - Functions
    
    // Adds a new game result to the history and saves it immediately.
    func addRecord(_ record: GameRecord) {
        // Insert at the beginning of the array so the newest games appear first.
        history.insert(record, at: 0)
        save()
    }
    
    // Converts the history array into a JSON file and writes it to disk.
    private func save() {
        do {
            let encoder = JSONEncoder()
            // Make the JSON pretty and easy to read if someone opens the file.
            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(history)
            
            // Write the data to the document directory.
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Successfully saved game history to: \(savePath.lastPathComponent)")
        } catch {
            print("Failed to save game history: \(error.localizedDescription)")
        }
    }
    
    // Reads the JSON file from disk and converts it back into an array of GameRecords.
    private func load() {
        // Check if the file actually exists before trying to read it.
        guard FileManager.default.fileExists(atPath: savePath.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: savePath)
            let decoder = JSONDecoder()
            
            // Convert the JSON data back into our Swift objects.
            history = try decoder.decode([GameRecord].self, from: data)
            print("Successfully loaded \(history.count) game records.")
        } catch {
            print("Failed to load game history: \(error.localizedDescription)")
        }
    }
    
    // Clears all history (useful for a "Clear History" button later).
    func clearHistory() {
        history.removeAll()
        save()
    }
}
