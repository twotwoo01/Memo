//
//  MemoWriteViewModel.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreData

@MainActor
class MemoWriteViewModel: ObservableObject {
    @Published var content: String = ""
    @Published var selectedImage: PhotosPickerItem? = nil // 사용자가 선택한 이미지
    @Published var imageData: Data? = nil // 사용자가 선택한 실제 이미지 데이터

    // 사용자가 사진을 선택하고 해당 이미지를 data 형식으로 가져와서 저장
    func imageSelection(_ newItem: PhotosPickerItem?) async {
        if let data = try? await newItem?.loadTransferable(type: Data.self) { // 비동기로 이미지 데이터를 가져옴
            await MainActor.run {
                self.imageData = data
            }
        }
    }
    // 메모 데이터를 core data에 저장
    func saveMemo(context: NSManagedObjectContext, dismiss: DismissAction) {
        let newMemo = Memo(context: context)
        newMemo.id = UUID()
        newMemo.date = Date()
        newMemo.content = content
        newMemo.image = imageData

        do {
            try context.save()
            dismiss()
        } catch {
            print("메모 저장 실패: \(error.localizedDescription)")
        }
    }
}
