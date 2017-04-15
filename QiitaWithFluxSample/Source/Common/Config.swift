//
//  Config.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

struct Config: Decodable {
    enum Error: Swift.Error {
        case notFoundFile(String)
        case notFoundContents(URL)
        case invalidCast(NSDictionary, String)
    }
    
    static let shared: Config = {
        do {
            let url = try Bundle.main.url(forResource: "Config", withExtension: "plist") ?? {
                throw Error.notFoundFile("Config.plist")
            }()
            let dict = try NSDictionary(contentsOf: url) ?? {
                throw Error.notFoundContents(url)
            }()
            let plist = try dict as? [String : String] ?? {
                throw Error.invalidCast(dict, "[String : String]")
            }()
            return try decodeValue(plist)
        } catch let e {
            fatalError("\(e)")
        }
    }()
    
    let baseUrl: String
    let clientId: String
    
    static func decode(_ e: Extractor) throws -> Config {
        return try Config(
            baseUrl: e <| "baseUrl",
            clientId: e <| "clientId"
        )
    }
}
