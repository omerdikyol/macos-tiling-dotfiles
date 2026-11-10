import AppKit
import Foundation
setbuf(stdout, nil)
let pb = NSPasteboard.general
var last = pb.changeCount
func clean(_ s: String) -> String {
  let one = s.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")
  return String(one.prefix(80))
}
while true {
  usleep(500_000)
  let c = pb.changeCount
  if c == last { continue }
  last = c
  let types = (pb.types ?? []).map { $0.rawValue }
  if types.contains("org.nspasteboard.ConcealedType") || types.contains("org.nspasteboard.TransientType") { print("hidden\t"); continue }
  if let u = pb.string(forType: .fileURL), let url = URL(string: u) { print("file\t" + url.lastPathComponent) }
  else if let s = pb.string(forType: .string), !s.isEmpty { print("text\t" + clean(s)) }
  else if types.contains("public.png") || types.contains("public.tiff") { print("image\t") }
  else { print("other\t") }
}
