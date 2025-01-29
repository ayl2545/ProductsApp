//
//  LogInVM.swift
//  PruductsApp
//
//  Created by Avraham L on 29/01/2025.
//

import KeychainSwift
import Foundation
import UIKit
import LocalAuthentication

class LogInViewModel {
    
    let keyChain = KeychainSwift()
    init() {
        keyChain.set("123456", forKey: "ayl")
    }
    
    func checkPassword(_ userName: String, _ password: String) -> Bool {
        return keyChain.get(userName) == password
    }
    
    func logIn() {
        DataManager.shared.logIn()
        DataManager.shared.changeRoot()
    }
    
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        let reason = "Authenticate using biometrics."
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return completion(false, "Biometric authentication is not supported.")
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                completion(success, error?.localizedDescription)
            }
        }
    }
}
