//
//  HapticPencil_BridgeApp.swift
//  HapticPencil_Bridge
//
//  Created by Lucio Cuddeford on 09/07/2025.
//

import SwiftUI

@main
struct HapticPencil_BridgeApp: App {
    @StateObject private var hapticServer = HapticServer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(hapticServer)
        }
    }
}
