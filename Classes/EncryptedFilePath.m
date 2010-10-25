//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "EncryptedFilePath.h"
#import "NSCoding.h"
#import "CryptoProvider.h"


@implementation EncryptedFilePath

@synthesize encryptedFilePath;
@synthesize encryptionType;


- (id)initWithFilePath:(FilePath*)path encryptionType:(EncryptedFilePathEncryptionType)_encryptionType {
	if (![super init]) return nil;
	encryptedFilePath = [path retain];
    encryptionType = _encryptionType;
	return self;
}


+ (EncryptedFilePath*)encryptedFilePathWithFilePath:(FilePath*)path encryptionType:(EncryptedFilePathEncryptionType)encryptionType {
	return [[[self alloc] initWithFilePath:path encryptionType:encryptionType] autorelease];
}


- (id)initWithCoder:(NSCoder *)decoder {
	if (![super init]) return nil;
    DECODEOBJECT(encryptedFilePath);
    DECODEINT(encryptionType);
	return self;
}


- (void)encodeWithCoder:(NSCoder*)coder {
	ENCODEOBJECT(encryptedFilePath);
    ENCODEINT(encryptionType);
}


- (NSData*)readData {
    NSData *data = [self readCachedData];
    if (data) return data;
    
    data = [encryptedFilePath readData];
    switch (encryptionType) {
        case EncryptedFilePathEncryptionTypeAES: return [CryptoProvider decryptAESData:data];
        case EncryptedFilePathEncryptionTypeDES: return [CryptoProvider decryptDESData:data];
    }
    return data;
}


- (NSUInteger)hash { return [encryptedFilePath hash]; }


- (BOOL)isEqual:(id)obj {
	if (![obj isKindOfClass:self.class]) return NO;
    EncryptedFilePath *encrypted = (EncryptedFilePath*)obj;
	return encryptionType == encrypted.encryptionType && [encryptedFilePath isEqual:encrypted.encryptedFilePath];
}


- (void)dealloc {
    [encryptedFilePath release];
    [super dealloc];
}

@end
