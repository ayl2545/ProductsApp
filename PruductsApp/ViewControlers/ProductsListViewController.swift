//
//  ProductsListViewController.swift
//  PruductsApp
//
//  Created by Avraham L on 29/01/2025.
//

import UIKit

class ProductsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    let viewModel = ProductsListViewModel()
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title = "Products List"
        title = "Products List"
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProducts()
    }
    
    func loadProducts() {
        Task { [weak self] in
            self?.products = await self?.viewModel.getProductsFromCoreData() ?? []
            self?.tableView?.reloadData()
        }
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshProducts), for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }
    
    @objc private func refreshProducts() {
        Task { [weak self] in
            await self?.viewModel.deleteAllProductsFromCoreData()
            self?.loadProducts()
            DispatchQueue.main.async {
                self?.tableView?.refreshControl?.endRefreshing()
            }
        }
    }

}

extension ProductsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell
        let product = products[indexPath.row]
        cell?.configure(with: product)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        if let productDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ProductDetails") as? ProductDetailsViewController {
            productDetailsVC.product = selectedProduct
            navigationController?.pushViewController(productDetailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let productToDelete = self.products[indexPath.row]
        let id = Int(productToDelete.id)
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] _,_,_ in
            Task {
                await self?.viewModel.deleteProductFromCoreData(with: id)
                DataManager.shared.removeFavoriteProduct(id)
                self?.loadProducts()
            }
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = products[indexPath.row]
        let id = Int(product.id)
        let isFavorite = DataManager.shared.isFavoriteProduct(id)
        let title = isFavorite ? "Remove from favorites" : "Add to favorites"
        let favoriteAction = UIContextualAction(style: .normal, title: title) { [weak self] _, _, completionHandler in
            if isFavorite {
                DataManager.shared.removeFavoriteProduct(id)
            } else {
                DataManager.shared.addFavoriteProduct(id)
            }
            self?.loadProducts()
            
            completionHandler(true)
        }
        
        let starImageName = isFavorite ? "star" : "star.fill"
        favoriteAction.image = UIImage(systemName: starImageName)?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        favoriteAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let productsCount = self.products.count
        if offsetY > contentHeight - frameHeight - 100 {
            Task {
                await viewModel.fetchRemainingProducts()
                self.products = await viewModel.getProductsFromCoreData()
                if self.products.count > productsCount {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
}
