//
//  DataObjectContainer.swift
//  SamplePattern
//
//  Created by Laxman on 19/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class DataObjectContainer: NSObject {
    static var instance: DataObjectContainer? = nil
    
    class var sharedInstance: DataObjectContainer {
        if instance == nil {
            instance = DataObjectContainer()
        }
        return instance!
    }
    
    lazy var patternDocument: PatternDocument = {
        let patternDocument = PatternDocument()
        return patternDocument
        }()
}
