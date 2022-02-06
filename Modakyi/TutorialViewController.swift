//
//  TutorialViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/22.
//

import UIKit

class TutorialViewController: UIViewController {
//    let tutorial = UserDefaults.standard.bool(forKey: "Tutorial")
    let images = ["page0", "page1", "page2", "page3", "page4", "page5"]
    let texts = [
        """
        홈에서 추천 글귀와
        전체 글귀를 만날 수 있어요
        """,
        """
        글귀의 좋아요, 사용여부를
        체크하고 공유할 수 있어요
        """,
        """
        좋아하는 글귀만
        모아볼 수 있어요
        """,
        """
        사용하지 않은 글귀만
        모아볼 수 있어요
        """,
        """
        찾고 싶은 글귀는
        검색해보세요
        """,
        """
        설정을 통해 앱을
        관리할 수 있어요
        """
    ]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        imageView.image = UIImage(named: images[0])
        label.text = texts[0]
        label.textColor = .white
        
        // iPad Font
        if UIDevice.current.model == "iPad" {
            self.label.font = UIFont(name: "EliceDigitalBaeum", size: 40.0)
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        self.pageChange()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        // UserDefault 값 바꾸고 Dismiss
        UserDefaults.standard.set(true, forKey: "Tutorial")
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if pageControl.currentPage != 5 {
                    pageControl.currentPage += 1
                }
                self.pageChange()
            case UISwipeGestureRecognizer.Direction.right :
                if pageControl.currentPage != 0 {
                    pageControl.currentPage -= 1
                }
                self.pageChange()
            default:
                break
            }
        }
    }
    
    func pageChange() {
        imageView.image = UIImage(named: images[pageControl.currentPage])
        label.text = texts[pageControl.currentPage]
    }
}
