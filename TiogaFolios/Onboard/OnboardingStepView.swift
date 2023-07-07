//
//  OnboardingStepView.swift
//  Onboarding
//
//  Created by Augustinas Malinauskas on 06/07/2020.
//

import SwiftUI

struct OnboardingStepView: View {
    var data: OnboardingDataModel
    
    var body: some View {
        VStack {
            Image(data.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 360, height: 360)
                //.scaledToFit()
//                .border(.gray)
                .shadow(color: .gray, radius: 5, x: 5, y: 5)
                .padding(.bottom, 20)
            
            Text(data.heading)
                .font(.system(size: 25, design: .rounded))
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text(data.text)
                .font(.system(size: 17, design: .rounded))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
    }
}

struct OnboardingStepView_Previews: PreviewProvider {
    static var data = OnboardingDataModel.data[0]
    static var previews: some View {
        OnboardingStepView(data: data)
    }
}
