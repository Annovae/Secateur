//
//  DRHSecateurEditingViewController.h
//  Secateur
//
//  Created by Lee Walsh on 17/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRHSecateurTree;

@interface DRHSecateurEditingViewController : NSViewController {
    IBOutlet NSTextField *nameField;
}
-(NSTextField *)nameField;

-(void)bindToTree:(DRHSecateurTree *)tree;

@end
