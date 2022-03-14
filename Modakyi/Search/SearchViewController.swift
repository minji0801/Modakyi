//
//  SearchViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  검색 ViewController

import UIKit

final class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    private lazy var theme = ThemeManager.currentTheme()
    private lazy var font = FontManager.currentFont()

    /// SearchBar
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self

        return searchBar
    }()

    /// CollectionView RefreshControl
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var labelView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.refreshControl = refreshControl
        setupNoti()
        getFullText()
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
            selector: #selector(self.selectedSearchTabNotification(_:)),
            name: NSNotification.Name("SearchTabSelected"),
            object: nil
        )
    }

    /// 전제 글귀 가져오기
    func getFullText() {
        viewModel.getFullText {
            DispatchQueue.main.async { [weak self ] in
                guard let self = self else { return }

                self.collectionview.reloadData()
            }
        }
    }
}

// MARK: - CollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {

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
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.contentView.backgroundColor = theme.secondaryColor
        cell.textLabel.font = font.iPhoneSmallFont

        let text = viewModel.textInfo(at: indexPath.row)
        cell.updateTextLabel(text)
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
            withReuseIdentifier: SearchCollectionHeaderView.identifier,
            for: indexPath
        ) as? SearchCollectionHeaderView else {
            return UICollectionReusableView()
        }

        header.searchBar = searchBar
        return header
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {

    /// Cell 클릭: 상세 화면 보여주기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {

    /// 키보드 내리기
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    /// 취소버튼 눌렀을 때
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !self.labelView.isHidden {
            self.labelView.isHidden = true
        }

        searchBar.showsCancelButton = false
        dismissKeyboard()
        getFullText()
    }

    /// 검색창 눌렀을 때
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.setShowsCancelButton(true, animated: true)
    }

    /// 검색버튼 눌렀을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let searchWord = searchBar.text, searchWord.isEmpty == false else { return }
        print("검색어: \(searchWord)")

        viewModel.search(searchWord) {
            DispatchQueue.main.async { [weak self ] in
                guard let self = self else { return }

                if self.viewModel.fullText.isEmpty {
                    self.labelView.isHidden = false
                } else {
                    self.labelView.isHidden = true
                }
                self.collectionview.reloadData()
            }
        }
    }
}

// MARK: - @objc Function
extension SearchViewController {

    /// 탭 바 버튼 클릭된 후 Noti
    @objc func selectedSearchTabNotification(_ notification: Notification) {
        DispatchQueue.main.async { [weak self ] in
            guard let self = self else { return }

            self.collectionview.setContentOffset(.zero, animated: true)
        }
    }

    /// 새로고침
    @objc func refresh() {
        self.searchBar.text = ""
        self.viewDidLoad()
    }
}
