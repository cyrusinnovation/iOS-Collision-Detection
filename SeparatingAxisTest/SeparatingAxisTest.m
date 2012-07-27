//
//  SeparatingAxisTest.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "SeparatingAxisTest.h"

#import "Range.h"

@implementation SeparatingAxisTest

@synthesize result;

-(void) considerAxis:(Vector*) axis {
    Range* aProjection = [a projectOnto:axis];
    Range* bProjection = [b projectOnto:axis];

    Overlap *overlap = [aProjection overlapWith: bProjection];
    
    if (![overlap overlaps]) {
        separated |= true;
    } else {
        float lengthSquaredOfOverlapAlongThisAxis = [overlap correction]*[overlap correction];
        
        if(lengthSquaredOfOverlapAlongThisAxis < minimumSeparationSquared) {
            minimumSeparationSquared = lengthSquaredOfOverlapAlongThisAxis;
            
            [penetration copyFrom:axis];
            [penetration normalize];
            [penetration scaleBy:[overlap correction]];
        }
    }
}

-(void) computeNormals: (Polygon *) polygon {
    Vector *start = [[polygon points] objectAtIndex:0];
    for (int i = 0; i < [[polygon points] count]; i++) {
        Vector *end = [[polygon points] objectAtIndex:i];
        Vector *perpendicular = [end minus: start];
        [perpendicular normalize];
        [perpendicular flop];
        
        [self considerAxis:perpendicular];
        
        start = end;
    }
}

-(id) initWith:(Polygon *) _a and: (Polygon *) _b {
    self = [super init];
    if (!self) return nil;
        
    a = _a;
    b = _b;
    
    separated = false;
    penetration = [[Vector alloc] init];
    
    minimumSeparationSquared = FLT_MAX;
    
    [self computeNormals: a];
    [self computeNormals: b];
    
    result = [[SATResult alloc] initWithPenetration:penetration andSeparated:separated];
    
    return self;
}

@end
