//
//  ProductsListVM.swift
//  PruductsApp
//
//  Created by Avraham L on 29/01/2025.
//

import Foundation
import CoreData
import UIKit

class ProductsListViewModel {
    
    private let persistentContainer: NSPersistentContainer?
    private var isFetching = false
    private var totalProducts = Int.max
    private let limit = 30
    
    init() {
        self.persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func getProductsFromCoreData() async -> [Product] {
        var products = await fetchProductsFromCoreData()
        if products.isEmpty {
            await fetchAndSaveProducts(skip: 0)
            products = await fetchProductsFromCoreData()
        }
        return products
    }
    
    private func fetchProductsFromCoreData() async -> [Product] {
        guard let context = persistentContainer?.viewContext else { return [] }

        return await context.perform {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            do {
                return try context.fetch(fetchRequest)
            } catch {
                print(error)
                return []
            }
        }
    }
    
    private func fetchAndSaveProducts(skip: Int) async {
        guard !isFetching else { return }
        isFetching = true
        
        let urlString = "https://dummyjson.com/products?limit=\(limit)&skip=\(skip)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(ProductsResponse.self, from: data)
            
            self.totalProducts = result.total ?? self.totalProducts
            
            if let products = result.products {
                for product in products {
                    await saveProductInCoreData(product)
                }
            }
        } catch {
            print(error)
        }
        isFetching = false
    }
    
    func fetchRemainingProducts() async {
        let existingCount = await getProductsCountFromCoreData()
        guard existingCount < totalProducts else { return }
        
        await fetchAndSaveProducts(skip: existingCount)
    }
    
    private func saveProductInCoreData(_ product: ProductCodable) async {
        guard let context = persistentContainer?.viewContext else { return }
        product.getCoreDataObject(context)
        await context.perform {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func getProductsCountFromCoreData() async -> Int {
        guard let context = persistentContainer?.viewContext else { return 0 }
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        return await context.perform {
            do {
                return try context.count(for: fetchRequest)
            } catch {
                return 0
            }
        }
    }
    
    func getFavoriteProductsFromCoreData() async -> [Product] {
        return await getProductsFromCoreData().filter { product in
            DataManager.shared.isFavoriteProduct(Int(product.id))
        }
    }
    
    func deleteProductFromCoreData(with id: Int) async {
        guard let context = persistentContainer?.viewContext else { return }
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        await context.perform {
            do {
                let results = try context.fetch(fetchRequest)
                for object in results {
                    context.delete(object)
                }
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteAllProductsFromCoreData() async {
        guard let context = persistentContainer?.viewContext else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Product")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        await context.perform {
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print(error)
            }
        }
    }

}

