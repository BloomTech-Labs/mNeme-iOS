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
    // MARK: - Variables
    private var frontLabel: UILabel!
    private var backLabel: UILabel!
    var deck: MockDemoDeck?
    var cards: [CardData] = []
    var currentCardInfo: CardInfo?
    var currentCardIndex: Int = 0
    var mockDemoDeckController = MockDemoDeckController()
    private var showingBack = false {
        didSet {
            if self.showingBack {
                showBackandRating()
            } else {
                hideAllLabels()
            }
        }
    }
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetching deck data data
        deck = mockDemoDeckController.decodeMockData()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        containerView.addGestureRecognizer(singleTap)
        // Start setting up label logic
        makeLabels()
        hideAllLabels()
        updateDeckText()
    }
    // MARK: - IB Actions
    @IBAction func badRatingTapped(_ sender: Any) {
        ratingWasTapped()
    }
    @IBAction func okayRatingTapped(_ sender: Any) {
      ratingWasTapped()
    }
    @IBAction func greatRatingTapped(_ sender: Any) {
       ratingWasTapped()
    }
    @IBAction func nextCardButtonTapped(_ sender: Any) {
        currentCardIndex += 1
        showingBack = false
        makeLabels()
        hideAllLabels()
        updateDeckText()
    }
    @objc func flip() {
        let toView = showingBack ? frontLabel : backLabel
        let fromView = showingBack ? backLabel : frontLabel
        UIView.transition(from: fromView!, to: toView!, duration: 1, options: .transitionFlipFromRight, completion: nil)
        toView?.translatesAutoresizingMaskIntoConstraints = false
        showingBack = !showingBack
    }
    // MARK: - Private Functions
    private func updateDeckText() {
        let currentCardInfo = deck?.data[currentCardIndex].data
        frontLabel?.text = currentCardInfo?.front
        print("\(String(describing: currentCardInfo?.front))")
        backLabel?.text = currentCardInfo?.back
    }
    private func makeLabels() {
        frontLabel = UILabel(frame: CGRect(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2, width: 80, height: 50))
        backLabel = UILabel(frame: CGRect(x: self.containerView.frame.width/2, y: self.containerView.frame.height/2, width: 80, height: 50))
        containerView.addSubview(frontLabel!)
        containerView.addSubview(backLabel!)
    }
    private func ratingWasTapped() {
        wellKnownQuestion?.isHidden = true
        badRating?.isHidden = true
        okayRating?.isHidden = true
        greatRating?.isHidden = true
        nextCardButton?.isHidden = false
    }
    private func hideAllLabels() {
        backLabel?.isHidden = true
        nextCardButton?.isHidden = true
        wellKnownQuestion?.isHidden = true
        badRating?.isHidden = true
        okayRating?.isHidden = true
        greatRating?.isHidden = true
    }
    private func showBackandRating() {
        backLabel?.isHidden = false
        wellKnownQuestion?.isHidden = false
        badRating?.isHidden = false
        okayRating?.isHidden = false
        greatRating?.isHidden = false
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
