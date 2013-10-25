//
//  StringScoreTests.m
//  StringScoreTests
//
//  Created by Alex Gray on 10/25/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Score.h"

@interface StringScoreTests : XCTestCase
@property NSString *baseline, *same, *world, *wXrld, *HW;
@property NSArray *strings;
@end

@implementation StringScoreTests

- (void)setUp	{    [super setUp];

	_baseline = @"Hello world!";	_same = @"Hello world!";	_world = @"world";	_wXrld = @"wXrld";	_HW = @"HW";
	_strings = @[@"world", @3, @"wXrld", @"world", @"world",@"HW", NSNull.null];

}
- (void)testSame {	[_baseline scoreAgainst:_same];

	XCTAssertEqual(1.0, _same.stringScore, @"Should be equal.");
}

- (void)testFuzz {

	CGFloat   noFuzz		= [_baseline scoreAgainst:_wXrld];
	CGFloat   withFuzz	= [_baseline scoreAgainst:_wXrld fuzziness:@.8];
	XCTAssertNotEqual(withFuzz, noFuzz, @"Fuzz should effect score");
}

- (void) testReadme {


	NSString *testString = @"Hello world!";

	CGFloat result1 = [testString scoreAgainst:@"Hello world!"],
					result2 = [testString scoreAgainst:@"world"],
					result3 = [testString scoreAgainst:@"wXrld" fuzziness:@(0.8)],
					result4 = [testString scoreAgainst:@"world" fuzziness:nil options:NSStringScoreOptionFavorSmallerWords],
					result5 = [testString scoreAgainst:@"world" fuzziness:nil options:NSStringScoreOptionFavorSmallerWords | NSStringScoreOptionReducedLongStringPenalty],
					result6 = [testString scoreAgainst:@"HW"]; // abbreviation matching example

	XCTAssertEqual(result1,1.000,@"");
	XCTAssertEqual(result2,0.425,@"");
	XCTAssertEqual(result3,0.272,@"");
	XCTAssertEqual(result4,0.250,@"");
	XCTAssertEqual(result5,0.425,@"");
	XCTAssertEqual(result6,0.646,@"");
}

- (void) testArrays {  NSString *closest;

	closest = [_baseline closestMatch:_strings];
	XCTAssertTrue([_world isEqualToString:closest],@"World should be closest");

	closest = [_baseline closestMatch:[_strings arrayByAddingObject:_baseline]];
	XCTAssertTrue([_baseline isEqualToString:closest],@"baseline is same.. should be closest");
}

- (void) testStringScoreProperty {

	CGFloat same = [_baseline scoreAgainst:@"Hello world!"];
	XCTAssertEqual(_baseline.stringScore,1.0,@"stringScore should be 1.0 if equal.");
	XCTAssertEqual(_baseline.stringScore,same,@"score should be same as stringScore property.");

	CGFloat score = [_wXrld scoreAgainst:@"Hello world!"];
	XCTAssertEqual(_wXrld.stringScore,score,@"score should be same as stringScore property.");

}
//	NSLog(@" same.stringScore = %.3f", stringScore);
//
//	CGFloat   noFuzz	= [baseline scoreAgainst:wXrld],
//	withFuzz	= [baseline scoreAgainst:wXrld fuzziness:@.8],
//	noFuzzFvrSmall	= [baseline scoreAgainst:world fuzziness:nil options:NSStringScoreOptionFavorSmallerWords],
//	noFuzzFvrSmallAlt = [baseline scoreAgainst:world fuzziness:nil options:NSStringScoreOptionFavorSmallerWords | NSStringScoreOptionReducedLongStringPenalty];
//
//	NSLog(@"\
//				noFuzz = %.3f\n\
//				withFuzz = %.3f\n\
//				noFuzzFvrSmall = %.3f\n\
//				noFuzzFvrSmallAlt = %.3f", noFuzz, withFuzz,noFuzzFvrSmall, noFuzzFvrSmallAlt);


@end
