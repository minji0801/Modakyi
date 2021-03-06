//
//  TutorialViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/22.
//  튜토리얼 ViewController

import UIKit

final class TutorialViewController: UIViewController {
    let viewModel = TutorialViewModel()
    private let font = FontManager.currentFont()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupSwipeGesture()

        pageControl.numberOfPages = viewModel.images.count
        pageControl.currentPage = 0

        imageView.image = UIImage(named: viewModel.images[0])
        label.text = viewModel.texts[0]

        // 아이패드는 글자 크기 크게
        if UIDevice.current.model == "iPad" {
            label.font = font.iPadLargeFont
        } else {
            label.font = font.iPhoneLargeFont
        }
    }

    /// 화면 보여질 때마다: 다크모드 확인
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        // UserDefault 값 바꾸고 Dismiss
        UserDefaults.standard.set(true, forKey: "Tutorial")
        dismiss(animated: false)
    }

    /// 스와이프 제스처 설정
    func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
    }

    /// 페이지 바뀔 때: 해당 이미지와 텍스트로 변경
    func pageChange() {
        imageView.image = UIImage(named: viewModel.images[pageControl.currentPage])
        label.text = viewModel.texts[pageControl.currentPage]
    }
}

// MARK: - @objc Function
extension TutorialViewController {
    /// 스와이프 제스처 후
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if pageControl.currentPage != 5 {
                    pageControl.currentPage += 1
                }
                pageChange()
            case UISwipeGestureRecognizer.Direction.right :
                if pageControl.currentPage != 0 {
                    pageControl.currentPage -= 1
                }
                pageChange()
            default:
                break
            }
        }
    }
}
