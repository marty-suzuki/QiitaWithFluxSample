//
//  Tag.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public struct Tag: Codable {
    public let name: String
    public let versions: [String]
}
