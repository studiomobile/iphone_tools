//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <Foundation/Foundation.h>

@interface NSObject (Invocation)

+ (NSInvocation*)invocationForClassMethod:(SEL)selector;

- (NSInvocation*)invocationForMethod:(SEL)selector;

@end
