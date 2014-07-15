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
}
@property NSString *treeName;

+(DRHSecateurTree *)tree;

@end
