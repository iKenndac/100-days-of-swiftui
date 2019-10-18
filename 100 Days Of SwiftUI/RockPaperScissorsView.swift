//
//  RockPaperScissorsView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-18.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct RockPaperScissorsView: View {

    enum RockPaperScissorsResult: Equatable {
        case win
        case draw
        case lose
    }

    enum RockPaperScissorsMove: Equatable, Identifiable, CaseIterable {

        case rock
        case paper
        case scissors

        func result(against opposingMove: RockPaperScissorsMove) -> RockPaperScissorsResult {
            guard opposingMove != self else { return .draw }
            switch (self, opposingMove) {
            case (.rock, .scissors): return .win // Smash!
            case (.paper, .rock): return .win // Smother!
            case (.scissors, .paper): return .win // Cut!
            default: return .lose
            }
        }

        var id: String {
            return name
        }

        var name: String {
            switch self {
            case .rock: return "Rock"
            case .paper: return "Paper"
            case .scissors: return "Scissors"
            }
        }
    }

    private let moves: [RockPaperScissorsMove] = RockPaperScissorsMove.allCases
    private let totalTurns: Int = 10

    @State private var aiChoice: RockPaperScissorsMove = .rock
    @State private var userShouldWin: Bool = false
    @State private var currentTurn: Int = 1
    @State private var score: Int = 0
    @State private var showEndOfGameAlert: Bool = false

    private func resetGame() {
        score = 0
        currentTurn = 0
        nextTurn()
    }

    private func nextTurn() {
        aiChoice = moves.randomElement()!
        userShouldWin = Bool.random()
        currentTurn += 1
    }

    private func executeChoice(_ choice: RockPaperScissorsMove) {
        let result = choice.result(against: aiChoice)
        let desiredResult: RockPaperScissorsResult = userShouldWin ? .win : .lose
        score += (result == desiredResult ? 1 : -1)

        if currentTurn >= totalTurns {
            showEndOfGameAlert = true
        } else {
            nextTurn()
        }
    }

    var body: some View {
        List {
            Section(header: Text("Turn \(currentTurn) of \(totalTurns)".uppercased())) {
                Text("The AI chose: \(aiChoice.name)")
                Text("And you must \(userShouldWin ? "win" : "lose")!")
            }
            Section(header: Text("Your Choice".uppercased())) {
                ForEach(moves) { move in
                    Button(action: { self.executeChoice(move) } , label: { Text(move.name) })
                }
            }
        }.navigationBarTitle("Rock Paper Scissors").listStyle(GroupedListStyle())
            .alert(isPresented: $showEndOfGameAlert) {
                Alert(title: Text("Game Over!"), message: Text("Your score is \(score)."),
                      dismissButton: .default(Text("OK"), action: { self.resetGame() }))
        }
    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RockPaperScissorsView()
        }
    }
}

