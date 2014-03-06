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

@interface MDMViewController () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;

@end

@implementation MDMViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.tableView) {
        return [[self.fetchedResultsController sections] count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    } else {
        return [self.filteredList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (tableView == self.tableView) {
        MDMBook *book = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self configureCell:cell withBook:book];
    } else {
        
        MDMBook *book = self.filteredList[indexPath.row];
        [self configureCell:cell withBook:book];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView == self.tableView ? YES : NO;
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
    [self configureCell:cell withBook:book];
}

- (void)configureCell:(UITableViewCell *)cell withBook:(MDMBook *)book {
    
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.author.authorName;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MasterToDetailSegue"]) {
        
        MDMDetailViewController *detailViewController = segue.destinationViewController;
        
        if (self.searchDisplayController.isActive) {
            
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            detailViewController.book = self.filteredList[indexPath.row];
        } else {
            
            NSIndexPath *selectedItemIndexPath = [self.tableView indexPathForSelectedRow];
            detailViewController.book = [self.fetchedResultsController objectAtIndexPath:selectedItemIndexPath];
        }
    } else if ([segue.identifier isEqualToString:@"NewBookSegue"]) {

        MDMAuthor *author = [MDMAuthor MDMCoreDataAdditionsInsertNewObjectIntoContext:self.managedObjectContext];
        MDMBook *book = [MDMBook MDMCoreDataAdditionsInsertNewObjectIntoContext:self.managedObjectContext];
        book.author = author;
        MDMDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.book = book;
    }
}

#pragma mark - Searching

- (NSFetchRequest *)searchFetchRequest {
    
    if (_searchFetchRequest == nil) {
        
        _searchFetchRequest = [[NSFetchRequest alloc] initWithEntityName:[MDMBook MDMCoreDataAdditionsEntityName]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        [_searchFetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    
    return _searchFetchRequest;
}

- (void)searchForText:(NSString *)searchText {
    
    if (self.managedObjectContext) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"title", searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *fetchError = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&fetchError];
        if (results == nil) {
            NSLog(@"Error: %@", [fetchError localizedDescription]);
        } else {
            self.filteredList = results;
        }
    }
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    [self searchForText:searchString];
    return YES;
}

@end
