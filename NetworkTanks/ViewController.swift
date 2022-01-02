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
    var datass = Datum(name: String.init(), images: Images(smallIcon: String.init()), description: String.init())
    let sspacing: CGFloat = 0.0
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Tankopedia"
        setupActivityIndicator()
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
            DispatchQueue.main.async { self.collectionView.reloadData() }
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
        if let collection = self.collectionView{
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
        let cellVM  = dataViewModel.getCellViewModel(at: indexPath)
        cell.nameLabel.text = cellVM.tankLabel
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        Nuke.loadImage(with: cellVM.tankImage, into: cell.imagePhoto)
        self.activityIndicator.stopAnimating()
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController {
            let cellVC  = dataViewModel.getCellViewModel(at: indexPath)
            vc.imageTank.bigIcon = ("\(cellVC.tankImage)")
            vc.detailTank.description = cellVC.desc
            vc.detailTank.name = cellVC.tankLabel
            
            print("Did Select \(cellVC.tankImage)")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
