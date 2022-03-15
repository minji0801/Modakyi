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
        navigationController?.navigationBar.isHidden = true

        // 아이패드는 글자 크기 크게
        if UIDevice.current.model == "iPad" {
            noticeTextView.font = font.iPadMediumFont
        } else {
            noticeTextView.font = font.iPhoneMediumFont
        }

        noticeTextView.text = """
                           안녕하세요. <모닥이> 입니다.
                           1인 개발이라 혼자서 메일 답장, 글귀 업로드, 개발을 하고 있습니다.
                           다소 시간이 걸리는 점 양해 부탁드립니다.

                           *** [문의 및 의견] ***
                           문의사항이나 오타 발견 및 기타 의견은 [설정 - 문의 및 의견]을 통해 메일을 보내주시면 최대한 빠른 시일 내에 답장 드리겠습니다.

                           *** [1.4.1 버전 업데이트] ***
                           - 애플 로그인과 익명 로그인에 로딩 단계가 추가되었습니다.
                           - UI(아이콘 이미지, 색상 등)가 변경되었습니다.
                           - 다크모드 관련 오류를 수정했습니다.
                           - iPad에서 오류 해결을 위해 화면 회전을 고정했습니다.
                           - 유지 보수를 위해 내부 구조가 변경되었습니다.(MVVM)


                           모닥이를 사용해주셔서 감사합니다 :)
                           """
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
