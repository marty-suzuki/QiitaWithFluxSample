//
//  Config.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

struct Config: Himotoki.Decodable {
    enum Error: Swift.Error {
        case notFoundFile(String)
        case notFoundContents(URL)
        case invalidCast(NSDictionary, String)
        case emptyString(String)
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
    let redirectUrl: String
    let clientId: String
    let clientSecret: String
    
    static func decode(_ e: Extractor) throws -> Config {
        let config = try Config(
            baseUrl: e <| "baseUrl",
            redirectUrl: e <| "redirectUrl",
            clientId: e <| "clientId",
            clientSecret: e <| "clientSecret"
        )
        try config.validate()
        return config
    }
    
    func validate() throws {
        if baseUrl.isEmpty {
            throw Error.emptyString("baseUrl")
        }
        if redirectUrl.isEmpty {
            throw Error.emptyString("redirectUrl")
        }
        if clientId.isEmpty {
            throw Error.emptyString("clientId")
        }
        if clientSecret.isEmpty {
            throw Error.emptyString("clientSecret")
        }
    }
}
