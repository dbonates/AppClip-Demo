//
//  ListCellUICollectionViewCell.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import UIKit

class ListCellUICollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationTypeLabel: UILabel!

    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!

    @IBOutlet weak var ratingLabel: UILabel!

    
    var location: Location?
    let favButton = UIButton(type: .custom)

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }


    func configure(with location: Location) {
        
        self.location = location
        
        self.locationNameLabel.text = location.name
        self.locationTypeLabel.text = location.type
        self.ratingLabel.text = "\(location.review)"

        // star images stuff
        let starImageViews = [star1ImageView, star2ImageView, star3ImageView,
                              star4ImageView, star5ImageView].compactMap { $0 }
        for imageView in starImageViews {
            imageView.image = .starOn
        }

        var numberOfStars = Int(location.review.major)
        if location.review.minor > 0.5 { numberOfStars += 1 }

        let shouldNotPaintImageViews = Array(starImageViews.dropFirst(numberOfStars))
        for imageView in shouldNotPaintImageViews {
            imageView.image = .starOff
        }
        
        // image
        guard let imageURL = location.imageURL else { return }
        
        DispatchQueue.global().async {
        
            ImageCache.getImage(for: imageURL, completion: { [weak self] image in
                DispatchQueue.main.async {
                    self?.locationImageView.showImage(image)
                }
            })
            
        }
        
        setupShadow()
        setupFavoriteButton()
    }
    
    
    
    func setupFavoriteButton() {
        
        guard let location = location else { return }
        
        let image = UIImage(systemName: "star.fill")
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.frame = .zero
        favButton.setImage(image, for: .normal)
        favButton.tintColor = location.isFavorite ? .systemYellow : .systemGray
        favButton.addTarget(self, action: #selector(toogleFavorite(_:)), for: .touchUpInside)
        favButton.contentMode = .scaleAspectFill
        contentView.addSubview(favButton)
        
        favButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        favButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        favButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    @objc func toogleFavorite(_ sender: Any) {
        
        guard let location = location else { return }
        
        location.toogleFavorite()
        
        favButton.tintColor = location.isFavorite ? .systemYellow : .systemGray
    }
    
    override func prepareForReuse() {
        locationImageView.image = nil
    }
    
    
    func setupShadow() {
        let radius: CGFloat = 16
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.18
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }

}
