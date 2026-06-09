//
//  PigHistoryView.swift
//  ICS3UCulminating
//
//  Created by Gemini on 2026/6/1.
//

import SwiftUI

struct PigHistoryView: View {
    
    // MARK: - Stored properties
    
    // We pass in the history ViewModel so we can display and manage the records.
    var historyViewModel: GameHistoryViewModel
    
    // MARK: - Computed properties
    
    var body: some View {
        List {
            // Check if there are any games to show.
            if historyViewModel.history.isEmpty {
                ContentUnavailableView(
                    "No Games Played",
                    systemImage: "dice",
                    description: Text("Finish a game of Pig to see your history here.")
                )
            } else {
                // Loop through each game record in the history.
                ForEach(historyViewModel.history) { record in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            // Highlight the winner.
                            Text("🏆 \(record.winnerName) Won")
                                .font(.headline)
                            
                            Spacer()
                            
                            // Show the final scoreline.
                            Text("\(record.player1FinalScore) - \(record.player2FinalScore)")
                                .font(.subheadline.monospacedDigit())
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            // Show the game mode.
                            Label(record.gameMode, systemImage: record.gameMode == "vs Computer" ? "desktopcomputer" : "person.2")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            // Show the date and time.
                            Text(record.datePlayed.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                // Allow users to delete a single game record by swiping.
                .onDelete { indexSet in
                    // We need a small loop because onDelete provides a set of indices.
                    for index in indexSet {
                        _ = historyViewModel.history[index]
                        // Remove from the array (which also saves to disk).
                        historyViewModel.history.remove(at: index)
                    }
                    // Save the updated list to disk.
                    // (Note: In a more complex app, we'd add a 'delete' method to the VM)
                }
            }
        }
        .navigationTitle("Match History")
        .toolbar {
            // Add a button to clear the entire history at once.
            if !historyViewModel.history.isEmpty {
                Button(role: .destructive) {
                    historyViewModel.clearHistory()
                } label: {
                    Label("Clear All", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    // Provide a dummy ViewModel with some example data for the preview.
    let mockVM = GameHistoryViewModel()
    mockVM.history = [
        GameRecord(datePlayed: Date(), gameMode: "vs Computer", winnerName: "Player 1", player1FinalScore: 100, player2FinalScore: 84),
        GameRecord(datePlayed: Date().addingTimeInterval(-3600), gameMode: "2 Players", winnerName: "Player 2", player1FinalScore: 92, player2FinalScore: 100)
    ]
    return NavigationStack {
        PigHistoryView(historyViewModel: mockVM)
    }
}
