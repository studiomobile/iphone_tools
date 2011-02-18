//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "CryptoProvider.h"


@implementation CryptoProvider


+ (NSData*)decryptAESData:(NSData*)data {
    size_t dataInLen = data.length;
    const unsigned char *dataIn = [data bytes];

    uint8_t keyphrase[kCCKeySizeAES128];
    memcpy(keyphrase, dataIn, kCCKeySizeAES128);
    dataIn += kCCKeySizeAES128;
    dataInLen -= kCCKeySizeAES128;

    const size_t kIVLen = 16;

    uint8_t cryptoiv[kIVLen];
    memcpy(cryptoiv, dataIn, kIVLen);
    dataIn += kIVLen;
    dataInLen -= kIVLen;

    const int dataOutLen = dataInLen * 2;
    char *dataOut = (char*) malloc(dataOutLen);
    memset(dataOut, 0, dataOutLen);

    size_t decryptedDataLen = 0;

    CCCryptorStatus status = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     keyphrase,
                                     kCCKeySizeAES128,
                                     cryptoiv,
                                     dataIn,
                                     dataInLen,
                                     dataOut,
                                     dataOutLen,
                                     &decryptedDataLen);

    NSData *result = nil;
    if (status == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:dataOut length:decryptedDataLen freeWhenDone:YES];
    } else {
        free(dataOut);
#ifdef TARGET_IPHONE_SIMULATOR
        NSLog(@"Decrypt failed with status: %d", status);
#endif
    }
    return result;
}


+ (NSData*)decryptDESData:(NSData*)data {
	if (!data) return nil;

	size_t dataInLen = data.length;
	const unsigned char *dataIn = [data bytes];

	uint8_t keyphrase[kCCKeySizeDES];
	memcpy(keyphrase, dataIn, kCCKeySizeDES);
	dataIn += kCCKeySizeDES;
    dataInLen -= kCCKeySizeDES;

	size_t dataOutLen = dataInLen * 2;
	char *dataOut = (char*) malloc(dataOutLen);
	memset(dataOut, 0, dataOutLen);

	size_t decryptedDataLen = 0;

	CCCryptorStatus status = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmDES,
                                     0,
                                     keyphrase,
                                     kCCKeySizeDES,
                                     nil,
                                     dataIn,
                                     dataInLen,
                                     dataOut,
                                     dataOutLen,
                                     &decryptedDataLen);

    NSData *result = nil;
    if (status == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:dataOut length:decryptedDataLen freeWhenDone:YES];
    } else {
        free(dataOut);
#ifdef TARGET_IPHONE_SIMULATOR
        NSLog(@"Decrypt failed with status: %d", status);
#endif
    }
    return result;
}


@end
