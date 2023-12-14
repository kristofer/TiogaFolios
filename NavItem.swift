//
//  NavItem.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 10/20/23.
//

import Foundation
import SwiftUI

enum NavItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case foliolist
    case folioseglist
    case foliosharelist
    case foliosearch
    case taglist
    case tagfilterlist
    case templatelist
    case setting
    case tagkindlist
    case onboarding
    
    @ViewBuilder static func navItemFor(selection: NavItem?) -> some View {
        if selection == nil {
            FolioListView()
        }
        switch selection {
        case .foliolist :
             FolioListView()
        case .foliosearch :
             SearchFolioView()
        case .taglist :
             TagListView()
        case .foliosharelist :
             FolioListSegView()
        case .setting :
             SettingsView()
        case .onboarding :
             OnboardView()
        case .tagfilterlist :
             FolioListByTag(TagKind.plain)
        default:
             FolioListView()
        }
    }
    
    func labelFor() -> (ttext: String, ticon: String) {
        switch self {
        case .foliolist :
            return ("Folios", "archivebox")
        case .foliosearch :
            return ("Search", "magnifyingglass")
        case .taglist :
            return ("Tags", "tag")
        case .foliosharelist :
            return ("Sharing", "icloud")
        case .setting :
            return ("Settings", "gear")
        case .onboarding :
            return ("Onboarding", "questionmark.app")
        case .tagfilterlist :
            return ("Folios By Tag", "tag.square")
        default:
            return ("Folios", "archivebox")
        }
    }

}
