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

@interface DRHSecateurEditingViewController (){
    BOOL pottingHistoryTableIsDatePicking;
    NSDatePicker *pottingHistoryTableDatePicker;
    NSInteger pottingHistoryTableDatePickerRow;
    id eventMonitor;
}

@end

@implementation DRHSecateurEditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DRHSecateurEditingView" bundle:nil];
    if (self) {
        // Initialization code here.
        pottingHistoryTableIsDatePicking = NO;
        pottingHistoryTableDatePicker = nil;
        pottingHistoryTableDatePickerRow = -1;
        eventMonitor = nil;
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
/*    if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date"])
        currentItem.date = object;
    else */if ([[tableColumn.headerCell stringValue] isEqualToString:@"Pot"])
        currentItem.pot = object;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Soil"])
        currentItem.soil = object;
    else if ([[tableColumn.headerCell stringValue] isEqualToString:@"Fertiliser"])
        currentItem.fertiliser = object;
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
}

#pragma mark NSTableViewDelegate methods
-(BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    NSLog(@"Column: %@",[tableColumn.headerCell stringValue]);
    if ([[tableColumn.headerCell stringValue] isEqualToString:@"Date"]) {
        if (!pottingHistoryTableIsDatePicking) {
            NSRect cellFrame = [tableView frameOfCellAtColumn:0 row:row];
            pottingHistoryTableDatePicker = [[NSDatePicker alloc] init];
            [pottingHistoryTableDatePicker setDatePickerStyle:NSClockAndCalendarDatePickerStyle];
            [pottingHistoryTableDatePicker setFrameOrigin:cellFrame.origin];
            [pottingHistoryTableDatePicker setFrameSize:NSMakeSize(139.0, 148.0)];
            [pottingHistoryTableDatePicker setDrawsBackground:YES];
            DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:row];
            [pottingHistoryTableDatePicker bind:@"value" toObject:currentItem withKeyPath:@"date" options:nil];
            [currentItem addObserver:self forKeyPath:@"date" options:0 context:nil];
//            [pottingHistoryTableDatePicker setAction:@selector(selectNewDate:)];
            [tableView addSubview:pottingHistoryTableDatePicker];
            pottingHistoryTableIsDatePicking = YES;
            pottingHistoryTableDatePickerRow = row;
            [self.view setNeedsDisplay:YES];
            
            //Monitor for event that should close (cancel) the NSDatePicker
            eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask | NSRightMouseDownMask | NSOtherMouseDownMask | NSKeyDownMask handler:^(NSEvent *incomingEvent) {
//                NSEvent *result = incomingEvent;
                NSEventType eventType = [incomingEvent type];
                if (eventType == NSKeyDown) {
                    if ([incomingEvent keyCode] == 53) {
                        // Escape
                        [self clearPottingHistoryDatePicker];
 //                       result = nil; // Don't process the event
                    }
                } else  if (eventType == NSLeftMouseDown || eventType == NSRightMouseDown || eventType == NSOtherMouseDown){
                    NSPoint mouseLocation = [incomingEvent locationInWindow];   //[NSEvent mouseLocation];
                    mouseLocation = [self.view convertPoint:mouseLocation fromView:nil];
                    mouseLocation = [self.view convertPoint:mouseLocation toView:pottingHistoryTableDatePicker];
                    NSSize datePickerSize = [pottingHistoryTableDatePicker frame].size;
                    if (mouseLocation.x<0 || mouseLocation.x>datePickerSize.width || mouseLocation.y<0 || mouseLocation.y>datePickerSize.height)
                        [self clearPottingHistoryDatePicker];
//                    NSLog(@"Size: %lf,%lf; point: %f,%lf",datePickerSize.width,datePickerSize.height,mouseLocation.x,mouseLocation.y);
                }
                return incomingEvent;
            }];
            return NO;
        }
        return NO;
    }
    return YES;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
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
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
    [pottingHistoryTable reloadData];
}

-(IBAction)removePottingHistory:(id)sender{
    NSMutableArray *historyArray = [[[self.view.window.windowController document] selectedTree] pottingHistoryArray];
    if ([historyArray count] > 0)
        [historyArray removeObjectsAtIndexes:[pottingHistoryTable selectedRowIndexes]];
    [[self.view.window.windowController document] updateChangeCount:NSChangeDone];
    [pottingHistoryTable reloadData];
}

-(void)clearPottingHistoryDatePicker{
    [pottingHistoryTableDatePicker removeFromSuperview];
    [pottingHistoryTableDatePicker unbind:@"value"];
    DRHPottingHistoryItem *currentItem = [[[[self.view.window.windowController document] selectedTree] pottingHistoryArray] objectAtIndex:pottingHistoryTableDatePickerRow];
    [currentItem removeObserver:self forKeyPath:@"date"];
    pottingHistoryTableDatePickerRow = -1;
    pottingHistoryTableDatePicker = nil;
    pottingHistoryTableIsDatePicking = NO;
    [self.view setNeedsDisplay:YES];
    if (eventMonitor) {
        [NSEvent removeMonitor:eventMonitor];
        eventMonitor = nil;
    }
}

-(IBAction)selectNewDate:(id)sender{
    NSLog(@"Selected a new date");
}

@end
