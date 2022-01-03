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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
//        setupNavigationMultilineTitle()
        navigationItem.title = detailTank.name
    }
    
//        func navigationItemBar() {
//            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
//            label.backgroundColor = UIColor.clear
//            label.numberOfLines = 0
//            label.textAlignment = NSTextAlignment.center
//            label.text = detailTank.name
//            label.textColor = UIColor.white
//            self.navigationItem.titleView = label
//
//    }

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
