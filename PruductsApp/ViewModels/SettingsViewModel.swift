//
//  SettingsViewModel.swift.swift
//  PruductsApp
//
//  Created by Avraham L on 04/02/2025.
//

import Foundation

class SettingsViewModel {
    
    func logout() {
        DataManager.shared.logOut()
        DataManager.shared.changeRoot()
        DataManager.shared.deleteAllCoreData()
    }
    
    func applyMode(isDark: Bool) {
        DataManager.shared.setDarkMode(isDark)
    }
}
