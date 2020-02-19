//
//  HomeViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var deckCreateButton: UIButton!
    @IBOutlet private weak var deckTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        // Do any additional setup after loading the view.
    }

    private func setupOutlets() {
        segmentedControl.selectedSegmentTintColor = UIColor.mNeme.orangeBlaze
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
