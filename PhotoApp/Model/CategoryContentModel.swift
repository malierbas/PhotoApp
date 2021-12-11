//
//  CategoryContentModel.swift
//  PhotoApp
//
//  Created by Ali on 10.12.2021.
//

import Foundation

struct CategoryContentModel {
    var contentName: String? = nil
    var contentSize: Int? = nil
    var contents: [Template]? = nil
    
    init(contentName: String? = nil, contentSize: Int? = nil, contents: [Template]? = nil)
    {
        self.contentName = contentName
        self.contentSize = contentSize
        self.contents = contents
    }
}
