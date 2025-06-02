import SwiftUI
import FamilyControls
import ManagedSettings

struct AppPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var mode: BlockingMode
    @State private var selection = FamilyActivitySelection()
    var onModeUpdated: (BlockingMode) -> Void
    
    init(mode: BlockingMode, onModeUpdated: @escaping (BlockingMode) -> Void) {
        _mode = State(initialValue: mode)
        self.onModeUpdated = onModeUpdated
    }
    
    var body: some View {
        NavigationView {
            VStack {
                FamilyActivityPicker(selection: $selection)
                    .onChange(of: selection) { newSelection in
                        // Store the application tokens directly
                        let selectedApps = newSelection.applicationTokens.map { token in
                            String(describing: token)
                        }
                        mode.blockedApps = Set(selectedApps)
                        onModeUpdated(mode)
                    }
            }
            .navigationBarItems(trailing: Button("Done") {
                onModeUpdated(mode)
                dismiss()
            })
        }
    }
}

#Preview {
    AppPickerView(mode: BlockingMode(name: "Test")) { _ in }
} 
