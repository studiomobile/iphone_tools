//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

@interface NSObject (AssociatedObjects)

- (void)setAssociatedObject:(id)obj forKey:(void*)key;
- (id)associatedObjectForKey:(void*)key;

@end
