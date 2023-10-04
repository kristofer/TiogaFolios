//
//  Debugging.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 10/3/23.
//

import Foundation

//
//  Debugging.swift
//  StateDemo
//
//  Created by Michael Long on 7/27/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import SwiftUI

class InstanceTracker {
    static var count: Int {
        counter += 1
        return counter
    }
    let instance = InstanceTracker.count
    let name: String
    private static var counter: Int = 0
    private static var indent: Int = 0
    init(_ name: String) {
        self.name = name
        self("TFdebug \(name).init() #\(instance)")
    }
    deinit {
        self("TFdebug \(name).deinit() #\(instance)")
    }
    func callAsFunction<Result>(_ message: String? = nil, _ result: () -> Result) -> Result {
        self("TFdebug \(name).body #\(instance) {")
        Self.indent += 2
        if let message = message {
            self(message)
        }
        defer {
            Self.indent -= 2
            self("TFdebug }")
        }
        return result()
    }
    func callAsFunction(_ string: String) {
        print(String(repeating: " ", count: Self.indent) + string)
    }
}

struct DebugView<WrappedView:View>: View {
    let instance = InstanceTracker.count
    let view: WrappedView
    init(_ view: WrappedView) {
        self.view = view
        print("TFdebug \(WrappedView.self).init #\(instance)")
    }
    var body: some View {
        print("TFdebug \(WrappedView.self).body #\(instance)")
        return view
    }
}
