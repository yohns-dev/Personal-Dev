import SwiftUICore

enum SkeletonStackAlignmentType {
    case leading
    case trailing
    case center
    case top
    case bottom

    var toHorizontalAlignment: HorizontalAlignment? {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        default: return nil
        }
    }

    var toVerticalAlignment: VerticalAlignment? {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        default: return nil
        }
    }

    var toAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .trailing: return .trailing
        case .center: return .center
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

