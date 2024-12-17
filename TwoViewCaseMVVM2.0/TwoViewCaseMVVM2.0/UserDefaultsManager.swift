import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard
    private let likedProductsKey = "LikedProducts"

    private init() {}

    func toggleLike(forProductId productId: Int, userId: String) {
        var likedProducts = userDefaults.dictionary(forKey: likedProductsKey) ?? [:]
        likedProducts[String(productId)] = !(likedProducts[String(productId)] as? Bool ?? false)
        userDefaults.set(likedProducts, forKey: likedProductsKey)
    }

    func isProductLiked(productId: Int, userId: String) -> Bool {
        let likedProducts = userDefaults.dictionary(forKey: likedProductsKey) ?? [:]
        return likedProducts[String(productId)] as? Bool ?? false
    }
}
