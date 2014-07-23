//
//  DRHSecateurTree.h
//  Secateur
//
//  Created by Lee Walsh on 15/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRHSecateurTree : NSObject <NSCoding> {
    NSString *treeName;
    NSString *species;
    NSString *source;
    NSDate *startDate;
    NSDate *potUpDate;
    NSMutableArray *pottingHistoryArray;
    NSMutableArray *galleryArray;
}
@property NSString *treeName;
@property NSString *species;
@property NSString *source;
@property NSDate *startDate;
@property NSDate *potUpDate;

+(DRHSecateurTree *)tree;

-(NSMutableArray *)pottingHistoryArray;
-(NSMutableArray *)galleryArray;

@end
