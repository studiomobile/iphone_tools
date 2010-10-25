//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "FilePath.h"

typedef enum {
    EncryptedFilePathEncryptionTypeAES,
    EncryptedFilePathEncryptionTypeDES,
} EncryptedFilePathEncryptionType;


@interface EncryptedFilePath : InMemoryFilePath {
	FilePath *encryptedFilePath;
    EncryptedFilePathEncryptionType encryptionType;
}
@property (nonatomic, readonly) FilePath *encryptedFilePath;
@property (nonatomic, readonly) EncryptedFilePathEncryptionType encryptionType;

+ (EncryptedFilePath*)encryptedFilePathWithFilePath:(FilePath*)path encryptionType:(EncryptedFilePathEncryptionType)encryptionType;

@end
