//
//  Overlap.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Overlap : NSObject

@property (readonly) Boolean overlaps;
@property (readonly) float correction;

-(id) initFrom:(Boolean) overlaps and: (float) correction;

@end
