import SwiftUI

struct AppPickerView: View {
    let mockApps = ["Instagram", "TikTok", "YouTube", "Snapchat", "Twitter", "Facebook", "Games"]
    @State private var mode: BlockingMode
    var onModeUpdated: (BlockingMode) -> Void
    
    init(mode: BlockingMode, onModeUpdated: @escaping (BlockingMode) -> Void) {
        _mode = State(initialValue: mode)
        self.onModeUpdated = onModeUpdated
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select Apps to Block")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                Text("Choose which apps to block in \(mode.name) mode")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.top, 8)
                
                List(mockApps, id: \.self) { app in
                    HStack {
                        Text(app)
                        Spacer()
                        if mode.blockedApps.contains(app) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if mode.blockedApps.contains(app) {
                            mode.blockedApps.remove(app)
                        } else {
                            mode.blockedApps.insert(app)
                        }
                        onModeUpdated(mode)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarItems(trailing: Button("Done") {
                onModeUpdated(mode)
            })
        }
    }
}

#Preview {
    AppPickerView(mode: BlockingMode(name: "Test")) { _ in }
} 
