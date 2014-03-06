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

- (IBAction)saveButtonTapped:(id)sender {
    
    [self.book setValue:self.titleTextField.text forKey:@"title"];
    NSManagedObject *author = [self.book valueForKey:@"author"];
    [author setValue:self.authorTextField.text forKey:@"authorName"];
 
    NSError *saveError;
    if ([self.book.managedObjectContext save:&saveError] == NO) {
        NSLog(@"Error: %@", [saveError localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
