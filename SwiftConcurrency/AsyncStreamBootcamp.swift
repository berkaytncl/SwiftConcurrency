//
//  AsyncStreamBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 16.12.2023.
//

import SwiftUI

class AsyncStreamDataManager {
    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream { [weak self] continuation in
            self?.getFakeData(newValue: { value in
                continuation.yield(value)
            }, onFinish: { error in
                continuation.finish(throwing: error)
            })
        }
    }
    
    func getFakeData(
        newValue: @escaping (_ value: Int) -> (),
        onFinish: @escaping (_ error: Error?) -> ()
    ) {
        let items: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item)) {
                newValue(item)
                if item == items.last { onFinish(nil) }
            }
        }
    }
}

@MainActor
final class AsyncStreamViewModel: ObservableObject {
    
    private let manager = AsyncStreamDataManager()
    @Published private(set) var currentNumber: Int = 0
    
    func onViewAppear() {
//        manager.getFakeData(completion: { [weak self] value in
//            self?.currentNumber = value
//        })
        let task = Task {
            do {
                for try await value in manager.getAsyncStream() {
                    currentNumber = value
                }
            } catch {
                print(error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            task.cancel()
        })
    }
}

struct AsyncStreamBootcamp: View {
    
    @StateObject private var viewModel = AsyncStreamViewModel()
    
    var body: some View {
        Text(viewModel.currentNumber.description)
            .onAppear(perform: {
                viewModel.onViewAppear()
            })
    }
}

#Preview {
    AsyncStreamBootcamp()
}
