import SwiftUI

struct ModePickerView: View {
    @State private var modes: [BlockingMode] = BlockingMode.defaultModes
    @State private var showingAppPicker = false
    @State private var selectedMode: BlockingMode?
    @State private var showingNewModeSheet = false
    @State private var newModeName = ""
    var onModeSelected: (BlockingMode) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                List {
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
                        }
                    }
                    .onDelete(perform: deleteMode)
                }
                
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewModeSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
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
    }
    
    private func deleteMode(at offsets: IndexSet) {
        modes.remove(atOffsets: offsets)
    }
}

#Preview {
    ModePickerView { _ in }
} 
