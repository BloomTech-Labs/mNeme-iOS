//
//  HomeViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var deckCreateButton: UIButton!
    @IBOutlet private weak var deckTableView: UITableView!
    
    // MARK: Properties
    var demoDeckController: DemoDeckController?
//    var mockController = MockDemoDeckController()
    
//    var mockDeck: MockDemoDeck?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        deckTableView.delegate = self
        deckTableView.dataSource = self
        // Do any additional setup after loading the view.
//        mockDeck = mockController.decodeMockData(deckLength: .short)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        
        deckTableView.reloadData()
    }
    
    private func updateViews() {
        //view.backgroundColor = UIColor.mNeme.orangeBlaze
        setupOutlets()
    }
    
    private func setupOutlets() {
        // segmented control
        segmentedControl.selectedSegmentTintColor = UIColor.mNeme.orangeBlaze
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        // deck create button
        deckCreateButton.setTitleColor(UIColor.white, for: .normal)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeckSegue" {
            if let deckCardVC = segue.destination as? DeckCardViewController, let indexPath = deckTableView.indexPathForSelectedRow {
                deckCardVC.deck = demoDeckController?.demoDecks[indexPath.row]
            }
        }
        
        
        
     }
    
    // MARK: - TableView Functions
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoDeckController?.demoDecks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath) as? DeckTableViewCell else { return UITableViewCell() }
        
        cell.deck = demoDeckController?.demoDecks[indexPath.row]
        
        return cell
    }
    
    
    
}
