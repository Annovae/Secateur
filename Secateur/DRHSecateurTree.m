//
//  DRHSecateurTree.m
//  Secateur
//
//  Created by Lee Walsh on 15/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurTree.h"

@implementation DRHSecateurTree

@synthesize treeName,species,source,startDate,potUpDate;

-(id)init{
    if (self = [super init]) {
        treeName = @"New tree";
        species = @"";
        source = @"";
        startDate = [NSDate date];
        potUpDate = [NSDate date];
        pottingHistoryArray = [NSMutableArray array];
        galleryArray = [NSMutableArray array];
    }
    return self;
}

+(DRHSecateurTree *)tree{
    return [[self alloc] init];
}

-(NSMutableArray *)pottingHistoryArray{
    return pottingHistoryArray;
}

-(NSMutableArray *)galleryArray{
    return galleryArray;
}

#pragma mark NSEncoding

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        treeName = [aDecoder decodeObjectForKey:@"treeName"];
        if (!treeName) {
            treeName = @"New tree";
        }
        species = [aDecoder decodeObjectForKey:@"species"];
        if (!species) {
            species = @"";
        }
        source = [aDecoder decodeObjectForKey:@"source"];
        if (!source) {
            source = @"";
        }
        startDate = [aDecoder decodeObjectForKey:@"startDate"];
        if (!startDate) {
            startDate = [NSDate date];
        }
        potUpDate = [aDecoder decodeObjectForKey:@"potUpDate"];
        if (!potUpDate) {
            potUpDate = [NSDate date];
        }
        pottingHistoryArray = [aDecoder decodeObjectForKey:@"pottingHistoryArray"];
        if (!pottingHistoryArray) {
            pottingHistoryArray = [NSMutableArray array];
        }
        galleryArray = [aDecoder decodeObjectForKey:@"galleryArray"];
        if (!galleryArray) {
            galleryArray = [NSMutableArray array];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:treeName forKey:@"treeName"];
    [aCoder encodeObject:species forKey:@"species"];
    [aCoder encodeObject:source forKey:@"source"];
    [aCoder encodeObject:startDate forKey:@"startDate"];
    [aCoder encodeObject:potUpDate forKey:@"potUpDate"];
    [aCoder encodeObject:pottingHistoryArray forKey:@"pottingHistoryArray"];
    [aCoder encodeObject:galleryArray forKey:@"galleryArray"];
}

@end
