//
//  HomeView.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//
import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext // core data에서 메모 데이터를 가져옴
    @FetchRequest( // 메모 데이터를 최신순으로 정렬해서 가져옴
        sortDescriptors: [NSSortDescriptor(keyPath: \Memo.date, ascending: false)],
        animation: .default
    )
    private var memos: FetchedResults<Memo>

    @State private var selectedMemo: Memo?
    @State private var showingWriteView = false
    @State private var pencilTapped = false

    let columns = [ // 메모 그리드를 2열로
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(memos) { memo in
                            ZStack(alignment: .bottomLeading) {
                                if let imageData = memo.image,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 180)
                                        .clipped()
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 180)
                                }

                                if let content = memo.content {
                                    Text(content)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .padding(8)
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(8)
                                        .padding(8)
                                }
                            }
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .onTapGesture {
                                selectedMemo = memo
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    deleteMemo(memo)
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                pencilTapped = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                pencilTapped = false
                                showingWriteView = true
                            }
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .offset(x:-20, y:-30)
                                .frame(width: pencilTapped ? 70 : 60, height: pencilTapped ? 70 : 60)
                                .foregroundColor(.accentColor)
                                .padding()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingWriteView) {
                MemoWriteView()
            }
            .sheet(item: $selectedMemo) { memo in
                MemoDetailView(memo: memo)
            }
            .navigationTitle("메모")
        }
    }
    // 메모 삭제
    private func deleteMemo(_ memo: Memo) {
        viewContext.delete(memo)
        do {
            try viewContext.save()
        } catch {
            print("삭제 실패: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
