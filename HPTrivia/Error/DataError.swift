enum DataError: Error {
    case failedToWriteDataError
    case badDataError
    
    var message: String {
        switch self {
        case .failedToWriteDataError:
            "Error found when writing data"
        case .badDataError:
            "The data is corrupt or invalid"
        }
    }
}
