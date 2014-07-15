//
//  DRHSecateurTree.m
//  Secateur
//
//  Created by Lee Walsh on 15/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurTree.h"

@implementation DRHSecateurTree

@synthesize treeName;

-(id)init{
    if (self = [super init]) {
        treeName = @"New tree";
    }
    return self;
}

+(DRHSecateurTree *)tree{
    return [[self alloc] init];
}

#pragma mark NSEncoding

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        treeName = [aDecoder decodeObjectForKey:@"treeName"];
        if (!treeName) {
            treeName = @"New tree";
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:treeName forKey:@"treeName"];
}

@end
