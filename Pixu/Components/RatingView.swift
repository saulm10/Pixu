import SwiftUI

struct RatingView: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            
            Text(rating.formatted(.number.precision(.fractionLength(2))))
                .foregroundStyle(.textOnTertiary)
        }
        .font(.headline)
        .padding(6)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
}

