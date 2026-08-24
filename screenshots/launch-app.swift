import AppKit
import Foundation

guard CommandLine.arguments.count >= 2 else {
    FileHandle.standardError.write(Data("usage: launch-app.swift APP_BUNDLE [ARGUMENT ...]\n".utf8))
    exit(2)
}

let applicationURL = URL(fileURLWithPath: CommandLine.arguments[1])
let configuration = NSWorkspace.OpenConfiguration()
configuration.activates = true
configuration.addsToRecentItems = false
configuration.arguments = Array(CommandLine.arguments.dropFirst(2))
configuration.createsNewApplicationInstance = true
configuration.environment = ProcessInfo.processInfo.environment

let semaphore = DispatchSemaphore(value: 0)
var launchError: Error?
NSWorkspace.shared.openApplication(at: applicationURL, configuration: configuration) { _, error in
    launchError = error
    semaphore.signal()
}

while semaphore.wait(timeout: .now()) == .timedOut {
    RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.05))
}

if let launchError {
    FileHandle.standardError.write(Data("Could not launch capture app: \(launchError.localizedDescription)\n".utf8))
    exit(1)
}
