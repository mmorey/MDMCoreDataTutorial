//
//  MDMViewController.h
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 2/28/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreData;

@interface MDMViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
