//
//  HomeViewController.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var collectionView: UICollectionView?
    var collectionViewDataSource: HomeViewControllerDataSource!
    var collectionViewDelegate: HomeViewControllerDelegate!

    let locationsManager = LocationsManager()
    
    override func loadView() {
        super.loadView()
        let v = UIView(frame: .zero)
        v.backgroundColor = .primary
        self.view = v
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    var favCounterBarButton: UIBarButtonItem?
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
        setupCollectionView()
        #if APPCLIP
        addNavCounter()
        #endif
        updateFavoriteCounterIfNeeded()
        
    }
    // MARK: - Setup UI

    func setupCollectionView() {

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: PinterestLayout())
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UINib(nibName: "ListCellUICollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "ListCell")

        let defaultInset: CGFloat = 7
        collectionView?.contentInset = UIEdgeInsets(top: defaultInset, left: defaultInset,
                                                    bottom: defaultInset, right: defaultInset)
        
        collectionViewDataSource = HomeViewControllerDataSource(with: locationsManager)
        collectionView?.dataSource = collectionViewDataSource
        
        collectionViewDelegate = HomeViewControllerDelegate(with: locationsManager)
        collectionView?.delegate = collectionViewDelegate
        
        #if !APPCLIP
        locationsManager.delegate = self
        #endif
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = collectionViewDelegate
        }
        
        view.addSubview(collectionView!)
        collectionView?.fillInParentView()
    }
    
    
    @objc func addNavCounter() {
        
        favCounterBarButton = UIBarButtonItem(title: "Favoritos: 0", style: .plain, target: self, action: nil)
        favCounterBarButton?.tintColor = .white
        
        navigationItem.rightBarButtonItem = favCounterBarButton
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteCounterIfNeeded), name: NSNotification.Name(rawValue: "FavoritesUpdated"), object: nil)
        
    }
    
    @objc func updateFavoriteCounterIfNeeded() {
        let totalOfFavorites = collectionViewDelegate.locationsManager.locations.filter { $0.isFavorite }.count
        favCounterBarButton?.title = "Favoritos: \(totalOfFavorites)"
    }

}

// MARK: - LocationManagerDelegate

#if !APPCLIP

extension HomeViewController: LocationManagerDelegate {
    func locationSelected(_ location: Location) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVc = storyboard.instantiateViewController(withIdentifier: "DetailLocationViewController")
            as? DetailLocationViewController {

            detailsVc.locationId = location.id
            detailsVc.title = "Detalhes"
            navigationController?.pushViewController(detailsVc, animated: true)
        }
    }
    
    func didUpdateLocations() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
}
#endif
