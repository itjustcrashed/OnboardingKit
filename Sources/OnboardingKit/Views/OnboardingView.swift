// OnboardingKit, by Gavin Gichini

import SwiftUI
#if canImport(SafariServices)
import SafariServices
#endif

/// The main view on an onboarding that is displayed using ``GuidedView`` and waits for another view to
/// load behind it, as well as a privacy policy.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct OnboardingView: View {
    @AppStorage("onboarding_complete")
    var onboardingComplete: Bool = false
    
    @Environment(\.dismiss)
    var dismiss
    
    var features: [OnboardingFeature]?
    var privacyDescription: LocalizedStringKey
    var privacyURL: URL
    
    init(features: [OnboardingFeature]? = nil, privacyDescription: LocalizedStringKey, privacyURL: URL) {
        self.features = features
        self.privacyDescription = privacyDescription
        self.privacyURL = privacyURL
    }
    
    @State var privacyPolicyIsPresented: Bool = false
    
    public var body: some View {
        Group {
#if os(watchOS)
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                        Text("\(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "OBKIT_BUNDLE_NAME")")
                            .foregroundStyle(Color.accentColor)
                    }
                    .font(.title3.weight(.medium).width(.condensed))
                    if let safeFeatures = features {
                        VStack(spacing: 10) {
                            ForEach(safeFeatures) { feature in
                                OnboardingFeatureView(feature)
                            }
                        }
                    }
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.accentColor)
                        Text(privacyDescription)
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                        Button("See how your data is managed...") {
                            privacyPolicyIsPresented.toggle()
                        }
                        .font(.footnote)
                    }
                    Button {
                        dismiss()
                        onboardingComplete = true
                    } label: {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, maxHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: 600)
                .padding()
            }
#elseif os(tvOS)
            HStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                            .foregroundStyle(.secondary)
                        Text("\(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "BUNDLE_NAME")")
                    }
                    .font(.largeTitle.weight(.bold))
                    .padding(.top, 100)
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.accentColor)
                        Text(privacyDescription)
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                    .buttonStyle(.borderedProminent)
                }
                if let safeFeatures = features {
                    VStack(spacing: 40) {
                        ForEach(safeFeatures) { feature in
                            OnboardingFeatureView(feature)
                        }
                    }
                }
            }
#else
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Welcome to")
                    Text("\(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "BUNDLE_NAME")")
                        .foregroundStyle(Color.accentColor)
                }
                .font(.largeTitle.weight(.bold))
                .padding(.top, 100)
                if let safeFeatures = features {
                    ScrollView {
                        ForEach(safeFeatures) { feature in
                            OnboardingFeatureView(feature)
                        }
                    }
                }
                Spacer()
                VStack(spacing: 6) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.accentColor)
                    Text(privacyDescription)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                    Button("See how your data is managed...") {
                        privacyPolicyIsPresented.toggle()
                    }
                    .font(.footnote)
                }
                Button {
                    dismiss()
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: 600)
            .padding()
#endif
        }
#if canImport(SafariServices)
        .sheet(isPresented: $privacyPolicyIsPresented) {
            SafariView(url: URL(string: "https://apple.com/privacy")!)
        }
#endif
        .background(.background)
    }
}

// No features
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview {
    OnboardingView(
        privacyDescription: "\(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "BUNDLE_NAME") collects usage data including your device identifier, app version, and language. By selecting continue, you agree to the privacy policy.",
        privacyURL: URL(string: "https://www.apple.com/privacy")!
    )
}

// With features
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview {
    OnboardingView(
        features: [
            OnboardingFeature(
                "Preview your apps",
                systemImage: "iphone.gen3.motion",
                description: "You can easily preview your apps on a variety of devices."
            ),
            OnboardingFeature(
                "Verify different situations",
                systemImage: "questionmark.app.dashed",
                description: "Previews how your app looks when things are different."
            )
        ],
        privacyDescription: "\(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "BUNDLE_NAME") collects usage data including your device identifier, app version, and language. By selecting continue, you agree to the privacy policy.",
        privacyURL: URL(string: "https://www.apple.com/privacy")!
    )
}

#if canImport(SafariServices)
private struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
#endif
