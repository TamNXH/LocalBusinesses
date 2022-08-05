//
//  ViewExtension.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import SwiftUI

extension View {
    
    // MARK: - Public Methods
    
    /// Hide separator of row in list
    /// - Returns: View
    func hideListRowSeparator() -> some View {
        return customListRowSeparator()
    }
    
    /// Disable selection of row in list
    /// - Returns: View
    func disableSelection() -> some View {
        return customListRowSelection()
    }
    
    /// Round specific corners
    /// - Parameters:
    ///   - radius: CGFloat
    ///   - corners: corners description
    /// - Returns: View
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    // MARK: - Private Methods
    
    /// Custom separator of row in list
    /// - Returns: View
    private func customListRowSeparator() -> some View {
        self.onAppear {
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().separatorColor = .white
        }
    }
    
    /// Custom selection of row in list
    /// - Returns: View
    private func customListRowSelection() -> some View {
        self.onAppear {
            UITableViewCell.appearance().selectionStyle = .none
        }
    }
}

extension UIView {
    
    /// Search ancestral view hierarchy for the given view type.
    func searchViewAnchestors<ViewType: UIView>(for viewType: ViewType.Type) -> ViewType? {
        if let matchingView = self.superview as? ViewType {
            return matchingView
        } else {
            return superview?.searchViewAnchestors(for: viewType)
        }
    }
}

private struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius,
                                                    height: radius))
        return Path(path.cgPath)
    }
}
