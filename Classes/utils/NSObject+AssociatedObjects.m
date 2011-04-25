//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "NSObject+AssociatedObjects.h"
#import <objc/runtime.h>

@implementation NSObject (AssociatedObjects)

- (void)setAssociatedObject:(id)obj forKey:(void*)key {
    objc_setAssociatedObject(self, key, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (id)associatedObjectForKey:(void*)key {
    return objc_getAssociatedObject(self, key);
}


@end
