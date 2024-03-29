//
//  GuessTheFlagView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-15.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    let flagName: String

    var body: some View {
        Image(flagName).renderingMode(.original).clipShape(Capsule()).overlay(Capsule()
            .stroke(Color.black, lineWidth: 1.0)).shadow(color: .black, radius: 2.0)
    }
}

struct GuessTheFlagView: View {

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    @State private var score: Int = 0
    @State private var tappedAnswer: Int = 0

    func flagTapped(_ index: Int) {
        tappedAnswer = index
        if index == correctAnswer {
            score += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Incorrect"
        }
        showingScore = true
    }

    /// Return `true` if a guess has been made, and if the index is for the correct and tapped answer.
    func indexIsOfCurrentlyWinningAnswer(_ index: Int) -> Bool {
        return index == correctAnswer && showingScore && index == tappedAnswer
    }

    /// Return `true` if a guess has been made, and if the index is for and incorrect and tapped answer.
    func indexIsOfCurrentlyFailedAnswer(_ index: Int) -> Bool {
        return index != correctAnswer && showingScore && index == tappedAnswer
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)

            VStack(spacing: 30.0) {
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle).fontWeight(.black)
                }

                ForEach(0..<3) { index in
                    return Button(action: {
                        withAnimation(.default) { self.flagTapped(index) }
                    }, label: {
                        FlagImage(flagName: self.countries[index])
                    })
                    .opacity(self.showingScore && index != self.tappedAnswer ? 0.25 : 1.0)
                    .rotation3DEffect(.degrees(self.indexIsOfCurrentlyWinningAnswer(index) ? 360.0 : 0.0),
                                      axis: (x: 0.0, y: 1.0, z: 0.0))
                    .rotation3DEffect(.degrees(self.indexIsOfCurrentlyFailedAnswer(index) ? 90.0 : 0.0),
                                      axis: (x: 1.0, y: 0.0, z: 0.0))
                }

                Text("Your current score is \(score).").foregroundColor(.white)
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("That was the flag of \(countries[tappedAnswer])! Your score is \(score)."),
                  dismissButton: .default(Text("OK"), action: { self.askQuestion() }))
        }
    }


}

struct GuessTheFlagView_Previews: PreviewProvider {
    static var previews: some View {
        GuessTheFlagView()
    }
}

