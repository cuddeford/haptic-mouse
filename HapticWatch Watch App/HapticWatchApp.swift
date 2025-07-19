//
//  HapticWatchApp.swift
//  HapticWatch Watch App
//
//  Created by Lucio Cuddeford on 10/07/2025.
//

import SwiftUI

@main
struct HapticWatch_Watch_AppApp: App {
    @StateObject var connectivityManager = ConnectivityManager.shared
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
