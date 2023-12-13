//
//  ReferencesBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 13.12.2023.
//

import SwiftUI

final class ReferencesBootcampDataService {
    
    func getData() async -> String {
        try? await Task.sleep(for: .seconds(2))
        return "Updated data"
    }
}

final class ReferencesBootcampViewModel: ObservableObject {
    
    @Published var data: String = "Some title!"
    private let dataService = ReferencesBootcampDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach({ $0.cancel() })
        myTasks = []
    }
    
    // This implies a strong reference...
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This is a strong reference...
    func updateData2() {
        Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a strong reference...
    func updateData3() {
        Task { [self] in
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a weak reference...
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak/strong
    // We can manage the task!
    func updateData5() {
        someTask = Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // We can manage the task!
    func updateData6() {
        let task1 = Task {
            self.data = await self.dataService.getData()
        }
        
        let task2 = Task {
            self.data = await self.dataService.getData()
        }
        
        myTasks.append(contentsOf: [task1, task2])
    }
    
    // We purposely do not cancel tasks to keep strong references
    func updateData7() {
        Task {
            self.data = await self.dataService.getData()
        }
        
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
}

struct ReferencesBootcamp: View {
    
    @StateObject private var viewModel = ReferencesBootcampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
    }
}

#Preview {
    ReferencesBootcamp()
}
