//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "FilePath.h"
#import "NSCoding.h"

@implementation FilePath

- (NSString*)absolutePathString { assert(FALSE); }
- (FilePath*)pathByAppendingPathComponent:(NSString*)component { assert(FALSE); }
- (FilePath*)pathByDeletingLastPathComponent { assert(FALSE); }
- (FilePath*)pathByAppendingPathExtension:(NSString*)extension { assert(FALSE); }
- (FilePath*)pathByDeletingPathExtension { assert(FALSE); }

- (NSData*)readData {
	return [NSData dataWithContentsOfFile:self.absolutePathString];
}

- (void)writeData:(NSData*)data error:(NSError**)error {
	NSString *filePath = self.absolutePathString;
	[[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:error];
	[data writeToFile:filePath options:0 error:error];
}

- (NSUInteger)hash { return [[self absolutePathString] hash]; }

- (BOOL)isEqual:(id)obj {
	if (![obj isKindOfClass:self.class]) return NO;
	return [self.absolutePathString isEqual:[obj absolutePathString]];
}

@end


@implementation FSFilePath

+ (FSFilePath*)fsFilePathWithPath:(NSString*)path {
    return [[[self alloc] initWithPath:path] autorelease];
}


- (id)initWithPath:(NSString*)_path {
    if (![super init]) return nil;
    path = [_path copy];
    return self;
}


- (void)dealloc {
    [path release];
    [super dealloc];
}


- (id)initWithCoder:(NSCoder *)decoder {
	if (![super init]) return nil;
    DECODEOBJECT(path);
	return self;
}


- (void)encodeWithCoder:(NSCoder*)coder {
	ENCODEOBJECT(path);
}


- (NSString*)absolutePathString { return path; }


- (NSString*)description { return [NSString stringWithFormat:@"FSFilePath: %@", path]; }


- (FilePath*)pathByAppendingPathComponent:(NSString*)component {
    return [FSFilePath fsFilePathWithPath:[path stringByAppendingPathComponent:component]];
}

- (FilePath*)pathByDeletingLastPathComponent {
    return [FSFilePath fsFilePathWithPath:[path stringByDeletingLastPathComponent]];
}

- (FilePath*)pathByAppendingPathExtension:(NSString*)extension {
    return [FSFilePath fsFilePathWithPath:[path stringByAppendingPathExtension:extension]];
}

- (FilePath*)pathByDeletingPathExtension {
    return [FSFilePath fsFilePathWithPath:[path stringByDeletingPathExtension]];
}

- (void)deleteFile:(NSError**)error {
	[[NSFileManager defaultManager] removeItemAtPath:[self absolutePathString] error:error];
}

@end


@implementation BundleFilePath

- (id)initWithFilePathInBundle:(NSString*)filePath {
	if (![super init]) return nil;
    pathInBundle = [filePath retain];
	return self;
}


+ (BundleFilePath*)pathInBundleForFile:(NSString*)filePath {
	return [[[BundleFilePath alloc] initWithFilePathInBundle:filePath] autorelease];
}


- (id)initWithCoder:(NSCoder *)decoder {
	if (![super init]) return nil;
    DECODEOBJECT(pathInBundle);
	return self;
}


- (void)encodeWithCoder:(NSCoder*)coder {
	ENCODEOBJECT(pathInBundle);
}


- (NSString*)absolutePathString {
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pathInBundle];
}


- (NSString*)description { return [NSString stringWithFormat:@"BundleFilePath: %@", pathInBundle]; }


- (FilePath*)pathByAppendingPathComponent:(NSString*)component {
	return [BundleFilePath pathInBundleForFile:[pathInBundle stringByAppendingPathComponent:component]];
}

- (FilePath*)pathByDeletingLastPathComponent {
	return [BundleFilePath pathInBundleForFile:[pathInBundle stringByDeletingLastPathComponent]];
}

- (FilePath*)pathByAppendingPathExtension:(NSString*)extension {
	return [BundleFilePath pathInBundleForFile:[pathInBundle stringByAppendingPathExtension:extension]];
}

- (FilePath*)pathByDeletingPathExtension {
	return [BundleFilePath pathInBundleForFile:[pathInBundle stringByDeletingPathExtension]];
}


- (void)dealloc {
	[pathInBundle release];
	[super dealloc];
}

@end


@implementation DocumentsFilePath

- (id)initWithFilePathInDocuments:(NSString*)filePath {
	if (![super init]) return nil;
    pathInDocuments = [filePath retain];
	return self;
}


+ (DocumentsFilePath*)pathInDocumentsForFile:(NSString*)filePath {
	return [[[DocumentsFilePath alloc] initWithFilePathInDocuments:filePath] autorelease];
}


- (id)initWithCoder:(NSCoder *)decoder {
	if (![super init]) return nil;
    DECODEOBJECT(pathInDocuments);
	return self;
}


- (void)encodeWithCoder:(NSCoder*)coder {
	ENCODEOBJECT(pathInDocuments);
}


- (NSString*)absolutePathString {
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:pathInDocuments];
}


- (NSString*)description { return [NSString stringWithFormat:@"DocumentsFilePath: %@", pathInDocuments]; }


- (FilePath*)pathByAppendingPathComponent:(NSString*)component {
    return [DocumentsFilePath pathInDocumentsForFile:[pathInDocuments stringByAppendingPathComponent:component]];
}

- (FilePath*)pathByDeletingLastPathComponent {
    return [DocumentsFilePath pathInDocumentsForFile:[pathInDocuments stringByDeletingLastPathComponent]];
}

- (FilePath*)pathByAppendingPathExtension:(NSString*)extension {
	return [DocumentsFilePath pathInDocumentsForFile:[pathInDocuments stringByAppendingPathExtension:extension]];
}

- (FilePath*)pathByDeletingPathExtension {
	return [DocumentsFilePath pathInDocumentsForFile:[pathInDocuments stringByDeletingPathExtension]];
}

- (void)deleteFile:(NSError**)error {
	[[NSFileManager defaultManager] removeItemAtPath:[self absolutePathString] error:error];
}

- (void)dealloc {
	[pathInDocuments release];
	[super dealloc];
}

@end


@implementation InMemoryFilePath

- (NSData*)readCachedData {
    if (temporaryFilePath && [[NSFileManager defaultManager] fileExistsAtPath:temporaryFilePath.absolutePathString]) {
        return [NSData dataWithContentsOfFile:temporaryFilePath.absolutePathString];
    }
    return nil;
}


- (NSString*)absolutePathString {
	if (!temporaryFilePath) {
		NSInteger attemptsLeft = 5;
        NSData *data = [self readData];
		while (data && !temporaryFilePath && attemptsLeft-- > 0) {
			NSString *fileName = [NSString stringWithCString:tmpnam(nil) encoding:NSASCIIStringEncoding];
			DocumentsFilePath *documentsfilePath = [DocumentsFilePath pathInDocumentsForFile:fileName];
			if (![[NSFileManager defaultManager] fileExistsAtPath:documentsfilePath.absolutePathString]) {
				NSError *error = nil;
				[documentsfilePath writeData:data error:&error];
				if (!error) {
					temporaryFilePath = [documentsfilePath retain];
				}
			}
		}
	}
	return temporaryFilePath.absolutePathString;
}


- (void)dealloc {
    if (temporaryFilePath) {
		[[NSFileManager defaultManager] removeItemAtPath:temporaryFilePath.absolutePathString error:nil];
	}
    [temporaryFilePath release];
    [super dealloc];
}

@end
