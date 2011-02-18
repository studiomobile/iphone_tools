//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "ZippedFilePath.h"
#import "NSCoding.h"
#import "unzip.h"


@implementation ZippedFilePath

@synthesize archivePath;
@synthesize pathInArchive;


- (id)initWithArchivePath:(FilePath*)_archivePath pathInArchive:(NSString*)_pathInArchive {
	if (![super init]) return nil;
    archivePath = [_archivePath retain];
    pathInArchive = [_pathInArchive retain];
	return self;
}


+ (ZippedFilePath*)pathInArchive:(FilePath*)archivePath forFile:(NSString*)fileInArchive {
	return [[[ZippedFilePath alloc] initWithArchivePath:archivePath pathInArchive:fileInArchive] autorelease];
}


- (id)initWithCoder:(NSCoder *)decoder {
	if (![super init]) return nil;
    DECODEOBJECT(archivePath);
    DECODEOBJECT(pathInArchive);
	return self;
}


- (void)encodeWithCoder:(NSCoder*)coder {
	ENCODEOBJECT(archivePath);
	ENCODEOBJECT(pathInArchive);
}


- (NSString*)description { return [NSString stringWithFormat:@"ZippedFilePath: %@ : %@", archivePath, pathInArchive]; }


- (NSUInteger)hash { return [archivePath hash] + 29 * [pathInArchive hash]; }


- (BOOL)isEqual:(id)obj {
	if (![obj isKindOfClass:self.class]) return NO;
    ZippedFilePath *zipped = (ZippedFilePath*)obj;
	return [archivePath isEqual:zipped.archivePath] && [pathInArchive isEqual:zipped.pathInArchive];
}


- (FilePath*)pathByAppendingPathComponent:(NSString*)component {
	return [ZippedFilePath pathInArchive:archivePath forFile:[pathInArchive stringByAppendingPathComponent:component]];
}

- (FilePath*)pathByDeletingLastPathComponent {
	return [ZippedFilePath pathInArchive:archivePath forFile:[pathInArchive stringByDeletingLastPathComponent]];
}

- (FilePath*)pathByAppendingPathExtension:(NSString*)extension {
	return [ZippedFilePath pathInArchive:archivePath forFile:[pathInArchive stringByAppendingPathExtension:extension]];
}

- (FilePath*)pathByDeletingPathExtension {
	return [ZippedFilePath pathInArchive:archivePath forFile:[pathInArchive stringByDeletingPathExtension]];
}


- (NSData*)readData {
	NSMutableData *data = (id)[self readCachedData];
    if (data) return data;
    
	int error = UNZ_OK;
	unzFile archive = NULL;
    unz_file_info fileInfo;
	char buffer[4096];
    
	do {
		archive = unzOpen([archivePath.absolutePathString cStringUsingEncoding:NSASCIIStringEncoding]);
		if (!archive) break;
        
		error = unzLocateFile(archive, [pathInArchive cStringUsingEncoding:NSASCIIStringEncoding], 1);
		if (error != UNZ_OK) break;
        
		error = unzGetCurrentFileInfo(archive, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if (error != UNZ_OK) break;
        
		error = unzOpenCurrentFile(archive);
		if (error != UNZ_OK) break;
        
		int unzipped = 0;
		data = [NSMutableData dataWithCapacity:fileInfo.uncompressed_size];
		do {
			unzipped = unzReadCurrentFile(archive, buffer, sizeof(buffer));
			if (unzipped < 0) { data = nil; break; }
			[data appendBytes:buffer length:unzipped];
		}
		while (unzipped > 0);
	}
	while (FALSE);
    
	if (archive) {
		error = unzCloseCurrentFile(archive);
		error = unzClose(archive);
	}
    
	return data;
}


- (void)dealloc {
	[archivePath release];
	[pathInArchive release];
	[super dealloc];
}

@end
