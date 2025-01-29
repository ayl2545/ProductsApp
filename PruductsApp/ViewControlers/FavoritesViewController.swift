//
//  FavoritesViewController.swift
//  PruductsApp
//
//  Created by Avraham L on 03/02/2025.
//

import UIKit

class FavoritesViewController: ProductsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
    }
    
    override func loadProducts() {
        Task {
            products = await viewModel.getFavoriteProductsFromCoreData()
            tableView?.reloadData()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    }
    
    override func setupRefreshControl() {
        
    }
}
