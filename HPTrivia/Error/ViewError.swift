import Foundation

enum ViewError: Error, Identifiable {
    case fetch(FetchError)
    case data(DataError)
    case av(AVError)
    case store(StoreError)
    case other(Error)

    var id: String { localizedDescription }

    var localizedDescription: String {
        switch self {
        case .fetch(let error):
            switch error {
            case .encodingError:
                return "Failed to process data for saving."
            case .decodingError:
                return "Failed to read saved data."
            case .badUrlError:
                return "The resource location is invalid."
            case .badPathError:
                return "The file location is invalid."
            }
        case .data(let error):
            switch error {
            case .failedToWriteDataError:
                return "Unable to save data. Please try again."
            case .badDataError:
                return "The data is invalid or corrupted."
            }
        case .av(let error):
            switch error {
            case .failedToPlayMusic:
                return "Failed to play background music."
            case .failedToPlaySound:
                return "Failed to play sound effect."
            }
        case .store(let error):
            switch error {
            case .failedToLoadProductsError:
                return "Failed to load store products. Check your internet connection."
            case .failedToPurcharseError:
                return "Your purchase couldn't be completed. Please try again."
            }
        case .other(let error):
            return error.localizedDescription
        }
    }
}
