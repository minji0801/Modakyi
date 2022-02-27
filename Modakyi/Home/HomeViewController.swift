//
//  HomeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/10/30.
//  홈 ViewController: UI 담당

import UIKit

final class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()

    /// CollectionView RefreshControl
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.alpha = 0
        collectionview.refreshControl = refreshControl
        setupNoti()

        // 데이터 가져오기(전체 글귀, 추천 글귀 아이디, 새 글귀 아이디, 클릭한 글귀 아이디)
        viewModel.getClickedTextId()
        viewModel.getFullText {
            DispatchQueue.main.async { [weak self ] in
                guard let self = self else { return }

                self.collectionview.reloadData()
                slowlyRemoveIndicator(self.indicatorView, self.collectionview)
            }
        }
    }

    /// 화면 보여질 때마다: 다크모드 체크하기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }

    /// 화면 회전될 때: Cell 크기 재설정
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resizeCells(collectionview)
    }

    /// 추천 글귀 클릭: 상세 화면 보여주기
    @IBAction func recommendViewTapped(_ sender: UITapGestureRecognizer) {
        presentDetailViewController(self, viewModel.recommendedTextId)
    }

    /// Notification 설정
    private func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDismissDetailNotification(_:)),
            name: NSNotification.Name("DismissDetailView"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedHomeTabNotification(_:)),
            name: NSNotification.Name("HomeTabSelected"),
            object: nil
        )
    }

    /// Collection View Reload
    private func reloadCollectionView() {
        DispatchQueue.main.async { [weak self ] in
            guard let self = self else { return }

            self.collectionview.reloadData()
        }
    }
}

// MARK: - CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    /// Cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfFullText
    }

    /// Cell 구성
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCollectionViewCell.identifier,
            for: indexPath
        ) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }

        let text = viewModel.textInfo(at: indexPath.row)
        cell.updateTextLabel(text)
        cell.updateNewImage(
            newTextIds: viewModel.newTextIDs,
            clicekdTextIds: viewModel.clickedTextIDs,
            textId: viewModel.numOfFullText - (indexPath.row + 1)
        )
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
            withReuseIdentifier: HomeCollectionHeaderView.identifier,
            for: indexPath
        ) as? HomeCollectionHeaderView else {
            return UICollectionReusableView()
        }

        header.recommendView.layer.cornerRadius = 30
        header.updateTextLabel(viewModel.recommendedTextId)
        header.settingButton.addTarget(self, action: #selector(settingButtonTapped(_:)), for: .touchUpInside)
        return header
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    /// Cell 클릭: 상세 화면으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.updateClickedText(at: indexPath.row)
        presentDetailViewController(self, viewModel.textInfo(at: indexPath.row).id)
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
extension HomeViewController {
    /// 상세화면 dismiss 된 후 Noti
    @objc func didDismissDetailNotification(_ notification: Notification) {
        reloadCollectionView()
    }

    /// 홈 탭 버튼 클릭 된 후 Noti
    @objc func selectedHomeTabNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self ] in
            guard let self = self else { return }

            self.collectionview.setContentOffset(.zero, animated: true)
        }
    }

    /// 설정 버튼 클릭: 설정화면 push
    @objc func settingButtonTapped(_ sender: UIButton) {
        pushSettingVCOnNavigation(self)
    }

    /// 추천 글귀 새로고침
    @objc func refresh() {
        viewModel.recommendedTextId = viewModel.fullText.randomElement()!.id
        reloadCollectionView()
    }
}
