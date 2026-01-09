import WidgetKit
import SwiftUI

struct CryptoEntry: TimelineEntry {
    let date: Date
    let symbol: String
    let price: String
    let change: String
    let isPositive: Bool
    let lastUpdated: String
}

struct CryptoProvider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.com.example.cryptowidget")

    func placeholder(in context: Context) -> CryptoEntry {
        CryptoEntry(
            date: Date(),
            symbol: "BTC",
            price: "$--,---",
            change: "+0.00%",
            isPositive: true,
            lastUpdated: "--:--"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CryptoEntry) -> Void) {
        let entry = getEntryFromUserDefaults()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CryptoEntry>) -> Void) {
        let entry = getEntryFromUserDefaults()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func getEntryFromUserDefaults() -> CryptoEntry {
        let symbol = userDefaults?.string(forKey: "symbol") ?? "BTC"
        let price = userDefaults?.string(forKey: "price") ?? "$--,---"
        let change = userDefaults?.string(forKey: "change") ?? "+0.00%"
        let isPositive = userDefaults?.bool(forKey: "isPositive") ?? true
        let lastUpdated = userDefaults?.string(forKey: "lastUpdated") ?? "--:--"

        return CryptoEntry(
            date: Date(),
            symbol: symbol,
            price: price,
            change: change,
            isPositive: isPositive,
            lastUpdated: lastUpdated
        )
    }
}

struct CryptoWidgetEntryView: View {
    var entry: CryptoProvider.Entry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "2D2D44"), Color(hex: "1A1A2E")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.orange)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("B")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        )

                    Text(entry.symbol)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }

                Text(entry.price)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Text(entry.change)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(entry.isPositive ? Color.green : Color.red)

                Text("Son: \(entry.lastUpdated)")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CryptoProvider()) { entry in
            CryptoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bitcoin Tracker")
        .description("Bitcoin fiyatını anlık takip edin")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview(as: .systemSmall) {
    CryptoWidget()
} timeline: {
    CryptoEntry(date: .now, symbol: "BTC", price: "$67,432.50", change: "+2.34%", isPositive: true, lastUpdated: "14:30")
    CryptoEntry(date: .now, symbol: "BTC", price: "$65,123.00", change: "-1.50%", isPositive: false, lastUpdated: "14:45")
}
