//
//  AsyncLetBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 24.11.2023.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    
    @State private var images: [UIImage] = []
    @State private var title = "Async Let Bootcamp 🥳"
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/300")!
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle(title)
            .onAppear {
                Task {
                    do {
//                        let image1 = try await fetchImage()
//                        images.append(image1)
//                        let image2 = try await fetchImage()
//                        images.append(image2)
//                        let image3 = try await fetchImage()
//                        images.append(image3)
//                        let image4 = try await fetchImage()
//                        images.append(image4)
                        
                        async let fetchImage1 = fetchImage()
                        async let fetchtitle1 = fetchTitle()
                        
                        let (image, title) = await (try fetchImage1, fetchtitle1)
                        images.append(image)
                        self.title = title
//                        async let fetchImage2 = fetchImage()
//                        async let fetchImage3 = fetchImage()
//                        async let fetchImage4 = fetchImage()
//                        
//                        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
//                        images.append(contentsOf: [image1, image2, image3, image4])
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "NEW TITLE"
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

#Preview {
    AsyncLetBootcamp()
}
