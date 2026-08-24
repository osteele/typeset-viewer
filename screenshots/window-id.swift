import CoreGraphics
import Foundation

let expectedOwner = CommandLine.arguments.dropFirst().first ?? "Typeset Viewer"
let expectedTitle = CommandLine.arguments.dropFirst(2).first
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
        width >= 420,
        height >= 320,
        expectedTitle == nil || (window[kCGWindowName as String] as? String) == expectedTitle
    else {
        return nil
    }
    return (number, width * height)
}

guard let window = candidates.max(by: { $0.area < $1.area }) else {
    let titleDescription = expectedTitle.map { " titled \"\($0)\"" } ?? ""
    FileHandle.standardError.write(Data("No visible \(expectedOwner) window\(titleDescription) found.\n".utf8))
    exit(1)
}

print(window.id)
