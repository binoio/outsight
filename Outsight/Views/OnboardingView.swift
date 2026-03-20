import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var permissionsManager: PermissionsManager
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "record.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            VStack(spacing: 15) {
                Text("Welcome to Outsight")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("To provide live screen capture, Outsight requires Screen Recording permissions.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 12) {
                Button(action: {
                    permissionsManager.requestScreenRecordingPermission()
                }) {
                    Text("Grant Screen Recording Access")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .frame(width: 300)
            
            Text("Once granted, the app will automatically continue.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 500, height: 500)
        .background(VisualEffectView().ignoresSafeArea())
    }
}

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
