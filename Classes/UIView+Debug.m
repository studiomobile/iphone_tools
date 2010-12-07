//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "UIView+Debug.h"

@implementation UIView (Debug)

- (NSMutableString*)addHierarchyTo:(NSMutableString*)hierarchyString prefix:(NSString*)prefix {
	[hierarchyString appendFormat:@"%@%@ [%d]\n", prefix, self, self.tag];
	
	for(UIView *v in self.subviews){
		[v addHierarchyTo:hierarchyString prefix:[prefix stringByAppendingString:@"  "]];
	}
	
	return hierarchyString;
}


- (NSString*)hierarchyString {
	return [[[self addHierarchyTo:[NSMutableString string] prefix: @""] copy] autorelease];
}


- (void)dumpHierarchy {
    NSLog(@"\n%@", [self hierarchyString]);
}


@end