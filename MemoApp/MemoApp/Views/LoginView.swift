//
//  LoginView.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @AppStorage("isLogin") private var isLogin = false

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorText = false

    var body: some View {
        NavigationStack {
            if isLogin {
                HomeView()
            } else {
                VStack(spacing: 20) {
                    Text("MemoTrip")
                        .font(.largeTitle.bold())

                    TextField("이메일", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)

                    SecureField("비밀번호", text: $password)
                        .textFieldStyle(.roundedBorder)

                    if !loginVM.errorMessage.isEmpty {
                        Text(loginVM.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button("로그인") {
                        Task {
                            await loginVM.login(email: email, password: password)
                            if loginVM.login {
                                isLogin = true
                            } else {
                                errorText = true
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    NavigationLink("회원가입", destination: RegisterView())
                        .font(.caption)
                }
                .padding()
            }
        }
    }
}
#Preview {
    LoginView()
}
