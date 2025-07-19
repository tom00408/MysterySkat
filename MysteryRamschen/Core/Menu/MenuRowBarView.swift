import SwiftUI

struct MenuRowBarView: View {
    let text: String

    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.2))
            .foregroundColor(.black)
            .cornerRadius(12)
            .font(.headline)
    }
}
