//
//  DataObjectContainer.h
//  IosPatternLock
//
//  Created by Laxman on 05/10/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatternDocument.h"

@interface DataObjectContainer : NSObject

@property(nonatomic,readonly)PatternDocument *patternDocument;

+ (DataObjectContainer*)sharedInstance;

@end
