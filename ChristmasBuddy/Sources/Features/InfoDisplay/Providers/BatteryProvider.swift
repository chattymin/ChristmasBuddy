import Foundation
import IOKit.ps

/// 배터리 정보 제공자
class BatteryProvider: InfoProvider {
    var icon: String { "🔋" }
    var title: String { "배터리" }
    var priority: Int { 1 }

    func getValue() async -> String {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any]
        else {
            return "정보 없음"
        }

        // 배터리 잔량
        if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Int {
            // 충전 중 확인
            let isCharging = description[kIOPSIsChargingKey] as? Bool ?? false
            let chargingIcon = isCharging ? " ⚡" : ""

            return "\(currentCapacity)%\(chargingIcon)"
        }

        return "정보 없음"
    }
}
