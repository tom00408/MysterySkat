import SwiftUI

struct KartenGridView: View {
    let kartenBreite = 100
    let kartenHoehe = 140
    let karten: [Image]

    init() {
        self.karten = KartenGridView.loadImages()
    }

    var body: some View {
        VStack {
            ForEach(0..<4, id: \.self) { i in
                HStack {
                    ForEach(0..<8, id: \.self) { j in
                        if i * 8 + j < karten.count {
                            karten[i * 8 + j]
                                .resizable()
                                .frame(width: CGFloat(kartenBreite), height: CGFloat(kartenHoehe))
                        }
                    }
                }
            }
        }
    }

    static func loadImages() -> [Image] {
        var result: [Image] = []

        guard let url = Bundle.main.url(forResource: "karten2", withExtension: "jpeg"),
              let originalImage = UIImage(contentsOfFile: url.path)?.cgImage else {
            print("Bild konnte nicht geladen werden")
            return result
        }

        let kartenBreite = 100
        let kartenHoehe = 140

        let bildBreite = originalImage.width
        let bildHoehe = originalImage.height

        let eckeX = 0 // <- ggf. wieder 1 + 5 * kartenBreite, wenn Sprite groß genug ist
        let eckeY = 0

        for i in 0..<4 {
            for j in 0..<8 {
                let x = eckeX + j * kartenBreite
                let y = eckeY + i * kartenHoehe

                // Check, ob Ausschnitt im Bildbereich liegt
                if x + kartenBreite <= bildBreite, y + kartenHoehe <= bildHoehe {
                    let rect = CGRect(x: x, y: y, width: kartenBreite, height: kartenHoehe)
                    if let cropped = originalImage.cropping(to: rect) {
                        let image = Image(decorative: cropped, scale: 1.0)
                        result.append(image)
                    }
                } else {
                    print("⚠️ Überschreitet Bildgrenze bei Karte \(i), \(j) – wird übersprungen")
                }
            }
        }

        return result
    }
}


#Preview {
    KartenGridView()
}
