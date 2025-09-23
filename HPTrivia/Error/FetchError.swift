enum FetchError: Error {
    case encodingError
    case decodingError
    case badUrlError
    case badPathError

    var message: String {
        switch self {
        case .encodingError:
            "There was an error during encoding data"
        case .decodingError:
            "There was an error during decoding data"
        case .badUrlError:
            "There was a problem reaching to URL providden "
        case .badPathError:
            "There was a problem at using path providden"
        }
    }
}
