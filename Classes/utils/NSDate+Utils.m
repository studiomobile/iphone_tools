//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (BOOL)isAfter:(NSDate*)other {
	return [self compare:other] == NSOrderedDescending;
}


- (BOOL)isBefore:(NSDate*)other {
	return [self compare:other] == NSOrderedAscending;
}


- (NSDate*)dayStart {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	return [calendar dateFromComponents:components];
}


- (NSDate*)shiftDays:(NSInteger)shift {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents new] autorelease];
    comps.day = shift;
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}


- (NSDate*)nextDay {
    return [self shiftDays:1];
}


- (NSDate*)previousDay {
    return [self shiftDays:-1];
}


- (NSDate*)firstDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    comps.day = 1;
    return [calendar dateFromComponents:comps];
}


- (NSDate*)shiftMonths:(NSInteger)shift {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents new] autorelease];
    comps.month = shift;
    return [calendar dateByAddingComponents:comps toDate:self options:0];
}


@end
