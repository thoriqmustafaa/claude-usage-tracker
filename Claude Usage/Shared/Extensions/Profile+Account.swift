import Foundation

extension Profile {
    private func jsonObject(from raw: String?) -> [String: Any]? {
        guard let raw, let data = raw.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    private var oauthAccountFields: [String: Any]? {
        guard let root = jsonObject(from: oauthAccountJSON) else { return nil }
        return (root["oauthAccount"] as? [String: Any]) ?? root
    }

    private func nonEmptyString(_ key: String, in dict: [String: Any]?) -> String? {
        guard let value = dict?[key] as? String, !value.isEmpty, value != "unknown" else { return nil }
        return value
    }

    var accountEmail: String? {
        nonEmptyString("emailAddress", in: oauthAccountFields)
    }

    /// Plan identifiers in preference order. `organizationRateLimitTier` is the only
    /// source that carries the Max multiplier (e.g. "default_claude_max_5x"), and it
    /// lives in the plist-backed oauth account rather than the keychain, so it stays
    /// readable wherever the profile is loaded.
    private var planIdentifiers: [String] {
        let fields = oauthAccountFields
        return [
            nonEmptyString("organizationRateLimitTier", in: fields),
            nonEmptyString("userRateLimitTier", in: fields),
            nonEmptyString("organizationType", in: fields),
            subscriptionTypeRaw
        ].compactMap { $0 }
    }

    var subscriptionTypeRaw: String? {
        guard let root = jsonObject(from: cliCredentialsJSON),
              let oauth = root["claudeAiOauth"] as? [String: Any] else { return nil }
        return nonEmptyString("subscriptionType", in: oauth)
    }

    var isMaxPlan: Bool {
        planIdentifiers.contains { $0.lowercased().contains("max") }
    }

    var planDisplayName: String? {
        for raw in planIdentifiers {
            if let label = Self.planLabel(for: raw) { return label }
        }
        return nil
    }

    private static func planLabel(for raw: String) -> String? {
        let key = raw.lowercased().replacingOccurrences(of: "-", with: "_")

        if key.contains("max") {
            if key.contains("20x") { return "Claude Max 20x" }
            if key.contains("5x") { return "Claude Max 5x" }
            return "Claude Max"
        }
        if key.contains("team") { return "Claude Team" }
        if key.contains("enterprise") { return "Claude Enterprise" }
        if key.contains("pro") { return "Claude Pro" }
        if key.contains("free") { return "Claude Free" }
        return nil
    }
}
