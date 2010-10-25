//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "FilePath.h"

@interface ZippedFilePath : InMemoryFilePath {
	FilePath *archivePath;
	NSString *pathInArchive;
}
@property (nonatomic, readonly) FilePath *archivePath;
@property (nonatomic, readonly) NSString *pathInArchive;

+ (ZippedFilePath*)pathInArchive:(FilePath*)archivePath forFile:(NSString*)fileInArchive;

@end
