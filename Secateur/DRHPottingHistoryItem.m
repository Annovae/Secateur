//
//  DRHPottingHistoryItem.m
//  Secateur
//
//  Created by Lee Walsh on 25/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHPottingHistoryItem.h"

@implementation DRHPottingHistoryItem

-(id)init{
    if (self = [super init]) {
        _date = [NSDate date];
        _pot = @"";
        _soil = @"";
        _fertiliser = @"";
    }
    return self;
}

+(DRHPottingHistoryItem *)pottingHistoryItem{
    return [[DRHPottingHistoryItem alloc] init];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        if(!(_date = [aDecoder decodeObjectForKey:@"date"]))
            _date = [NSDate date];
        if(!(_pot = [aDecoder decodeObjectForKey:@"pot"]))
            _pot = @"";
        if(!(_soil = [aDecoder decodeObjectForKey:@"soil"]))
            _soil = @"";
        if(!(_fertiliser = [aDecoder decodeObjectForKey:@"fertiliser"]))
            _fertiliser = @"";
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_pot forKey:@"pot"];
    [aCoder encodeObject:_soil forKey:@"soil"];
    [aCoder encodeObject:_fertiliser forKey:@"fertiliser"];
    
}

@end
