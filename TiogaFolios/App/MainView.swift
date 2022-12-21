//
//  MainView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import Foundation

import SwiftUI
import CoreData

struct MainView: View {
    // @Environment(\.managedObjectContext) private var viewContext
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    
    @ViewBuilder
    var body: some View {
#if os(iOS)
        if horizontalSizeClass == .compact {
            TabBarNavigationView() // For iPhone
        }
        else {
            SidebarNavigationView() // For iPad
        }
#else
        SidebarNavigationView() // For mac
            .frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
#endif
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, Storage.preview.container.viewContext)
    }
}


func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension Binding {
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        // Ensure a non-nil value in `source`.
        if source.wrappedValue == nil {
            source.wrappedValue = defaultValue
        }
        // Unsafe unwrap because *we* know it's non-nil now.
        self.init(source)!
    }
    
}

