//
//  ActorsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 11.12.2023.
//

import SwiftUI

class MyDataManager {
    
    static let instance = MyDataManager()
    
    private init() {}
    
    var data: [String] = []
    private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    
    private init() {}
    
    var data: [String] = []
    
    nonisolated let myRandomText = "123"
    
    func getRandomData() -> String? {
        data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "NEW DATA"
    }
}

struct HomeView: View {
    
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear(perform: {
            _ = manager.getSavedData()
            _ = manager.myRandomText
        })
        .onReceive(timer, perform: { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    guard let title else { return }
//                    DispatchQueue.main.async {
//                        self.text = title
//                    }
//                }
//            }
        })
    }
}

struct BrowseView: View {
    
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()

            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    guard let title else { return }
//                    DispatchQueue.main.async {
//                        self.text = title
//                    }
//                }
//            }
        })
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
