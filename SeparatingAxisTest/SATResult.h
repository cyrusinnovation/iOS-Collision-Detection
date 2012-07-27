//
//  SATResult.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Vector.h"

@interface SATResult : NSObject

@property (readonly) Vector* penetration;
@property (readonly) Boolean penetrating;

-(id) initWithPenetration:(Vector*) _penetration andSeparated:(Boolean) separated;

@end
