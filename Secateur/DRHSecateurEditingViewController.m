//
//  DRHSecateurEditingViewController.m
//  Secateur
//
//  Created by Lee Walsh on 17/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurEditingViewController.h"
#import "DRHSecateurDocument.h"
#import "DRHSecateurTree.h"
#import "DRHPottingHistoryItem.h"

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

-(NSTextField *)speciesField{
    return speciesField;
}

-(NSTextField *)sourceField{
    return sourceField;
}

-(NSDatePicker *)startDatePicker{
    return startDatePicker;
}

-(NSDatePicker *)potUpDatePicker{
    return potUpDatePicker;
}


#pragma mark NSTableViewDataSource methods
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:row];
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

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:row];
    if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date"])
        currentItem.date = object;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Pot"])
        currentItem.pot = object;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Soil"])
        currentItem.soil = object;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Fertiliser"])
        currentItem.fertiliser = object;
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
}


-(void)bindToTree:(DRHSecateurTree *)tree{
    [nameField unbind:@"value"];
    [nameField bind:@"value" toObject:tree withKeyPath:@"treeName" options:nil];
    [speciesField unbind:@"value"];
    [speciesField bind:@"value" toObject:tree withKeyPath:@"species" options:nil];
    [sourceField unbind:@"value"];
    [sourceField bind:@"value" toObject:tree withKeyPath:@"source" options:nil];
    [startDatePicker unbind:@"value"];
    [startDatePicker bind:@"value" toObject:tree withKeyPath:@"startDate" options:nil];
    [potUpDatePicker unbind:@"value"];
    [potUpDatePicker bind:@"value" toObject:tree withKeyPath:@"potUpDate" options:nil];
    [pottingHistoryTable reloadData];
}

-(IBAction)addPottingHistory:(id)sender{
    [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] addObject:[DRHPottingHistoryItem pottingHistoryItem]];
    [pottingHistoryTable reloadData];
}

-(IBAction)removePottingHistory:(id)sender{
    NSMutableArray *historyArray = [[[self.view.window.windowController document] selectedTree] pottingHistoryArray];
    if ([historyArray count] > 0)
        [historyArray removeObjectsAtIndexes:[pottingHistoryTable selectedRowIndexes]];
    [pottingHistoryTable reloadData];
}

@end
