//
//  ProductDetailsViewController.swift
//  PruductsApp
//
//  Created by Avraham L on 02/02/2025.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var rightBtn: UIButton?
    @IBOutlet weak var leftBtn: UIButton?
    @IBOutlet weak var desciption: UILabel?
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    var product: Product?
    var images: [String] = []
    var index = 0
    var isFavorite: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = "Product Details"
        titleLabel?.text = product?.title
        images = product?.imagesArray?.components(separatedBy: ";") ?? []
        
        let hasMultipleImages = images.count > 1
        rightBtn?.isHidden = !hasMultipleImages
        leftBtn?.isHidden = !hasMultipleImages
        desciption?.text = product?.descript
        priceLabel?.text = product?.price.description
        brandLabel.text = product?.brand
        setUpButton()
        loadImage()
    }

    private func loadImage() {
        guard let urlString = images[safe: index], let url = URL(string: urlString) else {
            imageView?.image = UIImage(systemName: "placeholder")
            return
        }
        imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }

    @IBAction func rightClicked(_ sender: Any) {
        index = (index + 1) % images.count
        loadImage()
    }

    @IBAction func leftClicked(_ sender: Any) {
        index = (index - 1 + images.count) % images.count
        loadImage()
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        let id = Int(product?.id ?? 0)
        if isFavorite {
            DataManager.shared.removeFavoriteProduct(id)
        } else {
            DataManager.shared.addFavoriteProduct(id)
        }
        isFavorite.toggle()
        setUpButton()
    }
    
    func setUpButton() {
        isFavorite = DataManager.shared.isFavoriteProduct(Int(product?.id ?? 0))
        favoriteBtn.setTitle(isFavorite ? "Remove from favorites" : "Add to favorites", for: .normal)
        favoriteBtn.backgroundColor = isFavorite ? UIColor.red : UIColor.blue
        favoriteBtn.layer.cornerRadius = 10
        favoriteBtn.clipsToBounds = true
    }
}

