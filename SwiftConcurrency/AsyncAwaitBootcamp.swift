//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 24.11.2023.
//

import SwiftUI

final class AsyncAwaitBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            let title = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                let title3 = "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author1)
        }
        
        try? await Task.sleep(for: .seconds(2))
        
        let author2 = "Author2 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)
            
            let author3 = "Author3 : \(Thread.current)"
            self.dataArray.append(author3)
        }
        
//        await addSomething()
    }
    
    func addSomething() async {
        try? await Task.sleep(for: .seconds(2))
        let something1 = "something1 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(something1)
            
            let something2 = "something2 : \(Thread.current)"
            self.dataArray.append(something2)
        }
    }
}

struct AsyncAwaitBootcamp: View {
    
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            Task {
                await viewModel.addAuthor1()
                await viewModel.addSomething()
                
                let finalText = "FINAL TEXT: \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
