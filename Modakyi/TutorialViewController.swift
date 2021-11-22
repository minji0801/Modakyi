//
//  TutorialViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/22.
//

import UIKit

class TutorialViewController: UIViewController {
    let tutorial = UserDefaults.standard.bool(forKey: "Tutorial")
    let images = ["page0", "page1", "page2", "page3", "page4", "page0"]
    let texts = [
        """
        모닥불 앞에 있으면
        몸이 따뜻해지듯이,
        
        모닥이가 당신의 마음을
        따뜻하게 어루만 주어 주길.
        """,
        """
        홈에서 추천 글귀와
        전체 글귀를 만날 수 있어요.
        
        새로 추가된 글귀에는
        빨간 점이 표시돼요.
        """,
        """
        자세히 보고싶은 글귀는 클릭해보세요.
        
        글귀가 마음에 든다면 ❤️ 를,
        다이어리나 플래너에 실제
        사용했다면 ✅ 를 클릭하세요.
        """,
        """
        * 페이지 설명 *
        
        🧡 - 좋아하는 글귀 모음
        📁 - 실제 사용한 적 없는 글귀 모음
        🔍 - 글귀 검색
        """,
        """
        모닥이는 다크모드도 지원합니다.
        
        설정을 통해 위의 기능을
        관리 및 이용하실 수 있습니다.
        """,
        """
        모닥이와 따뜻한 하루가 되길.
        
        
        
        
        """
    ]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        imageView.image = UIImage(named: images[0])
        label.text = texts[0]
        
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
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        // UserDefault 값 바꾸고 Loagin으로 이동
        UserDefaults.standard.set(true, forKey: "Tutorial")
        showLoginVCOnRoot()
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
        
        if pageControl.currentPage == 5 && !self.tutorial {
            startButton.isHidden = false
        } else {
            startButton.isHidden = true
        }
    }
}
