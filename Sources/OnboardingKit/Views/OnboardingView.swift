// OnboardingKit, by Gavin Gichini

import SwiftUI
#if canImport(SafariServices)
import SafariServices
#endif

/// The main view on an onboarding that is displayed using ``GuidedView`` and waits for another view to
/// load behind it, as well as a privacy policy.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct OnboardingView: View {
    @AppStorage("onboarding_complete")
    var onboardingComplete: Bool = false
    
    @Environment(\.dismiss)
    var dismiss
    
//    @Binding var isPresented: Bool
    var features: [OnboardingFeature]?
    var privacyDescription: LocalizedStringKey
    var privacyURL: URL
    
    @State var privacyPolicyIsPresented: Bool = false
    
    public var body: some View {
        Group {
#if os(watchOS)
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Welcome to")
                        Text("\(Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "BUNDLE_NAME")")
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
                        onboardingComplete = true
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
