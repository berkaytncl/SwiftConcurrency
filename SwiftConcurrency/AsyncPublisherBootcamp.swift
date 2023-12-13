//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 13.12.2023.
//

import SwiftUI
//import Combine

actor AsyncPublisherBootcampDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(for: .seconds(2))
        myData.append("Banana")
        try? await Task.sleep(for: .seconds(2))
        myData.append("Orange")
        try? await Task.sleep(for: .seconds(2))
        myData.append("Watermelon")
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    private let manager = AsyncPublisherBootcampDataManager()
//    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            for await value in await manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
//        manager.$myData
//            .receive(on: DispatchQueue.main)
//            .sink { dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherBootcamp: View {
    
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
