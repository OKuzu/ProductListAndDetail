import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchProducts(page: Int, completion: @escaping (ProductListResult?, Error?) -> Void) {
        let urlString = "https://www.beymen.com/Mobile2/api/mbproduct/list?siralama=akillisiralama&sayfa=\(page)&categoryId=10020&includeDocuments=true"
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            do {
                let products = try JSONDecoder().decode(ProductListResult.self, from: data)
                completion(products, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchProductDetails(productId: Int, completion: @escaping (ProductDetailResult?, Error?) -> Void) {
        let urlString = "https://www.beymen.com/Mobile2/api/mbproduct/product?productid=\(productId)"
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            do {
                let productDetail = try JSONDecoder().decode(ProductDetailResult.self, from: data)
                completion(productDetail, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}


