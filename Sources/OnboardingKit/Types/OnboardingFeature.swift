//
//  OnboardingFeature.swift
//  OnboardingKit
//
//  Created by Gavin Gichini on 8/31/24.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public class OnboardingFeature: Identifiable {
    var titleKey: LocalizedStringKey
    var systemImage: String
    var description: LocalizedStringKey

    public init(
        _ titleKey: LocalizedStringKey, systemImage: String,
        description: LocalizedStringKey
    ) {
        self.titleKey = titleKey
        self.systemImage = systemImage
        self.description = description
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct OnboardingFeatureView: View {
    var feature: OnboardingFeature

    init(_ feature: OnboardingFeature) {
        self.feature = feature
    }

    var body: some View {
        #if os(watchOS)
            VStack(spacing: 2) {
                Image(systemName: feature.systemImage)
                    .foregroundStyle(.blue)
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 36))
                    .frame(width: 46, height: 46)
                //            VStack(alignment: .leading) {
                Text(feature.titleKey)
                    .font(.system(.headline, weight: .semibold))
                Text(feature.description)
                    .multilineTextAlignment(.leading)
                    .kerning(0.2)
                //            }
            }
        #else
            HStack(spacing: 15) {
                Image(systemName: feature.systemImage)
                    .foregroundStyle(Color.accentColor)
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 40))
                    .frame(width: 70, height: 70)
                VStack(alignment: .leading) {
                    Text(feature.titleKey)
                        .font(.system(.title3, weight: .bold))
                    Text(feature.description)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
        #endif
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview {
    #if os(watchOS)
        ScrollView {
            OnboardingFeatureView(
                OnboardingFeature(
                    "It works on watch too",
                    systemImage: "applewatch",
                    description: "The font kerning is a bit smaller."
                )
            )
            OnboardingFeatureView(
                OnboardingFeature(
                    "Accessibility",
                    systemImage: "accessibility",
                    description: "Please don't make scrolling simulator 2000!"
                )
            )
            OnboardingFeatureView(
                OnboardingFeature(
                    "Only when needed",
                    systemImage: "iphone",
                    description: "Don't replay the iPhone's onboarding."
                )
            )
        }
    #else
        VStack {
            OnboardingFeatureView(
                OnboardingFeature(
                    "Keep it short",
                    systemImage: "rectangle.arrowtriangle.2.inward",
                    description:
                        "Use a description that's short and gets to the point. No essays."
                )
            )
            OnboardingFeatureView(
                OnboardingFeature(
                    "Use the right symbol",
                    systemImage: "person.3.sequence",
                    description:
                        "Reading a symbol is easier than reading a description."
                )
            )
            OnboardingFeatureView(
                OnboardingFeature(
                    "Don't do promotions",
                    systemImage: "shippingbox",
                    description:
                        "Reading a symbol is easier than reading a description."
                )
            )
            Divider()
            OnboardingFeatureView(
                OnboardingFeature(
                    "Easily add onboardings",
                    systemImage: "app.badge.checkmark.fill",
                    description:
                        "It's incredibly easy to add onboardings in just a few extra lines!"
                )
            )
            OnboardingFeatureView(
                OnboardingFeature(
                    "Farmiliar Look",
                    systemImage: "sparkles.square.fill.on.square",
                    description:
                        "It's a view like the one found in Apple apps, combined with your app's look."
                )
            )
            OnboardingFeatureView(
                OnboardingFeature(
                    "Privacy Included",
                    systemImage: "hand.raised",
                    description:
                        "OnboardingKit has you covered with privacy, so you don't need to worry about it. (much)"
                )
            )
        }
        .padding(30)
    #endif
}
