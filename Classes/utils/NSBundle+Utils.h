//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <Foundation/Foundation.h>

@interface NSBundle (Utils)

- (id)loadPlist:(NSString*)name errorDescription:(NSString**)errorDescription;

@end
