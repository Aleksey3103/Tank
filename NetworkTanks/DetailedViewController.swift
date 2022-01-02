//
//  DetailedViewController.swift
//  NetworkTanks
//
//  Created by Aleksey on 29.12.2021.
//

import UIKit
import Nuke

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var imageDetail: UIImageView!
    var apiClient = RequestManager()
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nameTank: UILabel!
    var imageTank = Images()
    var dataViewModel = TanksViewModel()
    var detailTank = Datum(name: String.init(), images: Images(smallIcon: String.init()), description: String.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInfo()
        imageDetail.layer.cornerRadius = 8
        descriptionLabel.layer.cornerRadius = 8
//        setupNavigationMultilineTitle()
        navigationItem.title = detailTank.name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setupNavigationMultilineTitle()
    }
    
    func detailInfo() {
        if let imageurl = imageTank.bigIcon {
            Nuke.loadImage(with: imageurl, into: imageDetail.unsafelyUnwrapped)
        }
        descriptionLabel.text = detailTank.description
    }
}
//extension DetailedViewController {
//
//    func setupNavigationMultilineTitle() {
//        guard let navigationBar = self.navigationController?.navigationBar else { return }
//        for sview in navigationBar.subviews {
//            for ssview in sview.subviews {
//                guard let label = ssview as? UILabel else { break }
//                if label.text == self.title {
//                    label.numberOfLines = 3
//                    label.lineBreakMode = .byWordWrapping
//                    label.sizeToFit()
//                    UIView.animate(withDuration: 1, animations: {
//                        navigationBar.frame.size.height = 57 + label.frame.height
//                    })
//                }
//            }
//        }
//    }
//}
