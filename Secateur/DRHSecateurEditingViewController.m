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
    return @"-";
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
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
}

-(IBAction)addPottingHistory:(id)sender{
    [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] addObject:@"-"];
    [pottingHistoryTable reloadData];
}

-(IBAction)removePottingHistory:(id)sender{
    NSMutableArray *historyArray = [[[self.view.window.windowController document] selectedTree] pottingHistoryArray];
    if ([historyArray count] > 0)
        [historyArray removeObjectsAtIndexes:[pottingHistoryTable selectedRowIndexes]];
    [pottingHistoryTable reloadData];
}

@end
