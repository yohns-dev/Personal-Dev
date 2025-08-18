import AppKit
import SwiftUI

@MainActor
final class WidgetDashboardSettingPopupView: NSObject, ObservableObject {
    private let popover = NSPopover()
    func show<Content: View>(relativeTo view: NSView, @ViewBuilder content: () -> Content) {
        let host = NSHostingController(rootView: content())
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 260, height: 160)
        popover.contentViewController = host
        popover.show(relativeTo: view.bounds, of: view, preferredEdge: .maxY)
    }
    func close() { popover.performClose(nil) }
}

struct WidgetDashboardSettingPopupAnchorView: NSViewRepresentable {
    @Binding var nsView: NSView?
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        Task {@MainActor in self.nsView = view }
        return view
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}
