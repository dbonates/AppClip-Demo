//
//  ReviewCardsView.swift
//  AppDemo
//
//  Created by Daniel Bonates on 10/12/21.
//

import UIKit

class ReviewCardView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!

}

extension ReviewCardView {
    
    func configureReview(_ review: ReviewResource) {
        titleLabel.text = review.title
        infoLabel.text = review.info
        ratingLabel.text = "\(review.rating)"
        nameLabel.text = review.name
        
        let starImageViews = [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView].compactMap { $0 }
        for imageView in starImageViews {
            imageView.image = .starOn
        }

        var numberOfStars = Int(review.rating.major)
        if review.rating.minor > 0.5 { numberOfStars += 1 }

        let shouldNotPaintImageViews = Array(starImageViews.dropFirst(numberOfStars))
        for imageView in shouldNotPaintImageViews {
            imageView.image = .starOff
        }
        
        profileImageView.layer.cornerRadius = 32
        profileImageView.clipsToBounds = true

    }
    
    func displayImage(from url: URL) {
        
        DispatchQueue.global().async {

            ImageCache.getImage(for: url) { [weak self] image in

                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }

            }

        }

    }
}
