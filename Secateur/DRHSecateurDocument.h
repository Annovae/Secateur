//
//  DRHDocument.h
//  Secateur
//
//  Created by Lee Walsh on 14/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRHSecateurEditingViewController;
@class DRHSecateurDisplayViewController;
@class DRHSecateurTree;

@interface DRHSecateurDocument : NSDocument <NSTableViewDataSource,NSTableViewDelegate> {
//    DRHSecateurData *database;
    NSMutableArray *dataArray;
    DRHSecateurTree *selectedTree;
    
    IBOutlet NSTableView *treeTable;
    IBOutlet NSView *contentView;
    DRHSecateurDisplayViewController *displayViewController;
    DRHSecateurEditingViewController *editingViewController;
}

-(IBAction)addTree:(id)sender;
-(IBAction)removeSelectedTrees:(id)sender;
-(void)selectTree:(DRHSecateurTree *)tree;

-(IBAction)edit:(id)sender;
-(void)showEditingView;
-(IBAction)endEditing:(id)sender;
-(void)showDisplayView;

@end
