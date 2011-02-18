//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "UIAlertView+Utils.h"
#import "NSObject+Invocation.h"

@interface UIAlertViewCallback : NSObject<UIAlertViewDelegate>{
	NSInvocation* invocation;
}
@property(retain) NSInvocation* invocation;

+ (UIAlertViewCallback*)alertViewCallbackWithDelegate:(id)delegate selector:(SEL)selector;
+ (UIAlertViewCallback*)alertViewCallbackWithDelegate:(id)delegate selector:(SEL)selector argument:(id)arg;

@end

@implementation UIAlertView (Utils)

- (UIAlertView*)showOnMainThread{
	[self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    return self;
}


+ (UIAlertView*)yesNoAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertView* alert = [[[self alloc] initWithTitle:title
                                 message:message
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"No", nil)
                       otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] autorelease];
	return alert;
}


+ (UIAlertView*)alertViewWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertView *alert = [[[self alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil] autorelease];
	return alert;
}


+ (UIAlertView*)alertViewWithErrorMessage:(NSString*)message{
	UIAlertView* alert = [self alertViewWithTitle: NSLocalizedString(@"Error", nil) message:message];
	return alert;
}


+ (UIAlertView*)alertViewWithMessage:(NSString*)message{
	return [self alertViewWithTitle:nil message:message];
}


+ (UIAlertView*)alertViewWithTitle:(NSString*)title {
	return [self alertViewWithTitle:title message:nil];
}


+ (UIAlertView *)showOneButtonAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate {
	UIAlertView *alert = [[[self alloc] initWithTitle:title
													 message:message
													delegate:delegate
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil] autorelease];
	[alert show];
	return alert;	
}


+ (UIAlertView*)showAlertViewErrorMessage:(NSString*)message {
	UIAlertView* alert = [self alertViewWithErrorMessage: message];
    return [alert showOnMainThread];
}


+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertView *alert = [self alertViewWithTitle:title message:message];    
	return [alert showOnMainThread];
}


+ (UIAlertView*)showAlertViewWithMessage:(NSString*)message {
	UIAlertView *alert = [self alertViewWithMessage: message];
	return [alert showOnMainThread];
}


+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title {
	UIAlertView *alert = [self alertViewWithTitle: title];
	return [alert showOnMainThread];
}


+ (UIAlertView*)showYesNoAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate {
	UIAlertView* alert = [self yesNoAlertViewWithTitle:title message:message];
	alert.delegate = delegate;
	return [alert showOnMainThread];
}


- (UIAlertView*)showAndCall:(SEL)selector of:(id)obj {
	UIAlertViewCallback* cb = [UIAlertViewCallback alertViewCallbackWithDelegate:obj selector:selector];
	self.delegate = [cb retain];
	return [self showOnMainThread];
}


- (UIAlertView*)showAndCall:(SEL)selector of:(id)obj withArgument:(id)arg {
	UIAlertViewCallback* cb = [UIAlertViewCallback alertViewCallbackWithDelegate:obj selector:selector argument: arg];
	self.delegate = [cb retain];
	return [self showOnMainThread];	
}

@end
	
@implementation UIAlertViewCallback

@synthesize invocation;

- (id)initWithDelegate:(id)delegate selector:(SEL)selector {
	self = [super init];
	if (self != nil) {
		self.invocation = [delegate invocationForMethod:selector];
	}
    
	return self;
}


+ (UIAlertViewCallback*)alertViewCallbackWithDelegate:(id)delegate selector:(SEL)selector {
	return [[[self alloc] initWithDelegate:delegate selector:selector] autorelease];
}


+ (UIAlertViewCallback*)alertViewCallbackWithDelegate:(id)delegate selector:(SEL)selector argument:(id)arg {
	UIAlertViewCallback* inst = [[[self alloc] initWithDelegate:delegate selector:selector] autorelease];
	[inst.invocation setArgument: &arg atIndex:2];
	[inst.invocation retainArguments];
	return inst;	
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[invocation invoke];
	[self release];
}


#pragma mark init/deinit

- (void)dealloc {
	[invocation release];
    
	[super dealloc];
}
	
@end
