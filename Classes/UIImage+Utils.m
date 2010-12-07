//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "UIImage+Utils.h"
#import "CGGeometry+Utils.h"

CGContextRef BeginBitmapContextWithSize(CGSize size) {
	UIGraphicsBeginImageContext(size);
	return UIGraphicsGetCurrentContext();
}


UIImage* EndBitmapContext() {
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}


static CGRect swapWidthAndHeight(CGRect rect) {
    CGFloat  swap = rect.size.width;
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    return rect;
}


@implementation UIImage  (Utils)

+ (UIImage*)imageFromURL:(NSString*)urlString {
	NSURL *url = [NSURL URLWithString:urlString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[[UIImage alloc] initWithData:data] autorelease];
	return img;
}


- (UIImage*)scaleToSize:(CGSize)size {
	CGContextRef context = BeginBitmapContextWithSize(size);
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);

	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);

	return EndBitmapContext();
}


- (UIImage*)fitToSize:(CGSize)size{
	return [self scaleToSize:CGSizeFitIntoSize(self.size, size)];
}


- (UIImage*)cropToRect:(CGRect)rect {
	CGContextRef context = BeginBitmapContextWithSize(rect.size);

 	CGContextTranslateCTM(context, 0.0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect(context, clippedRect);

    CGRect drawRect = CGRectMake(-rect.origin.x ,
                                 -(self.size.height - rect.size.height - rect.origin.y),
                                 self.size.width,
                                 self.size.height);

    CGContextDrawImage(context, drawRect, self.CGImage);

    return EndBitmapContext();
}


- (UIImage*)flipHorizontal {
	CGContextRef context = BeginBitmapContextWithSize(self.size);
    CGContextTranslateCTM(context, self.size.width, self.size.height);
    CGContextScaleCTM(context, -1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);

    return EndBitmapContext();
}


- (UIImage*)rotateToOrientation:(UIImageOrientation)orient {
    CGRect bnds = CGRectZero;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;

    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);

    bnds = rect;

    switch (orient) {
        case UIImageOrientationUp:
            return self;

        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;

        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width, rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;

        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;

        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;

        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }

    CGContextRef context = BeginBitmapContextWithSize(bnds.size);

    switch (orient) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(context, -1.0, 1.0);
            CGContextTranslateCTM(context, -rect.size.height, 0.0);
            break;

        default:
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0.0, -rect.size.height);
            break;
    }

    CGContextConcatCTM(context, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);

    return EndBitmapContext();
}


- (UIImage*)withFixedOrientation{
	return [self rotateToOrientation: self.imageOrientation];
}

@end
