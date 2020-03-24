//
//  DeckSearchViewController.swift
//  mNeme
//
//  Created by Niranjan Kumar on 3/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DeckSearchViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.backgroundColor = UIColor.mNeme.orangeBlaze.cgColor
        bottomImageView.image = UIImage(named: "Basketball-Mastery-Illustrations")
    }
}
