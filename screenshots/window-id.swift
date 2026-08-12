import CoreGraphics
import Foundation

let expectedOwner = "Typeset Viewer"
let windows = CGWindowListCopyWindowInfo(
    [.optionOnScreenOnly, .excludeDesktopElements],
    kCGNullWindowID
) as? [[String: Any]] ?? []

let candidates = windows.compactMap { window -> (id: CGWindowID, area: Double)? in
    guard
        window[kCGWindowOwnerName as String] as? String == expectedOwner,
        window[kCGWindowLayer as String] as? Int == 0,
        let number = window[kCGWindowNumber as String] as? UInt32,
        let bounds = window[kCGWindowBounds as String] as? [String: Any],
        let width = bounds["Width"] as? Double,
        let height = bounds["Height"] as? Double,
        width >= 640,
        height >= 460
    else {
        return nil
    }
    return (number, width * height)
}

guard let window = candidates.max(by: { $0.area < $1.area }) else {
    FileHandle.standardError.write(Data("No visible Typeset Viewer document window found.\n".utf8))
    exit(1)
}

print(window.id)
