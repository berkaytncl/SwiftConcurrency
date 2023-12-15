//
//  PhotoPickerBootcamp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 15.12.2023.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                guard let data = try await selection.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                selectedImage = uiImage
            } catch {
                print(error)
            }
        }
    }
    
    private func setImages(from selections: [PhotosPickerItem]) {
        Task {
            do {
                for selection in selections {
                    guard let data = try await selection.loadTransferable(type: Data.self),
                          let uiImage = UIImage(data: data) else { return }
                    selectedImages.append(uiImage)
                }
            } catch {
                print(error)
            }
        }
    }
}

struct PhotoPickerBootcamp: View {
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Hello World!")
            
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            PhotosPicker(selection: $viewModel.imageSelection, matching: .any(of: [.images, .cinematicVideos])) {
                Text("Open the photo picker!")
                    .foregroundStyle(.red)
            }
            
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            
            PhotosPicker(selection: $viewModel.imageSelections, matching: .any(of: [.images, .cinematicVideos])) {
                Text("Open the photos picker!")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    PhotoPickerBootcamp()
}
