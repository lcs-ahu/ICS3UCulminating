//
//  PigGameView.swift
//  ICS3UCulminating
//
//  Created by Gemini on 2026/6/1.
//

import SwiftUI

struct PigGameView: View {
    
    // MARK: - Stored properties
    
    // We create the ViewModel here. The @State property wrapper is used
    // because the View owns this data. Because PigGameViewModel is @Observable,
    // SwiftUI will automatically watch for changes.
    @State var viewModel = PigGameViewModel()
    
    // MARK: - Computed properties
    
    // The 'body' property defines what the user sees on the screen.
    var body: some View {
        VStack(spacing: 40) {
            
            // MARK: Score Header
            // Displays the global scores for both players at the top.
            HStack {
                VStack {
                    Text("Player 1")
                        .font(.headline)
                    Text("\(viewModel.player1Score)")
                        .font(.system(size: 40, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isPlayer1Turn ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(10)
                
                VStack {
                    Text("Player 2")
                        .font(.headline)
                    Text("\(viewModel.player2Score)")
                        .font(.system(size: 40, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(!viewModel.isPlayer1Turn ? Color.red.opacity(0.2) : Color.clear)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // MARK: Game Stage
            // Shows who is currently playing and the results of their rolls.
            VStack(spacing: 20) {
                if let winner = viewModel.winner {
                    Text("🏆 \(winner) Wins! 🏆")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.green)
                } else {
                    Text(viewModel.isPlayer1Turn ? "Player 1's Turn" : "Player 2's Turn")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.isPlayer1Turn ? .blue : .red)
                }
                
                // Show the die face for the last roll
                if let roll = viewModel.lastRoll {
                    Image(systemName: "die.face.\(roll)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(roll == 1 ? .gray : .primary)
                } else {
                    // Placeholder before the first roll
                    Image(systemName: "dice")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text("Current Turn Total")
                        .font(.caption)
                        .textCase(.uppercase)
                    Text("\(viewModel.turnTotal)")
                        .font(.system(size: 60, weight: .medium))
                }
            }
            
            Spacer()
            
            // MARK: Controls
            // Buttons to Roll, Hold, or Reset the game.
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.roll()
                    }) {
                        Label("Roll", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isGameOver ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isGameOver)
                    
                    Button(action: {
                        viewModel.hold()
                    }) {
                        Label("Hold", systemImage: "tray.and.arrow.down")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isGameOver ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isGameOver)
                }
                
                Button(action: {
                    viewModel.reset()
                }) {
                    Text("Reset Game")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                .padding(.top)
            }
            .padding()
        }
        .padding(.vertical)
    }
}

#Preview {
    PigGameView()
}
