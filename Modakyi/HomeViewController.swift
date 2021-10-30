//
//  HomeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
