import SwiftUI

struct ModePickerView: View {
    @State private var modes: [BlockingMode] = BlockingMode.defaultModes
    @State private var showingAppPicker = false
    @State private var selectedMode: BlockingMode?
    @State private var editingModeId: UUID?
    @State private var editingModeName: String = ""
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
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(modes) { mode in
                        HStack {
                            if editingModeId == mode.id {
                                TextField("Mode Name", text: $editingModeName, onCommit: {
                                    if let index = modes.firstIndex(where: { $0.id == mode.id }) {
                                        modes[index].name = editingModeName
                                    }
                                    editingModeId = nil
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                            } else {
                                VStack(alignment: .leading) {
                                    Text(mode.name)
                                        .font(.headline)
                                        .onTapGesture(count: 2) {
                                            editingModeId = mode.id
                                            editingModeName = mode.name
                                        }
                                    Text("\(mode.blockedApps.count) apps blocked")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
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
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray)
                        )
                        .background(Color.white)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            selectedMode = mode
                            showingAppPicker = true
                        }
                    }
                }
                
                Button(action: {
                    let newMode = BlockingMode(name: "New Mode")
                    modes.append(newMode)
                    selectedMode = newMode
                    showingAppPicker = true
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
                
                Button(action: {
                    if let selectedMode = selectedMode {
                        onModeSelected(selectedMode)
                    }
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedMode != nil ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedMode == nil)
            }
            .frame(maxWidth: .infinity, alignment: .top)
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
