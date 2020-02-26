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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        deckTableView.delegate = self
        deckTableView.dataSource = self
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TableView Functions


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath)
        
        cell.textLabel?.text = "Demo Deck"
        
        return cell
    }
    
    

}
