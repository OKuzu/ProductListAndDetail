import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var tableView = UITableView()
    var collectionView: UICollectionView!
    let viewModel = ProductListViewModel()
    let nextButton = UIButton()
    let scrollView = UIScrollView()
    let toggleButton = UIButton()
    let spacing: CGFloat = 10.0
    var isTwoColumns = false
    var productID: Int = 0
    var favoritedProductIDs: Set<Int> = []
    var isLoadingContent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.delegate = self
        self.tableView.register(MainCustomListCell.self, forCellReuseIdentifier: "cell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width/2 - 20, height: 200)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(MainCustomGridCell.self, forCellWithReuseIdentifier: "grid-cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpView()
        loadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateLayout()
    }
    
    func loadContent(completion: (() -> Void)? = nil) {
        viewModel.fetchProducts { error in
            DispatchQueue.main.async {
                if error == nil {
                    if self.isTwoColumns {
                        self.collectionView.reloadData()
                    } else {
                        self.tableView.reloadData()
                    }
                }
                completion?()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCustomGridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "grid-cell", for: indexPath) as! MainCustomGridCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainCustomListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainCustomListCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func configureCell(_ cell: UIView, indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        let imageUrl = URL(string: product.ImageUrl ?? "")!

        if let gridCell = cell as? MainCustomGridCell {
            gridCell.nameLabel.text = product.DisplayName
            gridCell.starButton.setImage(UIImage(systemName: favoritedProductIDs.contains(product.ProductId ?? 0) ? "star.fill" : "star"), for: .normal)
            gridCell.starButton.tag = indexPath.row
            gridCell.starButton.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
            addTapGesture(to: gridCell, tag: indexPath.row)
            
            // Fetch Image
            fetchImage(url: imageUrl) { image in gridCell.image.image = image }
        }
        
        if let listCell = cell as? MainCustomListCell {
            listCell.nameLabel.text = product.DisplayName
            listCell.starButton.setImage(UIImage(systemName: favoritedProductIDs.contains(product.ProductId ?? 0) ? "star.fill" : "star"), for: .normal)
            listCell.starButton.tag = indexPath.row
            listCell.starButton.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
            addTapGesture(to: listCell, tag: indexPath.row)
            
            // Fetch Image
            fetchImage(url: imageUrl) { image in listCell.image.image = image }
        }
    }
    
    func addTapGesture(to view: UIView, tag: Int) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        view.tag = tag
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
    @objc func starButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let product = viewModel.products[index]
        
        if let prodID = product.ProductId {
            let isLiked = UserDefaultsManager.shared.isProductLiked(productId: prodID, userId: "user123")
            if isLiked {
                favoritedProductIDs.remove(prodID)
            } else {
                favoritedProductIDs.insert(prodID)
            }
            UserDefaultsManager.shared.toggleLike(forProductId: prodID, userId: "user123")
            sender.setImage(UIImage(systemName: favoritedProductIDs.contains(prodID) ? "star.fill" : "star"), for: .normal)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let cellView = sender.view else { return }
        let index = cellView.tag
        let product = viewModel.products[index]
        let detailsViewController = ProductDetailsViewController(ProductId: product.ProductId)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension MainViewController {
    func setUpView() {
        let topBar = UIView()
        topBar.backgroundColor = .white
        let titleLabel = UILabel()
        titleLabel.text = "Contents"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        toggleButton.setImage(isTwoColumns ? UIImage(systemName: "list.bullet") : UIImage(systemName: "square.grid.2x2"), for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        topBar.addSubview(titleLabel)
        topBar.addSubview(toggleButton)
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16.0),
            toggleButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
        
        if self.isTwoColumns {
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            view.addSubview(tableView)
            tableView.separatorStyle = .none
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    @objc func toggleButtonTapped() {
        isTwoColumns.toggle()
        updateLayout()
    }
    
    func updateLayout() {
        view.subviews.forEach { $0.removeFromSuperview() }
        setUpView()
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view is UIButton {
            return false
        }
        return true
    }
}
