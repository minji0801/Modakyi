//
//  UnusedViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  미사용 글귀 ViewController

import UIKit

final class UnusedViewController: UIViewController {
    let viewModel = UnusedViewModel()
    private lazy var theme = ThemeManager.currentTheme()
    private lazy var font = FontManager.currentFont()

    /// CollectionView RefershControl
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var notextLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.alpha = 0
        collectionview.refreshControl = refreshControl
        setupNoti()

        viewModel.getFullText()
        viewModel.getUnusedTextIDs { [weak self] bool in
            guard let self = self else { return }

            if bool {   // 미사용 글귀 있음
                DispatchQueue.main.async {
                    if self.viewModel.unusedTextIDs.isEmpty {
                        self.notextLabel.isHidden = false
                    } else {
                        self.notextLabel.isHidden = true
                    }
                    self.reloadCollectionView()
                }
            } else {    // 미사용 글귀 없음 -> 전체 글귀 보여주기
                DispatchQueue.main.async {
                    self.reloadCollectionView()
                }
            }
        }
    }

    /// 화면 보여질 때 마다: Appearance, Theme, Font 확인
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)

        theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.backgroundColor

        font = FontManager.currentFont()
        collectionview.reloadData()
    }

    /// Notification 설정
    func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.selectedUnusedTabNotification(_:)),
            name: NSNotification.Name("UnusedTabSelected"),
            object: nil
        )
    }

    /// CollectionView Reload
    func reloadCollectionView() {
        collectionview.reloadData()
        slowlyRemoveIndicator(indicatorView, collectionview)
    }
}

// MARK: - CollectionView DataSource
extension UnusedViewController: UICollectionViewDataSource {
    /// Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfUnusedText
    }

    /// Cell 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UnusedCollectionViewCell.identifier,
            for: indexPath
        ) as? UnusedCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.contentView.backgroundColor = theme.secondaryColor

        // 미사용 글귀 아이디 넘겨줘서 각 셀 textLabel에 글귀 뿌려주기
        cell.updateTextLabel(viewModel.unusedTextIDs.sorted(by: >), indexPath, font)
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
            withReuseIdentifier: UnusedCollectionHeaderView.identifier,
            for: indexPath
        ) as? UnusedCollectionHeaderView else {
            return UICollectionReusableView()
        }

        return header
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension UnusedViewController: UICollectionViewDelegateFlowLayout {
    /// Cell 클릭: 상세 화면 보여주기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailViewController(self, viewModel.unusedTextId(at: indexPath.row))
    }

    /// 스크롤 당기기: 새로고침
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
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
extension UnusedViewController {
    /// 미사용 탭 바 버튼 클릭된 후 Noti
    @objc func selectedUnusedTabNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self ] in
            guard let self = self else { return }

            self.collectionview.setContentOffset(.zero, animated: true)
        }
    }

    /// 새로고침
    @objc func refresh() {
        viewDidLoad()
    }
}
