//
//  MDMDetailViewController.m
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 2/28/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import "MDMDetailViewController.h"

@interface MDMDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;

@end

@implementation MDMDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleTextField.text = [self.book valueForKey:@"title"];
    NSManagedObject *author = [self.book valueForKey:@"author"];
    self.authorTextField.text = [author valueForKey:@"authorName"];
}

@end
