//
// Created by najati on 10/3/12.
//

#import "HighScores.h"
#import "HighScore.h"

static HighScores *_instance = nil;

@implementation HighScores {
	float highScore;
	NSString *highScoreName;
}

+ (BOOL)isHighScore:(float)score {
	return [[HighScores instance] isHighScore:score];
}

+ (id)instance {
	if (_instance == nil) {
		_instance = [[HighScores alloc] init];
	}
	return _instance;
}

- (BOOL)isHighScore:(float)score {
	return score > highScore;
}

+ (HighScore *)getHighestScore {
	return [[HighScores instance] highestScore];
}

- (HighScore *)highestScore {
	return [HighScore by:highScoreName of:highScore];
}

+ (void)setHighestScore:(NSString *)name score:(float)score {
 	[[HighScores instance] setHighestScore:name score:score];
}

- (void)setHighestScore:(NSString *)name score:(float)score {
 	if (score > highScore) {
		 highScore = score;
		 highScoreName = name;
	 }
}

- (id)init {
	if (self = [super init]) {
		highScore = 0;
		highScoreName = @"Nobody";
	}
	return self;
}


@end