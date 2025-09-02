import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Text("Okay")
        }
    }
}

#Preview {
    SettingsView()
}
