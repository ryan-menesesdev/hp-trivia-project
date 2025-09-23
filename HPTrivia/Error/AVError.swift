enum AVError: Error {
    case failedToPlayMusic
    case failedToPlaySound
    
    var message: String {
        switch self {
        case .failedToPlayMusic:
            "Error found when playing music"
        case .failedToPlaySound:
            "Error found when playing sound"
        }
    }
}
