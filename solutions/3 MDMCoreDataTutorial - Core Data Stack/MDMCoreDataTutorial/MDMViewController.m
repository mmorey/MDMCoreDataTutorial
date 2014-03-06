//
//  MDMViewController.m
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 2/28/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import "MDMViewController.h"

@interface MDMViewController ()

@property (nonatomic, strong) NSMutableArray *tableDatasource;

@end

@implementation MDMViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    //
    // Create new book and author objects
    //
    NSEntityDescription *authorEntityDescription = [NSEntityDescription entityForName:@"MDMAuthor"
                                                               inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *author = [[NSManagedObject alloc] initWithEntity:authorEntityDescription
                                       insertIntoManagedObjectContext:self.managedObjectContext];
    [author setValue:@"Charles Dickens" forKey:@"authorName"];
    
    NSEntityDescription *bookEntityDescription = [NSEntityDescription entityForName:@"MDMBook"
                                                             inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *book = [[NSManagedObject alloc] initWithEntity:bookEntityDescription
                                     insertIntoManagedObjectContext:self.managedObjectContext];
    [book setValue:@"Oliver Twist" forKey:@"title"];
    [book setValue:author forKey:@"author"];
 
    //
    // Save the context to persist the objects to disk
    //
    NSError *saveError;
    if ([self.managedObjectContext save:&saveError] == NO) {
        NSLog(@"Error: %@", [saveError localizedDescription]);
        // TODO: Show UIAlert letting the user know they are going to lose there data
    }
    
    //
    // Fetch objects and populate the table data source
    //
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MDMBook"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                     ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *fetchError;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                error:&fetchError];

    if (results == nil) {
        NSLog(@"Error: %@", [fetchError localizedDescription]);
    } else if ([results count] > 0) {
        [self.tableDatasource addObjectsFromArray:results];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSMutableArray *)tableDatasource {
    
    if (_tableDatasource == nil) {
        _tableDatasource = [NSMutableArray array];
    }
    
    return _tableDatasource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return [self.tableDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSManagedObject *book = self.tableDatasource[indexPath.row];
    NSManagedObject *author = [book valueForKey:@"author"];
    
    cell.textLabel.text = [book valueForKey:@"title"];
    cell.detailTextLabel.text = [author valueForKey:@"authorName"];
    
    return cell;
}

@end
