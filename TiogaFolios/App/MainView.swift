//
//  MainView.swift
//  Carolina
//
//  Created by Kristofer Younger on 10/8/21.
//

import Foundation

import SwiftUI
import CoreData

extension UIDevice {
    static var idiom: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }
    static var isIpad: Bool {
        idiom == .pad
      }
      
      static var isiPhone: Bool {
        idiom == .phone
      }
    
    static var runningOnMac: Bool {
        print("running on mac: \(ProcessInfo().isMacCatalystApp)")
        return ProcessInfo().isMacCatalystApp
    }
}

struct MainView: View {
    // @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @ViewBuilder
    var body: some View {
        TabBarNavigationView()
        //NewNavView()
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

