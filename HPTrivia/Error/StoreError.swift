enum StoreError: Error {
    case failedToLoadProductsError
    case failedToPurcharseError
    
    var message: String {
        switch self {
        case .failedToLoadProductsError:
            "Error found loading products"
        case .failedToPurcharseError:
            "Error found when purchasing products"
        }
    }
}
