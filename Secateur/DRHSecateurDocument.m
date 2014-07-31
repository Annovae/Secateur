//
//  DRHDocument.m
//  Secateur
//
//  Created by Lee Walsh on 14/07/2014.
//  Copyright (c) 2014 Dead Rubber Hand. All rights reserved.
//

#import "DRHSecateurDocument.h"
#import "DRHSecateurTree.h"
#import "DRHSecateurDisplayViewController.h"
#import "DRHSecateurEditingViewController.h"

@implementation DRHSecateurDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        dataArray = [NSMutableArray array];
        selectedTree= nil;
        
        displayViewController = nil;
        editingViewController = nil;
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"DRHSecateurDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [self showDisplayView];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
/*    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;*/
    
    return [NSKeyedArchiver archivedDataWithRootObject:dataArray];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
/*   NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;*/
    
    NSMutableArray *newDataArray;
    @try {
        newDataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        if (outError) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The data is corrupted" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
        }
        return NO;
    }
    dataArray = newDataArray;
    return YES;
}

#pragma mark NSTableView datasource methods
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [dataArray count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return [[dataArray objectAtIndex:row] treeName];
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    [[dataArray objectAtIndex:row] setTreeName:object];
}

#pragma mark NSTableView delegate methods
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSIndexSet *selectedTreeIndexes = [notification.object selectedRowIndexes];
    if ([selectedTreeIndexes count] > 0) {
        [self selectTree:[dataArray objectAtIndex:[selectedTreeIndexes firstIndex]]];
    }
}

#pragma mark Key-value observing methods
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[DRHSecateurTree class]]){
        [self updateChangeCount:NSChangeDone];
        if ([keyPath isEqualToString:@"treeName"])
            [treeTable reloadData];
    }
}


#pragma mark Getters
-(DRHSecateurTree *)selectedTree{
    return selectedTree;
}


-(IBAction)addTree:(id)sender{
    [dataArray addObject:[DRHSecateurTree tree]];
    [self updateChangeCount:NSChangeDone];
    [treeTable reloadData];
}

-(IBAction)removeSelectedTrees:(id)sender{
    NSAlert *confirmRemoveTreesAlert = [NSAlert alertWithMessageText:@"Are you sure you want to remove these trees?" defaultButton:@"Wait!" alternateButton:@"Yes, delete them." otherButton:nil informativeTextWithFormat:@"If you delete these tree records they are gone, you can't get them back."];
    [confirmRemoveTreesAlert beginSheetModalForWindow:[sender window] completionHandler:^(NSModalResponse returnCode){
        NSLog(@"%ld",returnCode);
        if (returnCode == 0) {
            [dataArray removeObjectsAtIndexes:[treeTable selectedRowIndexes]];
            [self updateChangeCount:NSChangeDone];
            [treeTable reloadData];
        }
    }];
}

-(void)selectTree:(DRHSecateurTree *)tree{
    [selectedTree removeObserver:self forKeyPath:@"treeName"];
    [selectedTree removeObserver:self forKeyPath:@"species"];
    [selectedTree removeObserver:self forKeyPath:@"source"];
    [selectedTree removeObserver:self forKeyPath:@"startDate"];
    [selectedTree removeObserver:self forKeyPath:@"potUpDate"];
    selectedTree = tree;
    [tree addObserver:self forKeyPath:@"treeName" options:0 context:nil];
    [tree addObserver:self forKeyPath:@"species" options:0 context:nil];
    [tree addObserver:self forKeyPath:@"source" options:0 context:nil];
    [tree addObserver:self forKeyPath:@"startDate" options:0 context:nil];
    [tree addObserver:self forKeyPath:@"potUpDate" options:0 context:nil];
    [editingViewController bindToTree:tree];
}

-(IBAction)edit:(id)sender{
    [self showEditingView];
    [sender setTitle:@"End editing"];
    [sender setAction:@selector(endEditing:)];
}

-(void)showEditingView{
    if (!editingViewController) {
        editingViewController = [[DRHSecateurEditingViewController alloc] init];
    }
    [editingViewController.view setFrame:[contentView bounds]];
    editingViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [displayViewController.view removeFromSuperview];
    [contentView addSubview:editingViewController.view];
    NSIndexSet *selectedTreeIndexes = [treeTable selectedRowIndexes];
    if ([selectedTreeIndexes count] > 0) {
        [self selectTree:[dataArray objectAtIndex:[selectedTreeIndexes firstIndex]]];
    }
}

-(IBAction)endEditing:(id)sender{
    [self showDisplayView];
    [sender setTitle:@"Edit"];
    [sender setAction:@selector(edit:)];
}

-(void)showDisplayView{
    if (!displayViewController) {
        displayViewController = [[DRHSecateurDisplayViewController alloc] init];
    }
    [displayViewController.view setFrame:[contentView bounds]];
    displayViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [editingViewController.view removeFromSuperview];
    [contentView addSubview:displayViewController.view];
}

@end
