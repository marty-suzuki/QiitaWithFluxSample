//
//  Tag.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

struct Tag: Decodable {
    let name: String
    let versions: [String]
    
    static func decode(_ e: Extractor) throws -> Tag {
        return try Tag(
            name: e <| "name",
            versions: e.array("versions")
        )
    }
}
