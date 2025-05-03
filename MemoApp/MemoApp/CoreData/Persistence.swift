//
//  Persistence.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import CoreData

class PersistenceController {
    // 싱글톤
    static let shared = PersistenceController()
    // core data 저장소 컨테이너
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MemoApp")
        // 비동기로 core data 로딩
        Task {
            do {
                try await loadPersistentStoreAsync()
                print("CoreData 로딩 성공")
            } catch {
                fatalError("CoreData 로딩 실패: \(error)")
            }
        }
        // 메모 저장 작성 후 저장 -> 변경 사항이 생기면 자동으로 viewContext에 반영
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    // 비동기 async/await로 데이터가 오고 갈 때 안전하게 진행될 수 있도록 래핑
    private func loadPersistentStoreAsync() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
