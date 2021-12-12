//
//  ShareViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/12/12.
//

import UIKit

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func textShareButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("TextShare"), object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func imageShareButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("ImageShare"), object: nil, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
}
