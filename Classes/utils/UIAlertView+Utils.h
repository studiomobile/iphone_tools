//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Utils)

+ (UIAlertView*)alertViewWithErrorMessage:(NSString*)message;
+ (UIAlertView*)alertViewWithMessage: (NSString*)message;
+ (UIAlertView*)alertViewWithTitle:(NSString*)title;
+ (UIAlertView*)alertViewWithTitle:(NSString*)title message:(NSString*)message;
+ (UIAlertView*)alertViewWithTitle:(NSString*)title message:(NSString*)message buttonName:(NSString*)buttonName;
+ (UIAlertView*)yesNoAlertViewWithTitle:(NSString*)title message:(NSString*)message;
+ (UIAlertView*)showOneButtonAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

+ (UIAlertView*)showAlertViewErrorMessage:(NSString*)message;
+ (UIAlertView*)showAlertViewWithMessage:(NSString*)message;
+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title message:(NSString*)message;
+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title;
+ (UIAlertView*)showYesNoAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate;

- (UIAlertView*)showAndCall:(SEL)selector of:(id)obj;
- (UIAlertView*)showAndCall:(SEL)selector of:(id)obj withArgument:(id)arg;

@end
