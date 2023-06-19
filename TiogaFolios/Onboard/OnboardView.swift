//
//  ContentView.swift
//  Onboarding
//
//  Created by Augustinas Malinauskas on 06/07/2020.
//

import SwiftUI

struct OnboardView: View {
    @State private var onboardinDone = false
    var data = OnboardingDataModel.data
    
    var body: some View {
        Group {
            if !onboardinDone {
                OnboardingViewPure(data: data, doneFunction: {
                    /// Update your state here
                    self.onboardinDone = true
                    print("done onboarding")
                })
            } else {
                Text("And now you'd see the starter folios in your Folios tab.")
            }
        }
        .onAppear() {self.onboardinDone = false}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
