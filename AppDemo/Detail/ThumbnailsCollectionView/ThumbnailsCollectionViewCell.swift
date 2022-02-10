//
//  ThumbnailsCollectionViewCell.swift
//  AppDemo
//
//  Created by Daniel Bonates on 09/12/21.
//

import UIKit

class ThumbnailsCollectionViewCell: UICollectionViewCell {

    var imageView: UIImageView!
    
//    let image = UIIMage(systemName: "person.fill"
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    open func setupUI() {

        backgroundColor = .primary

        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.fillInParentView()

        setupShadow()
        
    }
    
    func displayRandomImage(from url: URL) {
        
        DispatchQueue.global().async {

            ImageCache.getImage(for: url) { [weak self] image in

                DispatchQueue.main.async {
                    self?.imageView.showImage(image)
                }

            }

        }

    }
    

    open override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
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
