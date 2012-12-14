//
// Created by najati on 12/14/12.
//

#import <Foundation/Foundation.h>

@class BadGuy;

@protocol CharacterAddedObserver
-(void)addedCharacter:(BadGuy*) badGuy;
@end