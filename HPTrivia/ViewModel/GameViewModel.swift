import SwiftUI

@Observable
class GameViewModel {
    var fetcher = FetchBookQuestions()
    
    var score = 0
    var correctAnswerScore = 5
    var recentScores = [0, 0, 0]
    
    var activeQuestions = [Question]()
    var answeredQuestions = [Int]()
    var currentQuestion = try! JSONDecoder().decode([Question].self, from: Data(contentsOf: Bundle.main.url(forResource: "trivia", withExtension: "json")!))[0]
    
    var answers = [String]()
    
    let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "recentScores")
    
    init() {
        loadScores()
    }
    
    func startGame() {
        for book in fetcher.books {
            if book.status == .active {
                for question in book.questions {
                    activeQuestions.append(question)
                }
            }
        }
        
        newQuestion()
    }
    
    func newQuestion() {
        if answeredQuestions.count == activeQuestions.count {
            answeredQuestions = []
        }
        
        currentQuestion = activeQuestions.randomElement()!
        
        while(answeredQuestions.contains(currentQuestion.id)) {
            currentQuestion = activeQuestions.randomElement()!
        }
        
        answers = []
        
        answers.append(currentQuestion.answer)
        
        for answer in currentQuestion.wrong {
            answers.append(answer)
        }
        
        answers.shuffle()
        
        correctAnswerScore = 5
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        
        withAnimation {
            score += correctAnswerScore
        }
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores[0]
        recentScores[0] = score
        
        saveScores()
        
        score = 0
        activeQuestions = []
        answeredQuestions = []
    }
    
    func saveScores() {
        do {
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
    
    func loadScores() {
        do {
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            recentScores = [0, 0, 0]
        }
    }
}
