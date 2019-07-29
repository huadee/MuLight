//
//  ImageModel.swift
//  mulight
//
//  Created by jukui liu on 2019/7/29.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation

public struct ImageModel: Codable {
    let name: String
    let filePath: String
    let createTime: Double
}

public struct ImageList: Codable {
    let data: [ImageModel]
}
