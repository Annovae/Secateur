//
//  DRHSecateurEditingViewController.h
//  Secateur
//
//  Created by Lee Walsh on 17/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRHSecateurTree;

@interface DRHSecateurEditingViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>{
    IBOutlet NSTextField *nameField;
    IBOutlet NSTextField *speciesField;
    IBOutlet NSTextField *sourceField;
    IBOutlet NSDatePicker *startDatePicker;
    IBOutlet NSDatePicker *potUpDatePicker;
    IBOutlet NSTableView *pottingHistoryTable;
    IBOutlet NSTableView *galleryTable;
    IBOutlet NSImageView *galleryImageView;
}
-(NSTextField *)nameField;
-(NSTextField *)speciesField;
-(NSTextField *)sourceField;
-(NSDatePicker *)startDatePicker;
-(NSDatePicker *)potUpDatePicker;

-(void)bindToTree:(DRHSecateurTree *)tree;
-(IBAction)addPottingHistory:(id)sender;
-(IBAction)removePottingHistory:(id)sender;
-(IBAction)addGalleryItem:(id)sender;
-(IBAction)removeGalleryItem:(id)sender;
-(IBAction)newGalleryImage:(id)sender;
-(IBAction)updateDisplayImage:(id)sender;

@end
