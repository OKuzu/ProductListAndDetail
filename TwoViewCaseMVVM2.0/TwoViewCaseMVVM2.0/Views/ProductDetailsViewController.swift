import UIKit

class ProductDetailsViewController: UIViewController {
    let imageView = UIImageView()
    let viewModel = ProductDetailsViewModel()
    var ProductId: Int?
    var isLiked: Bool = false {
        didSet {
            updateLikeButtonState()
        }
    }
    
    init(ProductId: Int?) {
        self.ProductId = ProductId
        super.init(nibName: nil, bundle: nil)
        isLiked = UserDefaultsManager.shared.isProductLiked(productId: ProductId ?? 0, userId: "user123")
            updateLikeButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.fetchProductDetails(productId: ProductId ?? 0) { [weak self] error in
            if let error = error {
                print("Error fetching product details: \(error)")
            } else {
                self?.updateUI()
            }
        }
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem = likeButton
        self.updateLikeButtonState()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func likeButtonTapped() {
        guard let productId = ProductId else { return }
        let userId = "user123"
        UserDefaultsManager.shared.toggleLike(forProductId: productId, userId: userId)
        isLiked = UserDefaultsManager.shared.isProductLiked(productId: productId, userId: userId)
        updateLikeButtonState()
    }
    
    func updateLikeButtonState() {
        let likeImage = isLiked ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        navigationItem.rightBarButtonItem?.image = likeImage
    }
    
    func updateUI() {
        guard let productDetail = viewModel.productDetail,
              let images = productDetail.Result?.Images,
              !images.isEmpty,
              let firstImage = images[safe: 0]?.Images?[0].ImageUrl else {
            return
        }
        
        guard let imageUrl = URL(string: firstImage) else { return }
            
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(imageView)
            
            let constraints = [
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                imageView.heightAnchor.constraint(equalToConstant: 200) // Adjust height as needed
            ]
            NSLayoutConstraint.activate(constraints)
        
        let brandLabel = UILabel()
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.textAlignment = .center
        brandLabel.text = viewModel.productDetail?.Result?.BrandName
        
        let displayName = UILabel()
        displayName.translatesAutoresizingMaskIntoConstraints = false
        displayName.textAlignment = .center
        displayName.text = viewModel.productDetail?.Result?.DisplayName
        
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .center
        if let actualPriceText = viewModel.productDetail?.Result?.ActualPriceText {
            priceLabel.text = actualPriceText
        }
        
        view.addSubview(brandLabel)
        view.addSubview(displayName)
        view.addSubview(priceLabel)
        
        let brandConstraints = [
            brandLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            brandLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            brandLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(brandConstraints)
        
        let displayNameConstraints = [
            displayName.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 20),
            displayName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(displayNameConstraints)
        
        let priceConstraints = [
            priceLabel.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(priceConstraints)
        
        if let ozellikler = viewModel.productDetail?.Result?.Description?.ozellikler, !ozellikler.isEmpty {
            let ozelliklerLabel = UILabel()
            
            ozelliklerLabel.translatesAutoresizingMaskIntoConstraints = false
            ozelliklerLabel.textAlignment = .left
            ozelliklerLabel.text = "Ürün Özellikleri"
            ozelliklerLabel.textColor = .gray
            view.addSubview(ozelliklerLabel)
            
            let ozelliklerContentLabel = UILabel()
            ozelliklerContentLabel.translatesAutoresizingMaskIntoConstraints = false
            ozelliklerContentLabel.textAlignment = .left
            ozelliklerContentLabel.attributedText = ozellikler.htmlToAttributedString
            view.addSubview(ozelliklerContentLabel)
            
            let ozelliklerLabelConstraints = [
                ozelliklerLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
                ozelliklerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                ozelliklerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ]
            NSLayoutConstraint.activate(ozelliklerLabelConstraints)
            
            let ozelliklerContentLabelConstraints = [
                ozelliklerContentLabel.topAnchor.constraint(equalTo: ozelliklerLabel.bottomAnchor, constant: 8),
                ozelliklerContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                ozelliklerContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                ozelliklerContentLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
            ]
            NSLayoutConstraint.activate(ozelliklerContentLabelConstraints)
        }
            
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
    }
    
    func loadContent() {
        viewModel.fetchProductDetails(productId: ProductId ?? 0) { [weak self] error in
            if let error = error {
                print("Error fetching product details: \(error)")
            } else {
                self?.updateUI()
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
