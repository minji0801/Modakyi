//
//  LikeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LikeViewController: UIViewController {
    var ref: DatabaseReference! = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid

    var likeTexts = [Int]()

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionview.alpha = 0

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.selectedLikeTabNotification(_:)),
            name: NSNotification.Name("LikeTabSelected"),
            object: nil
        )

        // User DB에서 현재 사용자가 좋아하는 글귀 데이터 읽어오기
        ref.child("User/\(uid!)/like").observe(.value) { snapshot in
            guard let value = snapshot.value as? [Int] else {
                // 좋아하는 글귀가 없으니까
                self.likeTexts = []
                DispatchQueue.main.async {
                    self.labelView.isHidden = false
                    self.collectionview.reloadData()
                    slowlyRemoveIndicator(self.indicatorView, self.collectionview)
                }
                return
            }

            self.likeTexts = value.reversed()
            print("Like 좋아하는 글귀 id: \(self.likeTexts)")

            DispatchQueue.main.async {
                self.labelView.isHidden = true
                self.collectionview.reloadData()
                slowlyRemoveIndicator(self.indicatorView, self.collectionview)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }

    // 화면 회전될 때
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resizeCells(self.collectionview)
    }

    @objc func selectedLikeTabNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.collectionview.setContentOffset(.zero, animated: true)
        }
    }
}

// MARK: - UICollectionView Configure

extension LikeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.likeTexts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "LikeCollectionViewCell",
            for: indexPath
        ) as? LikeCollectionViewCell else {
            return UICollectionViewCell()
        }

        // likeTest 넘겨서 각 셀에서 id 검색해서 textLabel에 글귀 뿌려주기
        cell.labelUpdateUI(likeTexts, indexPath)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "LikeCollectionHeaderView",
            for: indexPath
        ) as? LikeCollectionHeaderView else {
            return UICollectionReusableView()
        }

        return header
    }
}

extension LikeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailViewController(self, String(likeTexts[indexPath.row]))
    }
}

extension LikeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 0.8
        return CGSize(width: width, height: width)
    }
}
