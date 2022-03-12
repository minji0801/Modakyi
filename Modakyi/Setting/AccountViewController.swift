//
//  AccountViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2022/03/12.
//  계정 정보 Viewcontroller

import UIKit
import FirebaseAuth

final class AccountViewController: UIViewController {
    private let viewModel = SettingViewModel()
    private let uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        profileImage.kf.setImage(
            with: viewModel.getUserPhotoUrl(),
            placeholder: UIImage(named: "person_circle")
        )
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        nameTextField.text = viewModel.getUserDisplayName()
        emailTextField.text = viewModel.getUserEmail()
        loginTextField.text = viewModel.getUserProviderID()
    }

    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
