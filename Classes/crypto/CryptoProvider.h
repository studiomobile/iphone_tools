//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

@interface CryptoProvider : NSObject {
}

+ (NSData*)decryptAESData:(NSData*)data;

+ (NSData*)decryptDESData:(NSData*)data;

@end
