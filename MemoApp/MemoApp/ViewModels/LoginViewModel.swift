//
//  LoginViewModel.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import Foundation
import CoreData

@MainActor // 메인 스레드에서 실행될 수 있도록 설정
class LoginViewModel: ObservableObject {
    @Published var login = false // 로그인 여부
    @Published var errorMessage: String = ""

    // core data에 접근하기 위한 컨텍스트
    let context = PersistenceController.shared.container.viewContext

    // email과 password를 받아서 비동기로 로그인 처리
    func login(email: String, password: String) async {
        let request = User.fetchRequest() // core data에서 user 데이터를 불러오고
        request.predicate = NSPredicate(format: "email == %@", email) // 이메일 일치하는 사용자만 필터링

        do {
            let users = try context.fetch(request) // core data에서 사용자 데이터가 있는지 검색 후 가져옴
            if let user = users.first {
                if user.password == password { // 비밀번호 일치
                    login = true
                    errorMessage = ""
                    print("로그인 성공")
                } else { // 비밀번호 불일치
                    login = false
                    errorMessage = "비밀번호가 틀렸습니다. 비밀번호를 다시 확인해주세요."
                }
            } else { // 가입되어 있는 이메일이 존재 x
                login = false
                errorMessage = "가입되지 않은 계정입니다. 회원가입 후 이용해주세요."
            }
        } catch {
            login = false
            errorMessage = "로그인 중 오류가 발생했습니다."
        }
    }
}
