//
//  MDMDetailViewController.h
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 2/28/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreData;

@class MDMBook;

@interface MDMDetailViewController : UIViewController

@property (nonatomic, strong) MDMBook *book;

@end
