//
//  SwiftConcurrencyApp.swift
//  SwiftConcurrency
//
//  Created by Berkay Tuncel on 22.11.2023.
//

import SwiftUI

@main
struct SwiftConcurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            DownloadImageAsync()
        }
    }
}
