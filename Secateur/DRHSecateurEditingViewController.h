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
    IBOutlet NSTextField *speciesField;
    IBOutlet NSTextField *sourceField;
    IBOutlet NSDatePicker *startDatePicker;
    IBOutlet NSDatePicker *potUpDatePicker;
}
-(NSTextField *)nameField;
-(NSTextField *)speciesField;
-(NSTextField *)sourceField;
-(NSDatePicker *)startDatePicker;
-(NSDatePicker *)potUpDatePicker;

-(void)bindToTree:(DRHSecateurTree *)tree;

@end
