# StringScore
---
StringScore is an Objective-C library which provides super fast fuzzy string matching/scoring. Based on the [JavaScript library of the same name](https://github.com/joshaven/string_score), by [Joshaven Potter](https://github.com/joshaven).

---

### Using StringScore

StringScore adds 3 new methods to `NSString`:

    - (CGFloat) scoreAgainst:(NSString*)otherString;
    - (CGFloat) scoreAgainst:(NSString*)otherString fuzziness:(NSNumber*)fuzziness;
    - (CGFloat) scoreAgainst:(NSString*)otherString fuzziness:(NSNumber*)fuzziness 
                                                      options:(NSStringScoreOption)options;


All three methods return a `CGFloat` representing how closely the string
matched the `otherString` parameter.


## Additional Parameters

### Fuzziness

A number between 0 and 1 which varys how fuzzy/ the calculation is.
Defaults to `nil` (fuzziness disabled).

### Options

There are 3 options available: `NSStringScoreOptionNone`, `NSStringScoreOptionFavorSmallerWords` and `NSStringScoreOptionReducedLongStringPenalty`. Each of which is pretty self-explanatory, see example below for usage.


## Examples

Given the following sample application:


    NSString *testString = @"Hello world!";

    CGFloat result1 = [testString scoreAgainst:@"Hello world!"],
            result2 = [testString scoreAgainst:@"world"],
            result3 = [testString scoreAgainst:@"wXrld" fuzziness:@(0.8)],
            result4 = [testString scoreAgainst:@"world" fuzziness:nil options:NSStringScoreOptionFavorSmallerWords],
            result5 = [testString scoreAgainst:@"world" fuzziness:nil options:NSStringScoreOptionFavorSmallerWords | NSStringScoreOptionReducedLongStringPenalty],
            result6 = [testString scoreAgainst:@"HW"]; // abbreviation matching example

    NSLog(@"Result 1 = %.3f", result1); ➔ Result 1 = 1.000
    NSLog(@"Result 2 = %.3f", result2); ➔ Result 2 = 0.425
    NSLog(@"Result 3 = %.3f", result3); ➔ Result 3 = 0.272
    NSLog(@"Result 4 = %.3f", result4); ➔ Result 4 = 0.250
    NSLog(@"Result 5 = %.3f", result5); ➔ Result 5 = 0.425
    NSLog(@"Result 6 = %.3f", result6); ➔ Result 6 = 0.646


### Array Additions

In addition to the 3 base methods, there are some convenience methods to help compare a: a string ➔ an array of strings, or b: an array of items ➔ a string, and an option to associate an `NSString`'s fuzz-factor as a property...

    @interface NSString
	@property CGFloat fuzziness;
    - (NSString*) closestMatch:(NSArray*)inArray;

    @interface NSArray
    -  (NSString*) stringClosestToString:       (NSString*)someString;
    - (NSUInteger) indexOfStringClosestToString:(NSString*)someString;

Usage is..

    NSString * = [testString closestMatch:@[@"world", @3, @"wXrld", @"world", @"world",@"HW", NSNull.null]]; 
    NSLog(@"closest match.. %@.. %f", close, close.fuzziness);

	closest match.. world.. 0.528889




## Credits

Author: [Nicholas Bruning](https://github.com/thetron)

Special thanks to [Joshaven Potter](https://github.com/joshaven) for
providing the basis for this library.


## License

Licensed under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
