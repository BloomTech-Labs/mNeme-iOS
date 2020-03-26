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
    @IBOutlet weak var backCard: UIButton!
    @IBOutlet weak var forwardCard: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tapLeft: UIImageView!
    @IBOutlet weak var tapMid: UIImageView!
    @IBOutlet weak var tapRight: UIImageView!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var tapToFlipLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    
    
    // MARK: - Properties
    var deck: Deck?{
        didSet{
            parseCards()
        }
    }
    
    private func parseCards() {
        if let cards = deck?.data?.filter({ $0.archived != true }) {
            self.cards = cards
        }
    }
    
    var cards: [CardData] = [] {
        didSet{
            currentCardTotal = cards.count
            currentCardIndex = cards.count - 1
        }
    }
    
    var indexOfDeck: Int?
    var demoDeck: DemoDeck?{
        didSet{
            guard let total = demoDeck?.data?.count else { return }
            currentCardTotal = total
            currentCardIndex = total - 1
        }
    }
    var demo: Bool = false
    var currentCardTotal = 0
    var currentCardIndex: Int = 0
    var mockDemoDeckController = MockDemoDeckController()
    var deckController: DeckController?
    var userController: UserController?
    var allowedToFlip = true
    private var frontLabel: UILabel?
    private var backLabel: UILabel?
    private var showingBack = false {
        didSet {
            if demo == true {
                if self.showingBack {
                    showDemoDeckRatingStuff()
                    hideFrontViews()
                } else {
                    hideRatingStuff()
                    showFrontViews()
                }
            } else {
                if self.showingBack {
                    hideFrontViews()
                    showRealDeckRatingStuff()
                } else {
                    hideRatingStuff()
                    showFrontViews()
                }
            }
        }
    }
    
    private func setDeck() {
        guard let deckController = deckController, let indexOfDeck = indexOfDeck else { return }
        if demo == false {
            deck = deckController.decks[indexOfDeck]
        } else {
            demoDeck = deckController.demoDecks[indexOfDeck]
            currentCardTotal = deckController.demoDecks[indexOfDeck].data?.count ?? 0
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting up view
        setDeck()
        setupViews()
        hideOtherLabels()
        showFrontViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDeck()
        updateTitle()
        updateDeckView()
    }
    
    // MARK: - IB Actions
    @IBAction func backACard(_ sender: UIButton) {
        guard currentCardIndex < currentCardTotal-1 else { return }
        currentCardIndex += 1
        updateDeckView()
    }
    
    @IBAction func forwardACard(_ sender: UIButton) {
        guard currentCardIndex > 0 else { return }
        currentCardIndex -= 1
        updateDeckView()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        guard currentCardIndex > 0 else {
            let alert = UIAlertController(title: "You've reached the end of the deck!", message: "Would you like to reset the deck or stay here?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
                self.currentCardIndex = self.currentCardTotal - 1
                self.allowedToFlip = true
                self.nextCardButton.isHidden = true
                self.flip()
                self.updateDeckView()
            }))
            
            alert.addAction(UIAlertAction(title: "Stay here", style: .cancel, handler: { action in
                self.allowedToFlip = true
                self.nextCardButton.isHidden = true
                self.flip()
                self.updateDeckView()
            }))
            
            self.present(alert, animated: true)
            
            return }
        currentCardIndex -= 1
        allowedToFlip = true
        nextCardButton.isHidden = true
        flip()
        updateDeckView()
    }
    
    @objc func flip() {
        guard allowedToFlip == true else { return }
        let toView = showingBack ? frontLabel : backLabel
        let fromView = showingBack ? backLabel : frontLabel
        UIView.transition(from: fromView!, to: toView!, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        toView?.translatesAutoresizingMaskIntoConstraints = false
        constrain(view: toView!)
        showingBack = !showingBack
    }
    
    // MARK: - Private Functions
    private func setupViews() {
        updateTitle()
        backButton.setTitleColor(UIColor.mNeme.orangeBlaze, for: .normal)
        editButton.setTitleColor(UIColor.mNeme.orangeBlaze, for: .normal)
        tapToFlipLabel.textColor = .darkGray
        frontLabel = UILabel(frame: CGRect(x: self.containerView.frame.width, y: self.containerView.frame.height/2, width: 80, height: 50))
        backLabel = UILabel(frame: CGRect(x: self.containerView.frame.width, y: self.containerView.frame.height/2, width: 80, height: 50))
        containerView.addSubview(frontLabel!)
        constrain(view: frontLabel!)
        
        frontLabel?.textAlignment = .center
        backLabel?.textAlignment = .center
        frontLabel?.numberOfLines = 0
        backLabel?.numberOfLines = 0
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor.mNeme.orangeBlaze.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.backgroundColor = .white
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
        singleTap.numberOfTapsRequired = 1
        containerView.addGestureRecognizer(singleTap)
        
        backCard.titleLabel?.textColor = UIColor.mNeme.orangeBlaze
        forwardCard.titleLabel?.textColor = UIColor.mNeme.orangeBlaze
        backButton.titleLabel?.textColor = UIColor.mNeme.orangeBlaze
        nextCardButton.titleLabel?.textColor = UIColor.mNeme.orangeBlaze
    }
    
    private func updateTitle() {
        if demo == false {
            guard let deck = deck else { return }
            titleLabel.text = deck.deckInformation.deckName
        } else {
            titleLabel.text = demoDeck?.deckName
            editButton.isHidden = true
        }
    }
    
    private func updateDeckView() {
        if demo == false {
            if currentCardTotal > 0 {
                let currentCardInfo = cards[currentCardIndex]
                frontLabel?.text = currentCardInfo.front
                backLabel?.text = currentCardInfo.back
            } else {
                frontLabel?.text = "No cards to study"
                backLabel?.text = "Add active cards to your deck"
            }
        } else {
            let currentCardInfo = demoDeck?.data?[currentCardIndex]
            frontLabel?.text = currentCardInfo?.data.front
            backLabel?.text = currentCardInfo?.data.back
        }
    }
    
    private func constrain(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let leadConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 20)
        let trailConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -20)
        self.containerView.addConstraints([horizontalConstraint, verticalConstraint, leadConstraint, trailConstraint])
    }
    
    private func showFrontViews() {
        backCard.isHidden = false
        forwardCard.isHidden = false
        tapToFlipLabel.isHidden = false
        tapMid.isHidden = false
        containerView.layer.borderColor = UIColor.mNeme.orangeBlaze.cgColor
    }
    
    private func hideFrontViews() {
        backCard.isHidden = true
        forwardCard.isHidden = true
        tapToFlipLabel.isHidden = true
        containerView.layer.borderColor = UIColor.mNeme.goldenTaioni.cgColor
    }
    
    private func ratingWasTapped() {
        wellKnownQuestion?.isHidden = true
        badRating?.isHidden = true
        okayRating?.isHidden = true
        greatRating?.isHidden = true
        nextCardButton?.isHidden = false
        allowedToFlip = false
        tapLeft.isHidden = true
        tapRight.isHidden = true
        tapMid.isHidden = true
        tutorialLabel.isHidden = true
        tapToFlipLabel.isHidden = true
    }
    
    private func hideOtherLabels() {
        nextCardButton?.isHidden = true
        wellKnownQuestion?.isHidden = true
        badRating?.isHidden = true
        okayRating?.isHidden = true
        greatRating?.isHidden = true
        tapLeft.isHidden = true
        tapRight.isHidden = true
        tapMid.isHidden = true
        tutorialLabel.isHidden = true
    }
    
    private func showDemoDeckRatingStuff() {
        tapLeft.isHidden = false
        tapRight.isHidden = false
        tapMid.isHidden = false
        tutorialLabel.isHidden = false
        wellKnownQuestion?.isHidden = false
        badRating?.isHidden = false
        okayRating?.isHidden = false
        greatRating?.isHidden = false
    }
    
    private func hideRatingStuff() {
        tapLeft.isHidden = true
        tapRight.isHidden = true
        tapMid.isHidden = true
        tutorialLabel.isHidden = true
        wellKnownQuestion?.isHidden = true
        badRating?.isHidden = true
        okayRating?.isHidden = true
        greatRating?.isHidden = true
    }
    
    private func showRealDeckRatingStuff() {
        tapLeft.isHidden = true
        tapRight.isHidden = true
        tapMid.isHidden = true
        tutorialLabel.isHidden = true
        wellKnownQuestion?.isHidden = false
        badRating?.isHidden = false
        okayRating?.isHidden = false
        greatRating?.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDeckSegue" {
            if let editVC = segue.destination as? CreateDeckViewController {
                editVC.indexOfDeck = indexOfDeck
                editVC.userController = userController
                editVC.deckController = deckController
            }
        }
    }

}

