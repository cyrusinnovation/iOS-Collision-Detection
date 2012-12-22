//
// by najati 
// copyright Cyrus Innovation
//


#import "Settings.h"
#import "FileAccess.h"


@implementation Settings

@synthesize soundEffectsOn;
@synthesize musicOn;
@synthesize playerName;

static Settings *_instance = nil;

+(Settings *) instance {
	@synchronized ([Settings class]) {
		if (!_instance) {
			_instance = readFromFile(@"Settings");
		}
		if (!_instance) {
			_instance = [[self alloc] init];
			[_instance save];
		}
		return _instance;
	}
}

+(id)alloc
{
	@synchronized ([Settings class]) {
		_instance = [super alloc];
		return _instance;
	}
}

- (void)save {
	saveToFile(_instance, @"Settings");
}

-(id)init {
	self = [super init];
	if (!self) return self;

	soundEffectsOn = true;
	musicOn = true;
	playerName = @"Walter";

	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if (!self) return self;

	soundEffectsOn = [decoder decodeBoolForKey:@"soundEffectsOn"];
	musicOn = [decoder decodeBoolForKey:@"musicOn"];
	playerName = [decoder decodeObjectForKey:@"playerName"];

	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeBool:soundEffectsOn forKey:@"soundEffectsOn"];
	[encoder encodeBool:musicOn forKey:@"musicOn"];
	[encoder encodeObject:playerName forKey:@"playerName"];
}

@end