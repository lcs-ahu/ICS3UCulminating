//
//  ScoreCardView.swift
//  ICS3UCulminating
//
//  Created by Gemini on 2026/6/1.
//

import SwiftUI

// DEFINITION: This is a custom subview designed to reduce repetitive code.
// It is used twice in PigGameView to display the scores for Player 1 and Player 2.
struct ScoreCardView: View {
    
    // MARK: - Stored properties
    let playerName: String
    let score: Int
    let isActive: Bool
    let activeColor: Color
    
    // MARK: - Computed properties
    var body: some View {
        VStack {
            Text(playerName)
                .font(.headline)
            Text("\(score)")
                .font(.system(size: 40, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        // Highlight the card if it's currently that player's turn
        .background(isActive ? activeColor.opacity(0.2) : Color.clear)
        .cornerRadius(10)
        // Add a subtle border to make the cards stand out
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isActive ? activeColor : Color.gray.opacity(0.2), lineWidth: 2)
        )
    }
}

#Preview {
    HStack {
        ScoreCardView(playerName: "Player 1", score: 42, isActive: true, activeColor: .blue)
        ScoreCardView(playerName: "Player 2", score: 21, isActive: false, activeColor: .red)
    }
    .padding()
}
