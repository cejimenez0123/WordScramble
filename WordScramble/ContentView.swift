//
//  ContentView.swift
//  WordScramble
//
//  Created by /fam on 1/10/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords=[String]()
    @State private var rootWord=""
    @State private var newWord=""
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter your word",text:$newWord,onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding(20.0)
                List(usedWords,id: \.self){
                    Image(systemName: "\($0.count).circle")
                    Text($0.uppercased())
                       
                }
            }.navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
        }
    }
    func addNewWord(){
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count>0 else {
            return
        }
        usedWords.insert(answer, at: 0)
        newWord=""
    }
    func startGame(){
        if let startWordsURL=Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try?
                String(contentsOf: startWordsURL){
                
                let allWords = startWords.components(separatedBy: "\n")
                    rootWord=allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("couldNotLoad start.txt")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
