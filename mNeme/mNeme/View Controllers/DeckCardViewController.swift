//
//  DeckCardViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DeckCardViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    private let frontLabel: UILabel! = UILabel()
    private let backLabel: UILabel! = UILabel()
    
    private var showingFront = true

    override func viewDidLoad() {
        super.viewDidLoad()

        frontLabel.contentMode = .scaleAspectFit
        backLabel.contentMode = .scaleAspectFit

        containerView.addSubview(frontLabel)
        
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
//        singleTap.numberOfTapsRequired = 1
//        containerView.addGestureRecognizer(singleTap)
//    }
//
//    func flip() {
//        let toView = showingBack ? frontImageView : backImageView
//        let fromView = showingBack ? backImageView : frontImageView
//        UIView.transitionFromView(fromView, toView: toView, duration: 1, options: .TransitionFlipFromRight, completion: nil)
//        toView.translatesAutoresizingMaskIntoConstraints = false
//        toView.spanSuperview()
//        showingBack = !showingBack
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
