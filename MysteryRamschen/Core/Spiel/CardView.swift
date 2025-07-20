import SwiftUI

struct CardView: View {
    let card: GameViewModel.Card
    let isPlayable: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                if let uiImage = UIImage(named: cardImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 70)
                        .cornerRadius(6)
                        .shadow(radius: 2)
                } else {
                    VStack(spacing: 2) {
                        Text(card.value)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(cardColor)

                        Text(card.suit)
                            .font(.system(size: 20))
                            .foregroundColor(cardColor)
                    }
                    .frame(width: 50, height: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(cardColor, lineWidth: 1)
                    )
                }
            }
        }
        .disabled(!isPlayable)
        .opacity(isPlayable ? 1.0 : 0.5)
    }

    private var cardImageName: String {
        return "\(card.suitName)\(card.valueName)"
    }

    private var cardColor: Color {
        switch card.suit {
        case "♥", "♦":
            return .red
        case "♠", "♣":
            return .black
        default:
            return .black
        }
    }
}

