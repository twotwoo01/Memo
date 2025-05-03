//
//  RegisterView.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var registerVM = RegisterViewModel()

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("회원가입").font(.title.bold())

            TextField("이메일", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            SecureField("비밀번호", text: $password)
                .textFieldStyle(.roundedBorder)

            if !registerVM.errorMessage.isEmpty {
                Text(registerVM.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("가입하기") {
                Task {
                    await registerVM.register(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)

        }
        .padding()
        .onChange(of: registerVM.registerLogin) {
            if registerVM.registerLogin {
                dismiss()
            }
        }
    }
}

#Preview {
    RegisterView()
}
