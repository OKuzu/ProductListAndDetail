import Foundation

// MARK: - ProductListResult
struct ProductListResult: Codable {
    let Success: Bool?
    let Message: String?
    let Result: ProductResult?
    let Exception: String?
    let IsOriginFromCheckout: Bool?
}

// MARK: - Result
struct ProductResult: Codable {
    let ProductList: [ProductList]?
}

// MARK: - ProductList
struct ProductList: Codable {
    let ProductId: Int?
    let DisplayName: String?
    let ImageUrl: String?
    let ImageUrls: [String]?
}
