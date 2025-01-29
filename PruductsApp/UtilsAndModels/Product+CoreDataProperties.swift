//
//  Product+CoreDataProperties.swift
//  PruductsApp
//
//  Created by Avraham L on 02/02/2025.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var availabilityStatus: String?
    @NSManaged public var brand: String?
    @NSManaged public var category: String?
    @NSManaged public var descript: String?
    @NSManaged public var discountPercentage: Double
    @NSManaged public var id: Int16
    @NSManaged public var imagesArray: String?
    @NSManaged public var minimumOrderQuantity: Int16
    @NSManaged public var price: Double
    @NSManaged public var rating: Double
    @NSManaged public var returnPolicy: String?
    @NSManaged public var shippingInformation: String?
    @NSManaged public var sku: String?
    @NSManaged public var stock: Int16
    @NSManaged public var tagsArray: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var warrantyInformation: String?
    @NSManaged public var weight: Int16
    @NSManaged public var dimensions: Dimensions?
    @NSManaged public var meta: Meta?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for reviews
extension Product {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}

extension Product : Identifiable {

}
