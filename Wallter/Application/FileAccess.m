//
//  by najati
//  copyright cyrus innovation
//

#import "FileAccess.h"

NSString *pathForFile(NSString *filename) {
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:filename];
}

id readFromFile(NSString *filename) {
	NSString *filePath = pathForFile(filename);

	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
		NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

		id obj = [decoder decodeObjectForKey:@"Data"];
		[decoder finishDecoding];
		return obj;
	}
	return nil;
}

void saveToFile(id obj, NSString *filename) {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

	[encoder encodeObject:obj forKey:@"Data"];
	[encoder finishEncoding];

	[data writeToFile:pathForFile(filename) atomically:true];
}
