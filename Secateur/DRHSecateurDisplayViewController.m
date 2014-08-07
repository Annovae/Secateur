//
//  DRHSecateurDisplayViewController.m
//  Secateur
//
//  Created by Lee Walsh on 17/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurDisplayViewController.h"
#import "DRHSecateurDisplayView.h"
#import "DRHSecateurTree.h"
#import "DRHPottingHistoryItem.h"

@interface DRHSecateurDisplayViewController ()

@end

@implementation DRHSecateurDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DRHSecateurDisplayView" bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [[[(DRHSecateurDisplayView*)[self view] currentTree] pottingHistoryArray] count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    DRHPottingHistoryItem *currentItem = [[[(DRHSecateurDisplayView*)[self view] currentTree] pottingHistoryArray] objectAtIndex:row];
    if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date"])
        return currentItem.date;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Pot"])
        return currentItem.pot;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Soil"])
        return currentItem.soil;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Fertiliser"])
        return currentItem.fertiliser;
    return nil;
}

@end
