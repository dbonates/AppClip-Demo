//
//  DetailLocationViewController.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import UIKit

class DetailLocationViewController: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!

    @IBOutlet weak var localtionImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!

    @IBOutlet weak var reviewLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var thumbnalsCollectionView: UICollectionView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    var location: LocationDetail? {
        didSet {
            updateUI(with: location)
        }
    }
    
    var locationId: Int!
    
    var thumbnailsCollectionViewDataSource = ThumbnailsCollectionViewDataSource()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        view.backgroundColor = .white
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDetailManager(with: self.locationId)
    }
    func setupDetailManager(with locationId: Int) {
        
        do {
            try LocationsManager.getLocationDetail(id: locationId) { [weak self] result in
                switch result {
                case .success(let location):
                    self?.location = location
                case .failure(let error):
                    print(error.errorMessage)
                }
            }
                
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    func setupUI() {

        thumbnalsCollectionView.register(ThumbnailsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        thumbnalsCollectionView.dataSource = thumbnailsCollectionViewDataSource
        thumbnalsCollectionView.backgroundColor = .white
        shareButton.setTitle("", for: .normal)
        shareButton.setTitleColor(.clear, for: .normal)

        backButton.setTitle("", for: .normal)
        backButton.setTitleColor(.clear, for: .normal)

        setupGradientView()

    }
    
    func updateUI(with location: LocationDetail?) {
        
        
        guard let location = location else {
            return
        }

        nameLabel.text = location.name
        reviewLabel.text = "\(location.review)"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = location.about
        scheduleLabel.text = location.schedule?.groupedList() ?? ""
        phoneLabel.text = location.phone
        addressLabel.text = location.adress

        // stars
        let starImageViews = [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView].compactMap { $0 }
        for imageView in starImageViews {
            imageView.image = .starOn
        }

        var numberOfStars = Int(location.review.major)
        if location.review.minor > 0.5 { numberOfStars += 1 }

        let shouldNotPaintImageViews = Array(starImageViews.dropFirst(numberOfStars))
        for imageView in shouldNotPaintImageViews {
            imageView.image = .starOff
        }
        if let locationDetailImageURL = location.imageURL {
            ImageCache.getImage(for: locationDetailImageURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.localtionImageView.showImage(image)
                }
            }
        }

        DetailManager.setupThumbnails { [weak self] thumbUrls in
            guard let thumbUrls = thumbUrls else {
                return
            }

            self?.thumbnailsCollectionViewDataSource.thumbURLs = thumbUrls
            self?.thumbnalsCollectionView.reloadData()

        }
        setupReviewsSection()
    }

    
    func setupReviewsSection() {

        ResourceManager.loadReviews { result in

            switch result {
            case .failure(let error):
                print(error.errorMessage)
            case .success(let reviews):
                DispatchQueue.main.async {
                    self.buildReviewsSection(with: reviews)
                }
            }
        }
    
    }
    
    func buildReviewsSection(with reviews: [ReviewResource]) {
        
        
        // first, the header
        let reviewsLabelContainer = UIView(frame: .zero)
        reviewsLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let reviewsLabel = UILabel(frame: .zero)
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewsLabel.text = "REVIEWS"
        reviewsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        reviewsLabel.textColor = .primary
        reviewsLabelContainer.addSubview(reviewsLabel)
        reviewsLabel.leftAnchor.constraint(equalTo: reviewsLabelContainer.leftAnchor, constant: 26).isActive = true
        mainStackView.addArrangedSubview(reviewsLabelContainer)
        
        // 5 for demo purposes
        let first3Reviews = Array(reviews[0 ..< 5])
        
        for review in first3Reviews {
         
            let gender = ["women", "men"].randomElement()!
            let number = Int.random(in: 40...81)
            
            guard let reviewCardView = UINib(nibName: "ReviewCardView", bundle: .main).instantiate(withOwner: nil, options: nil).first as? ReviewCardView else { return }
            
            reviewCardView.translatesAutoresizingMaskIntoConstraints = false
            reviewCardView.configureReview(review)
            let url = URL(string: "https://randomuser.me/api/portraits/\(gender)/\(number).jpg")!
            reviewCardView.displayImage(from: url)
            mainStackView.addArrangedSubview(reviewCardView)
            reviewCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
            
            
        }
        
        // footer

        let reviewsFooterLabelContainer = UIView(frame: .zero)
        reviewsFooterLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let reviewsViewAllLabel = UILabel(frame: .zero)
        reviewsViewAllLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewsViewAllLabel.text = "Ver todas 146 reviews >"
        reviewsViewAllLabel.textAlignment = .right
        reviewsViewAllLabel.font = .systemFont(ofSize: 16, weight: .regular)
        reviewsViewAllLabel.textColor = .primary
        reviewsFooterLabelContainer.addSubview(reviewsViewAllLabel)
        reviewsViewAllLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        reviewsViewAllLabel.rightAnchor.constraint(equalTo: reviewsFooterLabelContainer.rightAnchor, constant: -26).isActive = true
        mainStackView.addArrangedSubview(reviewsFooterLabelContainer)
        
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        mainStackView.isLayoutMarginsRelativeArrangement = true
    }

    func setupGradientView() {
        gradientView.backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0.9).cgColor, UIColor.black.withAlphaComponent(0).cgColor]

        gradientView.layer.insertSublayer(gradient, at: 0)
    }

    @IBAction func justBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}


extension DetailLocationViewController: DetailManagerDelegate {
    func didLoadedDetails(from locationDetail: LocationDetail) {
        
    }
    
    
    func didFetchedThumbnailsURLs() {
        thumbnalsCollectionView.reloadData()
    }
}
