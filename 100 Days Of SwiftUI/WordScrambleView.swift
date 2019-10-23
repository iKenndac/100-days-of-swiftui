//
//  WordScrambleView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-23.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct WordScrambleView: View {

    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var score: Int {
        // We can use flatMap here as well, but that's a bit obscure.
        return usedWords.joined().count
    }

    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }

        guard wordIsOriginal(answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }

        guard word(answer, isContainedIn: rootWord) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }

        guard wordIsReal(answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }

        guard wordAllowedByRules(answer, sourceWord: rootWord) else {
            wordError(title: "Word breaks rules!", message: "You can't have very short words or the source word.")
            return
        }

        usedWords.insert(answer, at: 0)
        newWord = ""
    }

    func startGame() {
        guard let wordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
            let allWords = try? String(contentsOf: wordsUrl) else { fatalError() }
        let words = allWords.components(separatedBy: .whitespacesAndNewlines)
        usedWords.removeAll()
        rootWord = words.randomElement() ?? "silkworm"
    }

    func wordIsOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func word(_ potentialWord: String, isContainedIn sourceWord: String) -> Bool {
        var pool = sourceWord
        for letter in potentialWord {
            guard let index = pool.firstIndex(of: letter) else { return false }
            pool.remove(at: index)
        }
        return true
    }

    func wordAllowedByRules(_ word: String, sourceWord: String) -> Bool {
        guard word.count >= 3 else { return false }
        guard word.lowercased() != sourceWord.lowercased() else { return false }
        return true
    }

    func wordIsReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        return checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en").location == NSNotFound
    }

    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    var body: some View {
        VStack {
            TextField("Enter your word", text: $newWord, onCommit: addNewWord).autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle()).padding()

            List(usedWords, id: \.self) {
                Image(systemName: "\($0.count).circle")
                Text($0)
            }

            Text("\(score)")

        }.navigationBarTitle(rootWord).onAppear(perform: startGame).alert(isPresented: $showingError) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }.navigationBarItems(trailing: Button(action: startGame, label: { Text("Start Again") }))
    }
}

struct WordScrambleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WordScrambleView()
        }
    }
}

