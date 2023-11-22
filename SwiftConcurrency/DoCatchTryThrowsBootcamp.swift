//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 22.11.2023.
//

import SwiftUI

// do-catch
// try
// throws

final class DoCatchTryThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT!"
        } else {
            throw URLError(.badURL)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!"
        } else {
            throw URLError(.badURL)
        }
    }
}

final class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            text = newTitle
        } else if let error = returnedValue.error {
            text = error.localizedDescription
        }
        */
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            text = newTitle
        case .failure(let error):
            text = error.localizedDescription
        }
        */
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle {
                text = newTitle
            }
            
            let finalTitle = try manager.getTitle4()
            text = finalTitle
        } catch {
            text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
