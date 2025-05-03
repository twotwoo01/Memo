//
//  MemoWriteView.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import SwiftUI
import PhotosUI

struct MemoWriteView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var memoWriteVM = MemoWriteViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    let imageData = memoWriteVM.imageData
                    PhotosPicker(selection: $memoWriteVM.selectedImage, matching: .images) {
                        ZStack {
                            if let imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 250)
                                    .clipped()
                                    .cornerRadius(12)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 250)
                                    .overlay(Text("사진 선택").foregroundColor(.gray))
                            }
                        }
                    }
                    TextEditor(text: $memoWriteVM.content)
                        .frame(height: 300)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                    Button("저장") {
                        memoWriteVM.saveMemo(context: viewContext, dismiss: dismiss)
                    }
                    .disabled(memoWriteVM.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("메모 작성")
            .onChange(of: memoWriteVM.selectedImage) { _, newItem in
                Task {
                    await memoWriteVM.imageSelection(newItem)
                }
            }
        }
    }
}

#Preview {
    MemoWriteView()
}
