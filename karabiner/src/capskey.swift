import CoreGraphics
import Foundation
let src = CGEventSource(stateID: .hidSystemState)
let down = CGEvent(keyboardEventSource: src, virtualKey: 0x39, keyDown: true)!
down.flags = .maskAlphaShift
down.post(tap: .cghidEventTap)
usleep(200_000)
let up = CGEvent(keyboardEventSource: src, virtualKey: 0x39, keyDown: false)!
up.post(tap: .cghidEventTap)
