//
//  DRHSecateurEditingViewController.m
//  Secateur
//
//  Created by Lee Walsh on 17/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurEditingViewController.h"

@interface DRHSecateurEditingViewController ()

@end

@implementation DRHSecateurEditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DRHSecateurEditingView" bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSTextField *)nameField{
    return nameField;
}

-(void)bindToTree:(DRHSecateurTree *)tree{
    [nameField unbind:@"value"];
    [nameField bind:@"value" toObject:tree withKeyPath:@"treeName" options:nil];
}

@end
