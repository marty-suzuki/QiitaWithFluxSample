//
//  Config.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

struct Config: Codable {
    enum Error: Swift.Error {
        case notFoundFile(String)
        case notFoundContents(URL)
        case invalidCast(NSDictionary, String)
        case emptyString(String)
        case notFoundValueForKey(String)
    }
    
    static let shared: Config = {
        do {
            #if TEST
            let url = try Bundle.main.url(forResource: "Config", withExtension: "plist") ?? {
                throw Error.notFoundFile("Config.plist")
            }()
            let dict = try NSDictionary(contentsOf: url) ?? {
                throw Error.notFoundContents(url)
            }()
            let plist = try dict as? [String : String] ?? {
                throw Error.invalidCast(dict, "[String : String]")
            }()
            let config = try Config(dict: plist)
            try config.validate()
            #else
            let config = Config(baseUrl: "https://qiita.com/api",
                                redirectUrl: "https://",
                                clientId: "client-id",
                                clientSecret: "client-secret")
            #endif
            return config
        } catch let e {
            fatalError("\(e)")
        }
    }()
    
    let baseUrl: String
    let redirectUrl: String
    let clientId: String
    let clientSecret: String

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

extension Config {
    private init(dict: [String : String]) throws {
        func value(for key: String) throws -> String {
            return try dict[key] ?? { throw Error.notFoundValueForKey(key) }()
        }
        self.baseUrl = try value(for: "baseUrl")
        self.redirectUrl = try value(for: "redirectUrl")
        self.clientId = try value(for: "clientId")
        self.clientSecret = try value(for: "clientSecret")
    }
}
