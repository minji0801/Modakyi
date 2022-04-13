//
//  NoticeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/18.
//  공지사항 ViewController

import UIKit

final class NoticeViewController: UIViewController {
    private let font = FontManager.currentFont()
    @IBOutlet weak var noticeTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceCheck(self)
        navigationController?.navigationBar.isHidden = true

        // 아이패드는 글자 크기 크게
        if UIDevice.current.model == "iPad" {
            noticeTextView.font = font.iPadMediumFont
        } else {
            noticeTextView.font = font.iPhoneMediumFont
        }

        noticeTextView.text = """
                           안녕하세요. <모닥이> 입니다.
                           혼자서 메일 답장과 글귀 업로드, 그리고 개발을 하고 있습니다. 다소 시간이 걸리더라도 양해 부탁드립니다 :)

                           *** [문의 및 의견] ***
                           불편한 점이나 개선되었으면 하는 점이 있으시면 [설정 - 문의 및 의견]을 통해 알려주세요.
                           최대한 빠른 시일 내에 답장 드리겠습니다.

                           *** [앱 평가] ***
                           앱스토어에 별점을 남겨주세요. 좋은 평가와 리뷰는 개발자에게 힘이 됩니다.

                           *** [1.5.1 버전 업데이트] ***
                           - 글귀 확인 후 나타나는 전면광고를 삭제했습니다. 이용에 불편을 드려 죄송합니다.

                           모닥이를 사용해주셔서 감사합니다 :)
                           """
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
