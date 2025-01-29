//
//  Codeable.swift
//  PruductsApp
//
//  Created by Avraham L on 29/01/2025.
//

import CoreData

struct ProductsResponse: Codable {
    let products: [ProductCodable]?
    let total: Int?
    let skip: Int?
    let limit: Int?
}

struct ProductCodable: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let category: String?
    let price: Double?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let tags: [String]?
    let brand: String?
    let sku: String?
    let weight: Int?
    let warrantyInformation: String?
    let shippingInformation: String?
    let availabilityStatus: String?
    let returnPolicy: String?
    let minimumOrderQuantity: Int?
    let images: [String]?
    let thumbnail: String?
    
    func getCoreDataObject(_ context: NSManagedObjectContext) {
        let newProduct = Product(context: context)
        newProduct.availabilityStatus = self.availabilityStatus
        newProduct.brand = self.brand
        newProduct.category = self.category
        newProduct.descript = self.description
        newProduct.discountPercentage = self.discountPercentage ?? 0
        newProduct.id = Int16(self.id ?? 0)
        newProduct.imagesArray = self.images?.joined(separator: ";") ?? ""
        newProduct.minimumOrderQuantity = Int16(self.minimumOrderQuantity ?? 0)
        newProduct.price = self.price ?? 0
        newProduct.rating = self.rating ?? 0
        newProduct.returnPolicy = self.returnPolicy
        newProduct.shippingInformation = self.shippingInformation
        newProduct.sku = self.sku
        newProduct.stock = Int16(self.stock ?? 0)
        newProduct.tagsArray = self.tags?.joined(separator: ";")
        newProduct.thumbnail = self.thumbnail
        newProduct.title = self.title
        newProduct.warrantyInformation = self.warrantyInformation
        newProduct.weight = Int16(self.weight ?? 0)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
