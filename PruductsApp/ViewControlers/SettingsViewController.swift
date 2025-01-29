//
//  SettingsViewController.swift
//  PruductsApp
//
//  Created by Avraham L on 04/02/2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let viewModel = SettingsViewModel()

    @IBOutlet weak var logOutBtn: UIButton?
    @IBOutlet weak var darkModeBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        logOutBtn?.setTitle("Log Out", for: .normal)
        logOutBtn?.backgroundColor = .lightGray
        logOutBtn?.setTitleColor(.black, for: .normal)
        logOutBtn?.layer.cornerRadius = 10
        let modeTitle = DataManager.shared.isDarkMode() ? "Light Mode" : "Dark Mode"
        darkModeBtn?.setTitle(modeTitle, for: .normal)
        darkModeBtn?.backgroundColor = .lightGray
        darkModeBtn?.setTitleColor(.black, for: .normal)
        darkModeBtn?.layer.cornerRadius = 10
    }

    @IBAction func darkBtnClicked(_ sender: Any) {
        let isDarkNow = DataManager.shared.isDarkMode()
        viewModel.applyMode(isDark: !isDarkNow)
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        viewModel.logout()
    }
}
