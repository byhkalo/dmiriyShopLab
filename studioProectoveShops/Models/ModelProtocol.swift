//
//  ModelProtocol.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/1/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation

protocol ModelProtocol {
    func dictionaryPresentation() -> Dictionary<String, Any>
    static func listDictionaryPresentation(models: [ModelProtocol]?) -> Array<Dictionary<String, Any>>
}

extension ModelProtocol {
    
    static func listDictionaryPresentation(models: [ModelProtocol]?) -> Array<Dictionary<String, Any>> {
        var presentDict: Array<Dictionary<String, Any>> = []
        if let models = models {
            for helpModel in models {
                presentDict.append(helpModel.dictionaryPresentation())
            }
        }
        
        return presentDict
    }
    
}
