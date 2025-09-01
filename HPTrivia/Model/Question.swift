struct Model: Decodable {
    var id: Int
    var question: String
    var answer: String
    var wrong: [String]
    var book: Int
    var hint: String
}
