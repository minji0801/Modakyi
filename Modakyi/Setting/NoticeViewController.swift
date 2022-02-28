//
//  NoticeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/18.
//  공지사항 ViewController

import UIKit

final class NoticeViewController: UIViewController {
    @IBOutlet weak var noticeTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        noticeTextView.text = """
                           안녕하세요. <모닥이> 입니다.
                           1인 개발이라 혼자서 메일 답장, 글귀 업로드, 개발을 하고 있습니다.
                           다소 시간이 걸리는 점 양해 부탁드립니다.

                           *** [문의 및 의견] ***
                           문의사항이나 오타 발견 및 기타 의견은 [설정 - 문의 및 의견]을 통해 메일을 보내주시면 최대한 빠른 시일 내에 답장 드리겠습니다.

                           *** [1.4.1 버전 업데이트] ***
                           - 애플, 익명 로그인 시 로딩 단계가 추가되었습니다.
                           - UI(아이콘 이미지, 색상 등)가 변경되었습니다.
                           - 유지 보수를 위해 내부 구조가 변경되었습니다.(MVVM 리팩토링)


                           모닥이를 사용해주셔서 감사합니다 :)
                           """
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
