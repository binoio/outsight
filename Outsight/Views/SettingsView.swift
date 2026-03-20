import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Permissions") {
                HStack {
                    Text("Screen Recording Permission")
                    Spacer()
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                }
                
                Button("Reset Permissions") {
                    // Action to reset permissions
                }
            }
        }
        .padding()
        .frame(width: 350)
    }
}
