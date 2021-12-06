//
//  AnalyticsEvent.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import Foundation

enum AnalyticsEvent {
//    case subscribeButtonTapped(fromTemplateWithId: String?, fromBackgroundWithId: String?)
    case subscriptionSceneOpened
    case weeklyGiftSceneOpened
    case subscribeButtonTapped
    case editorSceneOpened
    case exportButtonTapped
    case exportedTemplate
    case templateBackgroundSelected
    case imageAddedToTemplate
    case shareApp
    case openInstagramProfile

    var name: String {
        switch self {
        case .subscriptionSceneOpened:
            return "subscriptionSceneOpened"
        case .weeklyGiftSceneOpened:
            return "weeklyGiftSceneOpened"
        case .subscribeButtonTapped:
            return "subscribeButtonTapped"
        case .editorSceneOpened:
            return "editorSceneOpened"
        case .exportButtonTapped:
            return "exportButtonTapped"
        case .templateBackgroundSelected:
            return "templateBackgroundSelected"
        case .shareApp:
            return "shareApp"
        case .imageAddedToTemplate:
            return "imageAddedToTemplate"
        case .exportedTemplate:
            return "exportedTemplate"
        case .openInstagramProfile:
            return "openInstagramProfile"
        }
    }
}

