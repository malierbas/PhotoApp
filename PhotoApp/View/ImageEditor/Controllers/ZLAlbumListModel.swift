//
//  ZLAlbumListModel.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit
import Photos

public class ZLAlbumListModel: NSObject {

    public let title: String
    
    public var count: Int {
        return result.count
    }
    
    public var result: PHFetchResult<PHAsset>
    
    public let collection: PHAssetCollection
    
    public let option: PHFetchOptions
    
    public let isCameraRoll: Bool
    
    public var headImageAsset: PHAsset? {
        return result.lastObject
    }
    
    public var models: [ZLPhotoModel] = []
    
    // 暂未用到
    private var selectedModels: [ZLPhotoModel] = []
    
    // 暂未用到
    private var selectedCount: Int = 0
    
    public init(title: String, result: PHFetchResult<PHAsset>, collection: PHAssetCollection, option: PHFetchOptions, isCameraRoll: Bool) {
        self.title = title
        self.result = result
        self.collection = collection
        self.option = option
        self.isCameraRoll = isCameraRoll
    }
    
    public func refetchPhotos() {
        let models = ZLPhotoManager.fetchPhoto(in: self.result, ascending: ZLPhotoConfiguration.default().sortAscending, allowSelectImage: ZLPhotoConfiguration.default().allowSelectImage, allowSelectVideo:  ZLPhotoConfiguration.default().allowSelectVideo)
        self.models.removeAll()
        self.models.append(contentsOf: models)
    }
    
    func refreshResult() {
        self.result = PHAsset.fetchAssets(in: self.collection, options: self.option)
    }
    
}


func ==(lhs: ZLAlbumListModel, rhs: ZLAlbumListModel) -> Bool {
    return lhs.title == rhs.title && lhs.count == rhs.count && lhs.headImageAsset?.localIdentifier == rhs.headImageAsset?.localIdentifier
}

