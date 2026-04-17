//
//  PaywallView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//


import SwiftUI

struct PaywallView: View {

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                header
                pricing
                benefits
                footer
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Background
extension PaywallView {
    var background: some View {
        LinearGradient(
            colors: [Color.purple.opacity(0.7), Color.pink.opacity(0.6)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Header
extension PaywallView {
    var header: some View {
        ZStack {
            VStack {
                Spacer()

                Image("girl") // 👈 replace image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
            }

            VStack {
                HStack {
                    Button {
                        // close
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }

                    Spacer()
                }
                .padding()

                Spacer()
            }
        }
        .frame(height: 260)
    }
}

// MARK: - Pricing
extension PaywallView {

    var pricing: some View {
        VStack(spacing: 16) {

            Text("Random Filter Premium")
                .font(.title2.bold())

            HStack(spacing: 12) {
                priceCard(title: "Yearly", price: "$19.99", sub: "$0.38/week", selected: false)

                priceCard(title: "Weekly", price: "$3.99", sub: "", selected: true, badge: "Best Offer")

                priceCard(title: "Monthly", price: "$5.99", sub: "$1.49/week", selected: false)
            }
        }
        .padding(.horizontal)
        .padding(.top, -40)
    }

    func priceCard(title: String,
                   price: String,
                   sub: String,
                   selected: Bool,
                   badge: String? = nil) -> some View {

        VStack(spacing: 6) {
            if let badge {
                Text(badge)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.1))
                    .clipShape(Capsule())
            }

            Text(title)
                .font(.subheadline.bold())

            Text(price)
                .font(.title3.bold())

            if !sub.isEmpty {
                Text(sub)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(selected ? Color.purple.opacity(0.3) : Color.white.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(selected ? Color.purple : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Benefits
extension PaywallView {

    var benefits: some View {
        VStack(spacing: 16) {

            Text("Premium benefits")
                .font(.headline)

            VStack(spacing: 0) {
                benefitRow("Remove ads", false, true)
                benefitRow("Record with random filters", true, true)
                benefitRow("Unlock all trending filters", false, true)
                benefitRow("Record without use limit", false, true)
                benefitRow("Unlock all features", false, true)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.8))
            )
        }
        .padding()
    }

    func benefitRow(_ title: String, _ free: Bool, _ premium: Bool) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)

            Spacer()

            icon(free)
            icon(premium)
        }
        .padding()
        .overlay(Divider(), alignment: .bottom)
    }

    func icon(_ enabled: Bool) -> some View {
        Image(systemName: enabled ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundColor(enabled ? .purple : .red)
    }
}

// MARK: - Footer
extension PaywallView {

    var footer: some View {
        VStack(spacing: 12) {

            Button {
                // continue
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .clipShape(Capsule())
            }

            HStack {
                Text("Privacy Policy")
                Spacer()
                Text("Restore")
                Spacer()
                Text("Term of Use")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    PaywallView()
}
