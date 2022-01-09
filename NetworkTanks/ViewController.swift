//
//  ViewController.swift
//  NetworkTanks
//
//  Created by Aleksey on 27.12.2021.
//

import UIKit
import Nuke

class ViewController: UIViewController {
    
    var apiClient = RequestManager()
    var dataViewModel = TanksViewModel()
    let sspacing: CGFloat = 0.0
    var data = [Datum]()
    var searchActive = false
    var activityIndicator = UIActivityIndicatorView()
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBarISEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarISEmpty
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Tankopedia"
        self.definesPresentationContext = true
        setupActivityIndicator()
        setupSearch()
    }
    
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.text = ""
        searchController.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        collectionView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        initViewModel()
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.white
        view.addSubview(activityIndicator)
    }
    
    func initViewModel() {
        dataViewModel.reloadInfo = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        dataViewModel.showError = {
            DispatchQueue.main.async { self.collectionView.reloadData() }
            //            self.showAlert()
        }
        self.activityIndicator.startAnimating()
        dataViewModel.getData()
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 70
        let totalSpacing = (2 * self.sspacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.collectionView {
            let width = (collection.bounds.width + totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 130, height: 140)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Not cell")
        }
        let dataVM  = dataViewModel.getCellViewModel(at: indexPath)
        cell.nameLabel.text = dataVM.tankLabel
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        Nuke.loadImage(with: dataVM.tankImage, into: cell.imagePhoto)
        return cell
    }
    //"The Internet connection appears to be offline"
    //"\(String(describing: dataViewModel.showError))"
    func showAlert() {
        let alert = UIAlertController(title: "Warning", message: "\(String(describing: dataViewModel.apiClient.tankDataError))" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController {
            let cellVC = dataViewModel.getCellViewModel(at: indexPath)
            vc.imageTank.bigIcon = ("\(cellVC.tankImage)")
            vc.detailTank.description = cellVC.desc
            vc.detailTank.name = cellVC.tankLabel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if isFiltering == true {
            dataViewModel.filterTanks(for: searchController.searchBar.text ?? "")
        } else {
            dataViewModel.endSearching()
        }
    }
}
