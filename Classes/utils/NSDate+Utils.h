//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils) 

+ (NSDate*)today;

- (BOOL)isAfter:(NSDate*)other;
- (BOOL)isBefore:(NSDate*)other;

- (NSDate*)dayStart;

- (NSDate*)shiftDays:(NSInteger)shift;
- (NSDate*)nextDay;
- (NSDate*)previousDay;

- (NSDate*)firstDayOfMonth;
- (NSDate*)shiftMonths:(NSInteger)shift;

@end

