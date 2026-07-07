import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.accent)
                    Text("Unlock Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(.white)
                    Text("Scent blend library with strength rating comparisons")
                        .font(Theme.bodyFont)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Theme.accent2)
                        .padding(.horizontal)
                    Text("You've reached the free limit of \(Store.freeLimit) entries. Upgrade for unlimited entries and pro tools.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal)
                    Button {
                        Task {
                            await purchases.purchase()
                            if purchases.isPro { dismiss() }
                        }
                    } label: {
                        Text("Upgrade — $1.99/mo")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cardCorner))
                    }
                    .accessibilityIdentifier("paywallUpgradeButton")
                    .padding(.horizontal)
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("paywallRestoreButton")
                    Button("Not Now") { dismiss() }
                        .foregroundStyle(.white.opacity(0.6))
                        .accessibilityIdentifier("paywallDismissButton")
                }
                .padding()
            }
        }
    }
}
