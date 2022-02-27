//
//  LikeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  좋아하는 글귀 ViewController

import UIKit

final class LikeViewController: UIViewController {
    let viewModel = LikeViewModel()

    /// CollectionView RefreshControl
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.alpha = 0
        collectionview.refreshControl = refreshControl
        setupNoti()

        viewModel.getLikeTextIDs { [weak self] bool in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.labelView.isHidden = bool
                self.collectionview.reloadData()
                slowlyRemoveIndicator(self.indicatorView, self.collectionview)
            }
        }
    }

    /// 화면 보여질 때마다: 다크모드 체크
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }

    /// 화면 회전될 때: CollectionView Cell 크기 재설정
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resizeCells(self.collectionview)
    }

    /// Notification 설정
    private func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.selectedLikeTabNotification(_:)),
            name: NSNotification.Name("LikeTabSelected"),
            object: nil
        )
    }
}

// MARK: - CollectionView DataSource
extension LikeViewController: UICollectionViewDataSource {
    ///  Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfLikeText
    }

    /// Cell 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LikeCollectionViewCell.identifier,
            for: indexPath
        ) as? LikeCollectionViewCell else {
            return UICollectionViewCell()
        }

        // 좋아하는 글귀 아이디 넘겨줘서 각 셀 textLabel에 글귀 뿌려주기
        cell.updateTextLabel(viewModel.likeTextIDs, indexPath)
        return cell
    }

    /// Header 구성
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: LikeCollectionHeaderView.identifier,
            for: indexPath
        ) as? LikeCollectionHeaderView else {
            return UICollectionReusableView()
        }

        return header
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension LikeViewController: UICollectionViewDelegateFlowLayout {
    /// Cell 클릭: 상세 화면으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailViewController(self, viewModel.likeTextId(at: indexPath.row))
    }

    /// 스크롤 당기기: 새로고침
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }

    /// Cell 크기
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 0.8
        return CGSize(width: width, height: width)
    }
}

// MARK: - @objc Function
extension LikeViewController {
    /// 하트 탭 버튼 클릭된 후 Noti
    @objc func selectedLikeTabNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self ] in
            guard let self = self else { return }

            self.collectionview.setContentOffset(.zero, animated: true)
        }
    }

    /// 새로고침
    @objc func refresh() {
        self.viewDidLoad()
    }
}
