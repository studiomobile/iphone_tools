//
//  This content is released under the MIT License: http://www.opensource.org/licenses/mit-license.html
//

#import "ZippedFilePath.h"
#import "NSCoding.h"
#import "unzip.h"


@implementation ZippedFilePath

@synthesize archivePath;
@synthesize pathInArchive;

typedef void (^ZipReadHandler)(char *buffer, int length);

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


- (BOOL)readData:(ZipReadHandler)block {
	int error = UNZ_OK;
	unzFile archive = NULL;
    unz_file_info fileInfo;
	char buffer[4096];
    
	do {
		archive = unzOpen([archivePath.absolutePathString cStringUsingEncoding:NSUTF8StringEncoding]);
		if (!archive) break;
        
		error = unzLocateFile(archive, [pathInArchive cStringUsingEncoding:NSUTF8StringEncoding], 1);
		if (error != UNZ_OK) break;
        
		error = unzGetCurrentFileInfo(archive, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if (error != UNZ_OK) break;
        
		error = unzOpenCurrentFile(archive);
		if (error != UNZ_OK) break;
        
		int unzipped;
		do {
			unzipped = unzReadCurrentFile(archive, buffer, sizeof(buffer));
            if (unzipped) {
                block(buffer, unzipped);
            }
		}
		while (unzipped > 0);
        
        if (unzipped < 0) {
            error = UNZ_INTERNALERROR;
        }
	}
	while (FALSE);
    
	if (archive) {
		error = unzCloseCurrentFile(archive);
        if (error == UNZ_OK) {
            error = unzClose(archive);
        }
	}
    
	return error == UNZ_OK;
}


- (NSData*)readData {
	NSMutableData *data = (id)[self readCachedData];
    if (data) return data;
    
    data = [NSMutableData data];
    BOOL result = [self readData:^(char *buffer, int length) {
        [data appendBytes:buffer length:(NSUInteger)length];
    }];
    
    return result ? data : nil;
}


- (BOOL)copyData:(FilePath *)to {
   	[[NSFileManager defaultManager] createDirectoryAtPath:[to.absolutePathString stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    FILE *output = fopen([to.absolutePathString UTF8String], "w");
    
    if (output == NULL) return NO;
    
    BOOL result = [self readData:^(char *buffer, int length) {
        fwrite(buffer, sizeof(char), length, output);
    }];
    
    int err = fclose(output);
    
    return result && !err;
}


- (void)dealloc {
	[archivePath release];
	[pathInArchive release];
	[super dealloc];
}

@end
