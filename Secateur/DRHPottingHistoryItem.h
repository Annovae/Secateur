//
//  DRHPottingHistoryItem.h
//  Secateur
//
//  Created by Lee Walsh on 25/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRHPottingHistoryItem : NSObject <NSCoding>

@property NSDate *date;
@property NSString *pot;
@property NSString *soil;
@property NSString *fertiliser;

+(DRHPottingHistoryItem *)pottingHistoryItem;

@end
