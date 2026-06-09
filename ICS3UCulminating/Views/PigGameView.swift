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
    
    // We create the history manager here as well.
    @State var historyViewModel = GameHistoryViewModel()
    
    // MARK: - Computed properties
    
    // The 'body' property defines what the user sees on the screen.
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // MARK: Game Mode Selection
                // Allows the user to choose between playing another human or the computer.
                // This is disabled once the game has started.
                Picker("Game Mode", selection: $viewModel.selectedMode) {
                    Text("2 Players").tag(PigGameViewModel.GameMode.humanVsHuman)
                    Text("vs Computer").tag(PigGameViewModel.GameMode.humanVsComputer)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .disabled(viewModel.isComputerThinking || (viewModel.hasGameStarted && !viewModel.isGameOver))
                
                // MARK: Score Header
                // Displays the global scores for both players at the top.
                // INVOCATION: We use our custom ScoreCardView here twice.
                // This reduces repetitive code for the layout and styling of the score displays.
                HStack {
                    ScoreCardView(
                        playerName: "Player 1",
                        score: viewModel.player1Score,
                        isActive: viewModel.isPlayer1Turn,
                        activeColor: .blue
                    )
                    
                    ScoreCardView(
                        playerName: viewModel.player2Name,
                        score: viewModel.player2Score,
                        isActive: !viewModel.isPlayer1Turn,
                        activeColor: .red
                    )
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
                        Text("\(viewModel.currentPlayerName)'s Turn")
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
                                .background(viewModel.isGameOver || viewModel.isComputerThinking ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isGameOver || viewModel.isComputerThinking)
                        
                        Button(action: {
                            viewModel.hold()
                        }) {
                            Label("Hold", systemImage: "tray.and.arrow.down")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isGameOver || viewModel.isComputerThinking ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isGameOver || viewModel.isComputerThinking)
                    }
                    
                    Button(action: {
                        viewModel.reset()
                    }) {
                        Text("Reset Game")
                            .fontWeight(.semibold)
                            .foregroundColor(viewModel.isComputerThinking ? .gray : .red)
                    }
                    .padding(.top)
                    .disabled(viewModel.isComputerThinking)
                }
                .padding()
            }
            .navigationTitle("Pig Game")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: PigHistoryView(historyViewModel: historyViewModel)) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .padding(.vertical)
            .onAppear {
                // When the view appears, we connect the history manager to the game.
                viewModel.historyViewModel = historyViewModel
            }
        }
    }
}

#Preview {
    PigGameView()
}
