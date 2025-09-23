import Foundation

@Observable
class FetchBookQuestions {
    var books = [Book]()
    
    let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "bookStatuses")
    
    init() {
        do {
            try loadStatus()
        } catch let error as FetchError {
            print(error.message)
            books = []
        } catch {
            print("Unexpected error: \(error)")
            books = []
        }
    }
    
    private func decodeQuestions() throws -> [Question] {
        var decodedQuestions = [Question]()
        do {
            guard let url = Bundle.main.url(forResource: "trivia", withExtension: "json") else {
                throw FetchError.badUrlError
            }

            let questionData = try Data(contentsOf: url)
            decodedQuestions = try JSONDecoder().decode([Question].self, from: questionData)
            
        } catch FetchError.badUrlError {
            print(FetchError.badUrlError.message)
            throw FetchError.badUrlError
        } catch is DecodingError {
            print(FetchError.decodingError.message)
            throw FetchError.decodingError
        } catch {
            print("Unexpected error: \(error)")
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
    
    func saveStatus() throws {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath) //validar depois se há alguma forma de jogar um erro específico
        } catch is EncodingError {
            print(FetchError.encodingError.message)
            throw FetchError.encodingError
        } catch {
            print(DataError.failedToWriteDataError)
            throw DataError.failedToWriteDataError
        }
    }
    
    func loadStatus() throws {
        do {
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([Book].self, from: data)
        } catch {
            do {
                let decodedQuestions = try decodeQuestions()
                let organizedQuestions = organizeQuestions(decodedQuestions)
                populateBooks(with: organizedQuestions)
            } catch let fetchError as FetchError {
                print(fetchError.message)
                throw fetchError
            }
        }
    }
}
