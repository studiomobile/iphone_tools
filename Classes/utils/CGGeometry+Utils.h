//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <UIKit/UIKit.h>

CGRect CGRectConsume(CGRect r, CGPoint pt);
CGSize CGSizeFitIntoSize(CGSize original, CGSize fitInto);

CGPoint CGRectCenter(CGRect r);
CGRect CGRectCenterToPoint(CGRect original, CGPoint newCenter);
CGRect CGRectCenterToRect(CGRect original, CGRect otherRect);

CGFloat CGPointDistanceToPoint(CGPoint point1, CGPoint point2);