//
//  CreateDeckScrollViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateDeckScrollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cards: [CardData] = []
    var deck: [Deck]?
    var deckController: DemoDeckController?
    
    @IBOutlet weak var deckNameTF: UITextField!
    @IBOutlet weak var deckIconTF: UITextField!
    @IBOutlet weak var deckTagsTF: UITextField!
    @IBOutlet weak var addFlashcardView: UIView!
    @IBOutlet weak var addFrontTF: UITextField!
    @IBOutlet weak var addBackTF: UITextField!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var saveDeckButton: UIButton!
    @IBOutlet weak var cardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cards = deck?.data
        cardTableView.reloadData()
    }
    
    @IBAction func addCardTapped(_ sender: UIButton) {
        guard let frontText = addFrontTF.text, !frontText.isEmpty, let backText = addBackTF.text, !backText.isEmpty else { return }
        
        if let deck = deck {
            
        } else {
            let cardInfo = CardData.CardInfo(archived: false, back: backText, front: frontText)
            let card = CardData(id: UUID().uuidString, data: cardInfo)
            cards.insert(card, at: 0)
            addFrontTF.text = ""
            addBackTF.text = ""
            cardTableView.reloadData()
        }
    }
    @IBAction func saveDeckTapped(_ sender: UIButton) {
        guard let deckName = deckNameTF.text, !deckName.isEmpty, let deckIcon = deckIconTF.text, !deckIcon.isEmpty, let name = Auth.auth().currentUser?.displayName else { return }
        guard cards.count > 0 else { return }
        
        if let deck = deck {
            
        } else {
            let deckInfo = DeckInformation(icon: deckIcon, tag: [deckTagsTF.text ?? ""], createdBy: name, exampleCard: cards[0].data.front, collectionId: UUID().uuidString, deckName: deckName, deckLength: cards.count)
            
            let savedDeck = Deck(deckInformation: deckInfo, data: cards)
            //createCardToServer(savedDeck)
            clearViews()
            tabBarController?.selectedIndex = 0
        }
    }
    
    private func clearViews() {
        cards = []
        deckTagsTF.text = ""
        deckNameTF.text = ""
        deckIconTF.text = ""
        addFrontTF.text = ""
        addBackTF.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        
        cell.frontLabel.text = cards[indexPath.row].data.front
        cell.backLabel.text = cards[indexPath.row].data.back
        
        return cell
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
