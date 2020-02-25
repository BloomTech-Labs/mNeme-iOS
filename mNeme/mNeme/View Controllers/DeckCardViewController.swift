//
//  DeckCardViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DeckCardViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var badRating: UIButton!
    @IBOutlet weak var okayRating: UIButton!
    @IBOutlet weak var greatRating: UIButton!
    @IBOutlet weak var nextCardButton: UIButton!
    @IBOutlet weak var wellKnownQuestion: UILabel!
    
    private var frontLabel: UILabel!
    private var backLabel: UILabel!
    
    var deck: MockDemoDeck?
    var cards: [CardData] = []
    var currentCardInfo: CardInfo?
    var currentCardIndex: Int = 0
    
    var mockDemoDeckController = MockDemoDeckController()
    
    private var showingBack = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        testDemoDeck()

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        containerView.addGestureRecognizer(singleTap)
    }
    
    // MARK: - IB Actions

    @IBAction func badRatingTapped(_ sender: Any) {
        
    }
    
    @IBAction func okayRatingTapped(_ sender: Any) {
    }
    
    @IBAction func greatRatingTapped(_ sender: Any) {
        
    }
    
    @IBAction func nextCardButtonTapped(_ sender: Any) {
        wellKnownQuestion?.isHidden.toggle()
    }

    @objc func flip() {
        backLabel?.isHidden.toggle()
        wellKnownQuestion?.isHidden.toggle()
        badRating?.isHidden.toggle()
        okayRating?.isHidden.toggle()
        greatRating?.isHidden.toggle()
        
        let toView = showingBack ? frontLabel : backLabel
        let fromView = showingBack ? backLabel : frontLabel
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: .transitionFlipFromRight, completion: nil)
        toView?.translatesAutoresizingMaskIntoConstraints = false
        showingBack = !showingBack
    }
    
    private func testDemoDeck() {
        deck = mockDemoDeckController.decodeMockData()
        
        var currentCardInfo = deck?.data[currentCardIndex].data
        
        frontLabel?.text = currentCardInfo?.front
        backLabel?.text = currentCardInfo?.back
            
    }
    
    private func updateViews() {
        frontLabel = UILabel(frame: CGRect(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2, width: 80, height: 50))
        backLabel = UILabel(frame: CGRect(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2, width: 80, height: 50))

//        backLabel?.isHidden = true
//        nextCardButton?.isHidden = true
//        wellKnownQuestion?.isHidden = true
//        badRating?.isHidden = true
//        okayRating?.isHidden = true
//        greatRating?.isHidden = true

        containerView.addSubview(frontLabel!)
        containerView.addSubview(backLabel!)
        
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
