//
//  OnboardingModel.swift
//  Onboarding
//
//  Created by Augustinas Malinauskas on 06/07/2020.
//

import Foundation

struct OnboardingDataModel {
    var image: String
    var heading: String
    var text: String
}

extension OnboardingDataModel {
    static var data: [OnboardingDataModel] = [
        OnboardingDataModel(image: "onboarding-foliolist", heading: "Tioga Folios", text: "Tioga Folios is a secure personal digital estate organizer managing and organizing your most important documents like banking, investments, insurance, taxes, and all the crucial information you have. Folios keeps this information on your iPhone and/or iPad, and holds backups in Apple’s most secure network storage services. No one but you can see these documents, not anyone from Tioga, nor anyone from Apple."),
        OnboardingDataModel(image: "onboarding-foliodetail", heading: "What's a folio?", text: "A folio is like a folder on a computer allowing you to group your documents and is focusing on their long term storage. A folio tracks a list of documents, pictures and notes."),
        OnboardingDataModel(image: "onboarding-createfolio", heading: "Create a Folio", text: "Sometimes, we are “too close” to our own lives to know what important things we should keep long term. Folios has a series of example folios, which help you to know what you should track. It’s very easy to add a new folio and customize it."),
        OnboardingDataModel(image: "onboarding-addtofolio", heading: "Add things to a Folio", text: "You can add digital files from iCloud files, scan a paper document, add a text note, or using Apple’s automated Sharing to share things into your folios form any other App."),
        OnboardingDataModel(image: "onboarding-sharingfolio", heading: "Sharing Folios", text: "You grant your closest personal contacts (your spouse, children, or parents) access to a folio as you need to, maybe sharing personal digital estate details, like your will, or information about key personal property or documents, with your most trusted confidantes."),
    ]
}
