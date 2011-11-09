//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

@interface FilePath : NSObject {
}
@property (readonly) NSString *absolutePathString;

- (FilePath*)pathByAppendingPathComponent:(NSString*)component;
- (FilePath*)pathByDeletingLastPathComponent;

- (FilePath*)pathByAppendingPathExtension:(NSString*)extension;
- (FilePath*)pathByDeletingPathExtension;

- (NSData*)readData;
- (BOOL)copyData:(FilePath*)to;
- (void)writeData:(NSData*)data error:(NSError**)error;

@end;


@interface FSFilePath : FilePath {
    NSString *path;
}
+ (FSFilePath*)fsFilePathWithPath:(NSString*)path;
- (void)deleteFile:(NSError**)error;
@end


@interface BundleFilePath : FilePath {
	NSString *pathInBundle;
}
+ (BundleFilePath*)pathInBundleForFile:(NSString*)filePath;
@end


@interface DocumentsFilePath : FilePath {
	NSString *pathInDocuments;
}
+ (DocumentsFilePath*)pathInDocumentsForFile:(NSString*)filePath;
- (void)deleteFile:(NSError**)error;
@end


@interface InMemoryFilePath : FilePath {
	FilePath *temporaryFilePath;
}
- (NSData*)readCachedData;
@end
