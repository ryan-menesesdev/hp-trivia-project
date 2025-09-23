import SwiftUI

@Observable
class GameViewModel {
    var fetcher = FetchBookQuestions()
    
    var score = 0
    var correctAnswerScore = 5
    var recentScores = [0, 0, 0]
    
    var activeQuestions = [Question]()
    var answeredQuestions = [Int]()
    
    var currentQuestion: Question
    
    var answers = [String]()
    
    let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "recentScores")
    
    init() {
        self.currentQuestion = Question(id: 0, question: "Loading...", answer: "", wrong: [], book: 1, hint: "")
        
        do {
            try loadQuestions()
            loadScores()
        } catch {
            print(error)
        }
    }
    
    func loadQuestions() throws {
        do {
            guard let url = Bundle.main.url(forResource: "trivia", withExtension: "json") else {
                throw FetchError.badUrlError
            }
            
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([Question].self, from: data)
            
            if questions.isEmpty {
                throw ViewError.data(.badDataError)
            }
            
            currentQuestion = questions[0]
        } catch FetchError.badUrlError {
            print(FetchError.badUrlError.message)
            throw ViewError.fetch(.badUrlError)
        } catch DataError.badDataError {
            print(DataError.badDataError.message)
            throw ViewError.data(.badDataError)
        } catch is DecodingError {
            print(FetchError.decodingError.message)
            throw ViewError.fetch(.decodingError)
        } catch {
            print("Unexpected error: \(error)")
            throw ViewError.other(error)
        }
    }
    
    func startGame() {
        for book in fetcher.books {
            if book.status == .active {
                for question in book.questions {
                    activeQuestions.append(question)
                }
            }
        }
        
        if activeQuestions.isEmpty {
            print("No active questions available")
            return
        }
        
        newQuestion()
    }
    
    func newQuestion() {
        if answeredQuestions.count == activeQuestions.count {
            answeredQuestions = []
        }

        guard let randomQuestion = activeQuestions.randomElement() else {
            print("No questions available")
            return
        }
        
        currentQuestion = randomQuestion
        
        while(answeredQuestions.contains(currentQuestion.id)) {
            guard let nextQuestion = activeQuestions.randomElement() else {
                print("No more unique questions available")
                return
            }
            currentQuestion = nextQuestion
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
        
        do {
            try saveScores()
        } catch {
            print("Unexpected error: \(error)")
        }
        
        score = 0
        activeQuestions = []
        answeredQuestions = []
    }
    
    func saveScores() throws {
        do {
            let data = try JSONEncoder().encode(recentScores)
            try data.write(to: savePath)
        } catch is EncodingError {
            print(FetchError.encodingError.message)
            throw ViewError.fetch(.encodingError)
        } catch {
            print(DataError.failedToWriteDataError.message)
            throw ViewError.data(.failedToWriteDataError)
        }
    }
    
    func loadScores() {
        do {
            let data = try Data(contentsOf: savePath)
            recentScores = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            print("Failed to load scores: \(error.localizedDescription)")
            recentScores = [0, 0, 0]
        }
    }
}
