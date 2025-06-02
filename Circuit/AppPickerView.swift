import SwiftUI

struct AppPickerView: View {
    let mockApps = ["Instagram", "TikTok", "YouTube", "Snapchat", "Twitter", "Facebook"]
    @State private var selectedApps: Set<String> = []
    var onContinue: ([String]) -> Void

    var body: some View {
        VStack {
            Text("Pick Apps to Block")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            Text("Select the apps you want to block during focus time.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 8)
            List(mockApps, id: \.self) { app in
                HStack {
                    Text(app)
                    Spacer()
                    if selectedApps.contains(app) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedApps.contains(app) {
                        selectedApps.remove(app)
                    } else {
                        selectedApps.insert(app)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            Button(action: {
                onContinue(Array(selectedApps))
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedApps.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(selectedApps.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
} 
