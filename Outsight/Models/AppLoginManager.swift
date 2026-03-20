import Foundation
import ServiceManagement

class AppLoginManager: ObservableObject {
    static let shared = AppLoginManager()
    
    @Published var isEnabled: Bool {
        didSet {
            updateLoginItem()
        }
    }
    
    private init() {
        self.isEnabled = SMAppService.mainApp.status == .enabled
    }
    
    func updateLoginItem() {
        let service = SMAppService.mainApp
        
        if isEnabled {
            if service.status != .enabled {
                do {
                    try service.register()
                } catch {
                    print("Failed to register login item: \(error)")
                }
            }
        } else {
            if service.status == .enabled {
                service.unregister { error in
                    if let error = error {
                        print("Failed to unregister login item: \(error)")
                    }
                }
            }
        }
    }
}
