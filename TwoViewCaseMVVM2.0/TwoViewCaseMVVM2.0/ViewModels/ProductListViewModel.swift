import Foundation

public class ProductListViewModel {
    var products: [ProductList] = []
    var currentPage = 1
    
    public func fetchProducts(completion: @escaping (Error?) -> Void) {
        NetworkManager.shared.fetchProducts(page: currentPage) { [weak self] fetchedProducts, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let fetchedProducts = fetchedProducts {
                    self.products += fetchedProducts.Result?.ProductList ?? []
                    self.currentPage += 1
                }
                completion(error)
            }
        }
    }
    
    func numberOfProducts() -> Int {
        return products.count
    }
    
    func product(at index: Int) -> ProductList {
        return products[index]
    }
}
