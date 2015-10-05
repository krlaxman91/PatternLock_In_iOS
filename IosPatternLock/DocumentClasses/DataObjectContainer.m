//
//  DataObjectContainer.m
//  IosPatternLock
//
//  Created by Laxman on 05/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "DataObjectContainer.h"

@implementation DataObjectContainer
{
    PatternDocument *_patternDocument;
}

static DataObjectContainer *_instance = nil;

#pragma mark -Services

+ (DataObjectContainer*)sharedInstance
{
    @synchronized(self) {
        
        if (_instance == nil) {
            _instance = [[DataObjectContainer alloc] init];
        }
    }
    return _instance;
}

- (PatternDocument*)patternDocument
{
    if (_patternDocument == nil) {
        _patternDocument = [[PatternDocument alloc] init];
    }
    return _patternDocument;
}

@end
