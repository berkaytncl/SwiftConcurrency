//
//  GlobalActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 12.12.2023.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
    
}

final actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five", "Six"]
    }
}

//@MainActor
final class GlobalActorBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
//    @Published var dataArray1: [String] = []
    let manager = MyFirstGlobalActor.shared
    
//    nonisolated
    @MyFirstGlobalActor func getData() {
        
        // HEAVY COMPLEX METHODS
        
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
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
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
