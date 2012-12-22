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

static Settings *instance = nil;

+(Settings *) instance {
	@synchronized ([Settings class]) {
		if (!instance) {
			instance = readFromFile(@"Settings");
		}
		if (!instance) {
			instance = [[self alloc] init];
			[instance save];
		}
		return instance;
	}
}

+(id)alloc
{
	@synchronized ([Settings class]) {
		instance = [super alloc];
		return instance;
	}
}

- (void)save {
	saveToFile(instance, @"Settings");
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

	[decoder decodeBoolForKey:@"soundEffectsOn"];
	[decoder decodeBoolForKey:@"musicOn"];
	[decoder decodeObjectForKey:@"playerName"];

	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeBool:soundEffectsOn forKey:@"soundEffectsOn"];
	[encoder encodeBool:musicOn forKey:@"musicOn"];
	[encoder encodeObject:playerName forKey:@"playerName"];
}

@end