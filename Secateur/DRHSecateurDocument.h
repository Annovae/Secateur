//
//  DRHDocument.h
//  Secateur
//
//  Created by Lee Walsh on 14/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "DRHSecateurData.h"

@interface DRHSecateurDocument : NSDocument <NSTableViewDataSource> {
//    DRHSecateurData *database;
    NSMutableArray *dataArray;
    
    IBOutlet NSTableView *treeTable;
}

-(IBAction)addTree:(id)sender;
-(IBAction)removeSelectedTrees:(id)sender;

@end
