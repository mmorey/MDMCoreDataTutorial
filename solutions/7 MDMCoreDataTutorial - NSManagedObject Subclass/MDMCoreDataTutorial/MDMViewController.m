//
//  MDMViewController.m
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 2/28/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import "MDMViewController.h"
#import "MDMDetailViewController.h"
#import "MDMAuthor.h"
#import "MDMBook.h"
#import "NSManagedObject+MDMAdditions.h"

@interface MDMViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MDMViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    //
    // Create new book and author objects
    //
    MDMAuthor *author = [MDMAuthor MDMCoreDataAdditionsInsertNewObjectIntoContext:self.managedObjectContext];
    author.authorName = @"Charles Dickens";
 
    MDMBook *book = [MDMBook MDMCoreDataAdditionsInsertNewObjectIntoContext:self.managedObjectContext];
    book.title = @"Oliver Twist";
    book.author = author;
 
    //
    // Save the context to persist the objects to disk
    //
    NSError *saveError;
    if ([self.managedObjectContext save:&saveError] == NO) {
        NSLog(@"Error: %@", [saveError localizedDescription]);
        // TODO: Show UIAlert letting the user know they are going to lose there data
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController == nil) {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MDMBook"];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                         ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        [fetchRequest setFetchBatchSize:20];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
        NSError *fetchError;
        if ([_fetchedResultsController performFetch:&fetchError] == NO) {
         
            NSLog(@"Error: %@", [fetchError localizedDescription]);
        }
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    MDMBook *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
    MDMAuthor *author = book.author;
    
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = author.authorName;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MasterToDetailSegue"]) {
        
        MDMDetailViewController *detailViewController = segue.destinationViewController;
        NSIndexPath *selectedItemIndexPath = [self.tableView indexPathForSelectedRow];
        detailViewController.book = [self.fetchedResultsController objectAtIndexPath:selectedItemIndexPath];
    } else if ([segue.identifier isEqualToString:@"NewBookSegue"]) {

        MDMAuthor *author = [MDMAuthor MDMCoreDataAdditionsInsertNewObjectIntoContext:self.managedObjectContext];
        MDMBook *book = [MDMBook MDMCoreDataAdditionsInsertNewObjectIntoContext:self.managedObjectContext];
        book.author = author;
        MDMDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.book = book;
    }
}

@end
