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
    
    @State private var errorTitle=""
    @State private var errorMessage=""
    @State private var showError=false
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
            .alert(isPresented: $showError, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("ok")))
            })
        }
    }
    func addNewWord(){
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count>0 else {
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Not Original", message: "Use completely new word")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word Not Recognized", message: "Word given, is not a word")
            return
        }
        guard isReal(word: answer) else{
            wordError(title: "Not real word", message: "You can't make up words")
            return 
        }
        usedWords.insert(answer, at: 0)
        newWord=""
    }
    func wordError(title: String,message:String){
        errorTitle=title
        errorMessage=message
        showError=true
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
    
    func isOriginal(word: String)->Bool{
        !usedWords.contains(word)
        
    }
    func isReal(word: String)->Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap:false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isPossible(word: String)->Bool{
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
            
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
