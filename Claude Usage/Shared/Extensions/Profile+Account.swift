import Foundation

extension Profile {
    private func jsonObject(from raw: String?) -> [String: Any]? {
        guard let raw, let data = raw.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    var accountEmail: String? {
        guard let root = jsonObject(from: oauthAccountJSON) else { return nil }
        let container = (root["oauthAccount"] as? [String: Any]) ?? root
        guard let email = container["emailAddress"] as? String, !email.isEmpty else { return nil }
        return email
    }

    var subscriptionTypeRaw: String? {
        guard let root = jsonObject(from: cliCredentialsJSON),
              let oauth = root["claudeAiOauth"] as? [String: Any],
              let type = oauth["subscriptionType"] as? String,
              !type.isEmpty, type != "unknown" else { return nil }
        return type
    }

    var isMaxPlan: Bool {
        guard let raw = subscriptionTypeRaw?.lowercased() else { return false }
        return raw.contains("max")
    }

    var planDisplayName: String? {
        guard let raw = subscriptionTypeRaw else { return nil }
        let key = raw.lowercased().replacingOccurrences(of: "-", with: "_")

        if key.contains("max") {
            if key.contains("20") { return "Claude Max 20x" }
            if key.contains("5") { return "Claude Max 5x" }
            return "Claude Max"
        }
        if key.contains("team") { return "Claude Team" }
        if key.contains("enterprise") { return "Claude Enterprise" }
        if key.contains("pro") { return "Claude Pro" }
        if key.contains("free") { return "Claude Free" }

        let spaced = key.replacingOccurrences(of: "_", with: " ")
        return "Claude " + spaced.capitalized
    }
}
