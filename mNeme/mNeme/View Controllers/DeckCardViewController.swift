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
    
    private var frontLabel: UILabel!
    private var backLabel: UILabel!
    
//    var cards: [Card]? = []
//    var currentCard: Card?
    var currentCardIndex: Int = 1
    
    private var showingBack = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontLabel = UILabel(frame: CGRect(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2, width: 80, height: 50))
        backLabel = UILabel(frame: CGRect(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2, width: 80, height: 50))
        
//        cards[currentCardIndex]
        frontLabel?.text = "front"
        backLabel?.text = "back"
        backLabel?.isHidden = true
//        frontLabel.contentMode = .scaleAspectFit
//        backLabel.contentMode = .scaleAspectFit

        containerView.addSubview(frontLabel!)
        containerView.addSubview(backLabel!)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        containerView.addGestureRecognizer(singleTap)
    }

    @objc func flip() {
        backLabel?.isHidden.toggle()
        let toView = showingBack ? frontLabel : backLabel
        let fromView = showingBack ? backLabel : frontLabel
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: .transitionFlipFromRight, completion: nil)
        toView?.translatesAutoresizingMaskIntoConstraints = false
        showingBack = !showingBack
    }
    
    private func setCurrentCard() {
        
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
