//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

- (NSString*)joinWith:(NSString*)d selector:(SEL)s {
    if(!self.count) return @"";
    
    NSMutableString *result = [NSMutableString string];
    for(NSObject *item in self) {
        [result appendFormat:@"%@%@", [item performSelector:s], d];
    }
    
    if(result.length)
        [result replaceCharactersInRange:NSMakeRange(result.length - d.length, d.length) 
                              withString:@""];
    
    return [NSString stringWithString:result];
}


- (NSString*)joinWith:(NSString*)d {
    return [self joinWith:d selector:@selector(description)];
}


@end






