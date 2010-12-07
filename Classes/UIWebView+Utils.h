//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <UIKit/UIKit.h>

@interface UIWebView (Utils)

@property (readonly, nonatomic) BOOL loaded;

- (void)loadLocalHTMLString:(NSString*)htmlString;
- (void)loadLocalHTMLFileFromMainBundle:(NSString*)name;
- (void)loadLocalHTMLFileFromMainBundle:(NSString*)name directory:(NSString*)directory;

@end
