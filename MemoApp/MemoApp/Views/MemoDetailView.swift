//
//  MemoDetailView.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import SwiftUI

struct MemoDetailView: View {
    var memo: Memo

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let imageData = memo.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                }

                if let content = memo.content {
                    Text(content)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .presentationDetents([.medium, .large]) // 아래에서 시트가 올라오는데 끝까지 올릴 수도 있고 중간 부분까지만 올려도 됨
    }
}
