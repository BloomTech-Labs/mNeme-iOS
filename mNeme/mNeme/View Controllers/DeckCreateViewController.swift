//
//  DeckCreateViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DeckCreateViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var topView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        topView.backgroundColor = UIColor.mNeme.orangeBlaze
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
