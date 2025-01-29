//
//  DataManager.swift
//  PruductsApp
//
//  Created by Avraham L on 03/02/2025.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    enum keys: String {
        case favorites = "favoriteProducts"
        case logedIn = "logedIn"
        case darkMode = "darkMode"
    }
    
    static let shared = DataManager()
    
    private init() {}
    
    func getFavoriteProducts() -> [Int] {
        return UserDefaults.standard.array(forKey: keys.favorites.rawValue) as? [Int] ?? []
    }
    
    func addFavoriteProduct(_ id: Int) {
        var favorites = getFavoriteProducts()
        if !favorites.contains(id) {
            favorites.append(id)
            UserDefaults.standard.set(favorites, forKey: keys.favorites.rawValue)
        }
    }
    
    func removeFavoriteProduct(_ id: Int) {
        var favorites = getFavoriteProducts()
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
            UserDefaults.standard.set(favorites, forKey: keys.favorites.rawValue)
        }
    }
    
    func isFavoriteProduct(_ id: Int) -> Bool {
        return getFavoriteProducts().contains(id)
    }
    
    func logIn() {
        UserDefaults.standard.set(true, forKey: keys.logedIn.rawValue)
    }
    
    func logOut() {
        UserDefaults.standard.set(false, forKey: keys.logedIn.rawValue)
    }
    
    func isLogedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: keys.logedIn.rawValue)
    }
    
    func changeRoot() {
        let appDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        appDelegate?.changeRootViewController()
    }
    
    func setDarkMode(_ isDark: Bool) {
        UserDefaults.standard.set(isDark, forKey: keys.darkMode.rawValue)
        applyMode()
    }
    
    func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: keys.darkMode.rawValue)
    }
    
    func applyMode() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.overrideUserInterfaceStyle = isDarkMode() ? .dark : .unspecified
    }
    
    func deleteAllCoreData() {
        guard let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = persistentContainer.viewContext

        let entities = persistentContainer.managedObjectModel.entities
        
        do {
            for entity in entities {
                guard let entityName = entity.name else { continue }
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
            }
            try context.save()
        } catch {
            print(error)
        }
    }

}
