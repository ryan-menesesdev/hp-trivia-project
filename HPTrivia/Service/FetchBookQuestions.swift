import Foundation

@Observable
class FetchBookQuestions {
    var books = [Book]()
    
    init() {
        let decodedQuestions = decodeQuestions()
        let organizedQuestions = organizeQuestions(decodedQuestions)
        populateBooks(with: organizedQuestions)
    }
    
    private func decodeQuestions() -> [Question] {
        var decodedQuestions = [Question]()
        
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let questionData = try Data(contentsOf: url)
                decodedQuestions = try JSONDecoder().decode([Question].self, from: questionData)
            } catch {
                print("Error during JSON decoding")
            }
        }
        return decodedQuestions
    }
    
    private func organizeQuestions(_ questions: [Question]) -> [[Question]] {
        var organizedQuestions: [[Question]] = [[], [], [], [], [], [], [], []]
        
        for question in questions {
            organizedQuestions[question.book].append(question)
        }
        
        return organizedQuestions
    }
    
    private func populateBooks(with questions:[[Question]]) {
        books.append(Book(id: 1, image: "hp1", questions: questions[1], status: .active))
        books.append(Book(id: 2, image: "hp2", questions: questions[2], status: .active))
        books.append(Book(id: 3, image: "hp3", questions: questions[3], status: .inactive))
        books.append(Book(id: 4, image: "hp4", questions: questions[4], status: .locked))
        books.append(Book(id: 5, image: "hp5", questions: questions[5], status: .locked))
        books.append(Book(id: 6, image: "hp6", questions: questions[6], status: .locked))
        books.append(Book(id: 7, image: "hp7", questions: questions[7], status: .locked))
    }
    
    func changeBookStatus(of id: Int, to newStatus: BookStatus) {
        books[id-1].status = newStatus
    }
}
