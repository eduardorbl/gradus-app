import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isWishlisted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            poster
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                HStack(spacing: 8) {
                    if let year = movie.year {
                        Text(String(year))
                    }
                    Text("★ \(ratingText)")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Text(movie.overview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
        )
        .overlay(alignment: .topTrailing) {
            if isWishlisted {
                Image(systemName: "star.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.yellow)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    )
                    .padding(10)
            }
        }
    }

    private var ratingText: String {
        String(format: "%.1f", movie.rating)
    }

    @ViewBuilder
    private var poster: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))

            if let url = movie.posterURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        posterPlaceholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                    case .failure:
                        posterPlaceholder
                    @unknown default:
                        posterPlaceholder
                    }
                }
            } else {
                posterPlaceholder
            }
        }
        .aspectRatio(2.0 / 3.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var posterPlaceholder: some View {
        Image(systemName: "film")
            .font(.system(size: 40, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}
