//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 24.11.2023.
//

import SwiftUI

final class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(for: .seconds(5))
        
//        for x in array {
//            // work
//            
//            try Task.checkCancellation()
//        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY!")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click me!", destination: TaskBootcamp())
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
////            Task {
////                print(Thread.current)
////                print(Task.currentPriority)
////                await viewModel.fetchImage2()
////            }
////            Task(priority: .high) {
//////                try? await Task.sleep(for: .seconds(2))
////                await Task.yield()
////                print("high : \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .userInitiated) {
////                print("userInitiated : \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .medium) {
////                print("medium : \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .low) {
////                print("low : \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .utility) {
////                print("utility : \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .background) {
////                print("background : \(Thread.current) : \(Task.currentPriority.rawValue)")
////            }
////            Task(priority: .low) {
////                print("low : \(Thread.current) : \(Task.currentPriority.rawValue)")
////
////                Task.detached {
////                    print("detached : \(Thread.current) : \(Task.currentPriority.rawValue)")
////                }
////            }
//        }
//        .onDisappear() {
//            fetchImageTask?.cancel()
//        }
    }
}

#Preview {
    TaskBootcamp()
}
