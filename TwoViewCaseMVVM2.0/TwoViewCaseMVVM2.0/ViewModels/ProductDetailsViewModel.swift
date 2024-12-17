import Foundation

class ProductDetailsViewModel {
    var productDetail: ProductDetailResult? = nil
    
    func fetchProductDetails(productId: Int, completion: @escaping (Error?) -> Void) {
        NetworkManager.shared.fetchProductDetails(productId: productId) { [weak self] detail, error in
            DispatchQueue.main.async {
                if let detail = detail {
                    self?.productDetail = detail
                }
                completion(error)
            }
        }
    }
}
