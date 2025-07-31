import SwiftUICore

enum SkeletonAlignmentType {
    case center
    case leading
    case trailing
    
    var toAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
    
    
}
