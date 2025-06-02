import SwiftUI

struct ModePickerView: View {
    @State private var modes: [BlockingMode] = BlockingMode.defaultModes
    @State private var showingAppPicker = false
    @State private var selectedMode: BlockingMode?
    @State private var showingNewModeSheet = false
    @State private var newModeName = ""
    var onModeSelected: (BlockingMode) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text("Focus Modes")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal)
                
                Text("Select or create a focus mode to manage your app usage. Customize which apps to block for each mode.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(modes) { mode in
                        Button(action: {
                            selectedMode = mode
                            showingAppPicker = true
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(mode.name)
                                        .font(.headline)
                                    Text("\(mode.blockedApps.count) apps blocked")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if mode.isDefault {
                                    Text("Default")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                Button(action: {
                    showingNewModeSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        Text("Add New Mode")
                            .foregroundColor(.blue)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.blue.opacity(0.5))
                    )
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if let selectedMode = selectedMode {
                    Button(action: {
                        onModeSelected(selectedMode)
                    }) {
                        Text("Continue with \(selectedMode.name)")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .sheet(isPresented: $showingNewModeSheet) {
            NavigationView {
                Form {
                    TextField("Mode Name", text: $newModeName)
                }
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingNewModeSheet = false
                    },
                    trailing: Button("Create") {
                        let newMode = BlockingMode(name: newModeName)
                        modes.append(newMode)
                        newModeName = ""
                        showingNewModeSheet = false
                    }
                    .disabled(newModeName.isEmpty)
                )
            }
        }
        .sheet(isPresented: $showingAppPicker) {
            if let mode = selectedMode {
                AppPickerView(mode: mode) { updatedMode in
                    if let index = modes.firstIndex(where: { $0.id == updatedMode.id }) {
                        modes[index] = updatedMode
                        self.selectedMode = updatedMode
                    }
                }
            }
        }
    }
    
    private func deleteMode(at offsets: IndexSet) {
        modes.remove(atOffsets: offsets)
    }
}

#Preview {
    ModePickerView { _ in }
} 
