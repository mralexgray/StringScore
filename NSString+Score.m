//
//  NSString+Score.m
//
//  Created by Nicholas Bruning on 5/12/11.
//  Copyright (c) 2011 Involved Pty Ltd. All rights reserved.
//

//score reference: http://jsfiddle.net/JrLVD/

#import "NSString+Score.h"


@implementation NSArray (Score)
-  (NSString*) stringClosestToString:				(NSString*)someString { return [someString closestMatch:self]; }
- (NSUInteger) indexOfStringClosestToString:(NSString*)someString {
		return [self indexOfObject:[self stringClosestToString:someString]];
}
@end

@implementation NSString (Score)

- (NSString*) closestMatch:(NSArray*)inArray { __block CGFloat match = 0.0; __block NSString *closest = nil;

	[inArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { if (![obj isKindOfClass:NSString.class]) return;

		CGFloat newMatch = [self scoreAgainst:obj];
		if (newMatch > match) (closest = obj).stringScore = match = newMatch;
		if (match == 1.0) *stop = YES;
	}];
	return closest;
}
-    (void) setStringScore:(CGFloat)score		{	objc_setAssociatedObject(self,@selector(stringScore),@(score),OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (CGFloat) stringScore											{ return [objc_getAssociatedObject(self,_cmd)floatValue]; }
- (CGFloat) scoreAgainst:(NSString*)otherString{
    return (self.stringScore = [self scoreAgainst:otherString fuzziness:nil]);
}
- (CGFloat) scoreAgainst:(NSString*)otherString fuzziness:(NSNumber*)fuzziness{
    return (self.stringScore = [self scoreAgainst:otherString fuzziness:fuzziness options:NSStringScoreOptionNone]);
}
- (CGFloat) scoreAgainst:(NSString*)anotherString fuzziness:(NSNumber*)fuzziness options:(NSStringScoreOption)options{

    NSMutableCharacterSet *workingInvalidCharacterSet = NSCharacterSet.lowercaseLetterCharacterSet;
    [workingInvalidCharacterSet formUnionWithCharacterSet:NSCharacterSet.uppercaseLetterCharacterSet];
    [workingInvalidCharacterSet addCharactersInString:@" "];
    NSCharacterSet *invalidCharacterSet = workingInvalidCharacterSet.invertedSet;
    
    NSString *string =			[[self.decomposedStringWithCanonicalMapping					 componentsSeparatedByCharactersInSet:invalidCharacterSet]
																																														 componentsJoinedByString:@""];
    NSString *otherString = [[anotherString.decomposedStringWithCanonicalMapping componentsSeparatedByCharactersInSet:invalidCharacterSet]
																																														 componentsJoinedByString:@""];

	if([string isEqualToString:otherString]) return 1.0f;  // If the string is equal to the abbreviation, perfect match.
	if(!otherString.length)									 return 0.0f;  //if it's not a perfect match and is empty return 0

    CGFloat     otherStringLength	= otherString.length,
										 stringLength = string.length,
							totalCharacterScore	= 0,
	                        fuzzies = 1, otherStringScore, finalScore;
    BOOL       startOfStringBonus	= NO;
    for(NSUInteger index = 0; index < otherStringLength; index++){     // Walk through abbreviation and add up scores.
        CGFloat    characterScore	= 0.1;
        NSInteger   indexInString	= NSNotFound;
        NSString            * chr	= [otherString substringWithRange:NSMakeRange(index, 1)];
        //make these next few lines leverage NSNotfound, methinks.
        NSRange rangeChrLowercase = [string rangeOfString:chr.lowercaseString],
								rangeChrUppercase = [string rangeOfString:chr.uppercaseString];
        
        if(rangeChrLowercase.location == NSNotFound && rangeChrUppercase.location == NSNotFound)
            if(fuzziness) fuzzies += 1 - fuzziness.floatValue; else  return 0; // this is an error!
        else if (rangeChrLowercase.location != NSNotFound && rangeChrUppercase.location != NSNotFound)
            indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
				else if(rangeChrLowercase.location != NSNotFound || rangeChrUppercase.location != NSNotFound)
            indexInString = rangeChrLowercase.location != NSNotFound ? rangeChrLowercase.location : rangeChrUppercase.location;
				else indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
        // Set base score for matching chr  Same case bonus.
        if(indexInString != NSNotFound && [[string substringWithRange:NSMakeRange(indexInString, 1)] isEqualToString:chr]) characterScore += 0.1;
        if(indexInString == 0){												// Consecutive letter & start-of-string bonus
            characterScore += 0.6;										// Increase the score when matching first character of the remainder of the string
            if(index == 0) startOfStringBonus = YES;	// If match is the 1st char. of string & 1st char of abbreviation, add a start-of-string match bonus.
        } else if(indexInString != NSNotFound)
					// Acronym Bonus. Weighing Logic: Typing the first character of an acronym is as if you preceded it with two perfect character matches.
				if([[string substringWithRange:NSMakeRange(indexInString - 1, 1)] isEqualToString:@" "])
						characterScore += 0.8;
        // Left trim the already matched part of the string. (forces sequential matching).
        if(indexInString != NSNotFound) string = [string substringFromIndex:indexInString + 1];
        totalCharacterScore += characterScore;
    }
    if(NSStringScoreOptionFavorSmallerWords == (options & NSStringScoreOptionFavorSmallerWords))
			return totalCharacterScore / stringLength; // Weigh smaller words higher

    otherStringScore = totalCharacterScore / otherStringLength;
    if(NSStringScoreOptionReducedLongStringPenalty == (options & NSStringScoreOptionReducedLongStringPenalty)){
        // Reduce the penalty for longer words
        CGFloat percentageOfMatchedString = otherStringLength / stringLength,
															  wordScore	= otherStringScore * percentageOfMatchedString;
															 finalScore	= (wordScore + otherStringScore) / 2.0;
    } else finalScore = ((otherStringScore * ((CGFloat)(otherStringLength) / (CGFloat)(stringLength))) + otherStringScore) / 2.0;
    finalScore = finalScore / fuzzies;
    if(startOfStringBonus && finalScore + 0.15 < 1) finalScore += 0.15;
    return (self.stringScore = finalScore);
}


@end
