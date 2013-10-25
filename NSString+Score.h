//
//  NSString+Score.h
//
//  Created by Nicholas Bruning on 5/12/11.
//  Copyright (c) 2011 Involved Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM (NSUInteger, NSStringScoreOption) { NSStringScoreOptionNone                     = 1 << 0,
																										NSStringScoreOptionFavorSmallerWords        = 1 << 1,
																										NSStringScoreOptionReducedLongStringPenalty	= 1 << 2	};

@interface NSString (Score)

@property CGFloat stringScore;
- (NSString*) closestMatch:(NSArray*)inArray;
-   (CGFloat) scoreAgainst:(NSString*)otherString;
-   (CGFloat) scoreAgainst:(NSString*)otherString fuzziness:(NSNumber*)fuzziness;
-   (CGFloat) scoreAgainst:(NSString*)otherString fuzziness:(NSNumber*)fuzziness options:(NSStringScoreOption)options;

@end

@interface NSArray (Score)
-  (NSString*) stringClosestToString:				(NSString*)someString;
- (NSUInteger) indexOfStringClosestToString:(NSString*)someString;
@end