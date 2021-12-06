//
//  PHAsset+ZLPhotoBrowser.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import Photos

extension PHAsset {

    var isInCloud: Bool {
        guard let resource = PHAssetResource.assetResources(for: self).first else {
            return false
        }
        return !(resource.value(forKey: "locallyAvailable") as? Bool ?? true)
    }

}

