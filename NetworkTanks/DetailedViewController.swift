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
        navigationItem.title = detailTank.name
    }
    
    func detailInfo() {
        if let imageurl = imageTank.bigIcon {
            Nuke.loadImage(with: imageurl, into: imageDetail.unsafelyUnwrapped)
        }
        descriptionLabel.text = detailTank.description
    }
}
