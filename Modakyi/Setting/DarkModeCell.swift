//
//  DarkModeCell.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/02.
//

import UIKit

class DarkModeCell: UITableViewCell {
    @IBOutlet weak var darkmodeSwitch: UISwitch!
    @IBOutlet weak var tableview: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.darkmodeSwitchConfigure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func darkmodeSwitchConfigure() {
        let appearance = UserDefaults.standard.string(forKey: "Appearance")
        if self.traitCollection.userInterfaceStyle == .dark || appearance == "Dark" {
            darkmodeSwitch.isOn = true
        } else if self.traitCollection.userInterfaceStyle == .light || appearance == "Light" {
            darkmodeSwitch.isOn = false
        }
    }
}
