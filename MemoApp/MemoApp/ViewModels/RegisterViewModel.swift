//
//  RegisterViewModel.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import Foundation
import CoreData

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var registerLogin = false // 회원가입 여부
    @Published var errorMessage = ""

    let context = PersistenceController.shared.container.viewContext

    func register(email: String, password: String) async {
        guard !email.isEmpty else { // 이메일 입력창이 비어있을 때
            errorMessage = "이메일을 입력해주세요"
            return
        }
        // 이메일 형식이 올바르지 않을 때
        guard emailCheck(email) else {
            errorMessage = "이메일 형식이 유효하지 않습니다"
            return
        }

        guard !password.isEmpty else {
            errorMessage = "비밀번호를 입력해주세요"
            return
        }
        // 가입되어 있는 이메일인지 확인
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let existingUsers = try context.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                errorMessage = "이미 가입된 이메일입니다"
                return
            }
            // 없다면 새로운 사용자로 가입
            let newUser = User(context: context)
            newUser.email = email
            newUser.password = password

            try context.save()
            registerLogin = true
            print("회원가입 성공. ID: \(email)")
        } catch {
            errorMessage = "회원가입 실패: \(error.localizedDescription)"
        }
    }
    // 정규표현식으로 이메일 형식이 맞는지 확인
    private func emailCheck(_ str: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
}
