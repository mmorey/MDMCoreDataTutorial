//
//  MDMDetailViewController.m
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 2/28/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import "MDMDetailViewController.h"
#import "MDMBook.h"
#import "MDMAuthor.h"
#import "MDMCoreDataFatalErrorAlertView.h"

@interface MDMDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;

@property (nonatomic, strong) MDMCoreDataFatalErrorAlertView *fatalAlertView;

@end

@implementation MDMDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleTextField.text = self.book.title;
    self.authorTextField.text = self.book.author.authorName;
}

- (IBAction)saveButtonTapped:(id)sender {
    
    self.book.title = self.titleTextField.text;
    self.book.author.authorName = self.authorTextField.text;
 
    NSError *saveError;
    if ([self.book.managedObjectContext save:&saveError] == NO) {
        NSAssert(NO, @"Error: %@", [saveError localizedDescription]);
        [self showAlert];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertView

- (void)showAlert {
    
    [self.fatalAlertView showAlert];
}

- (MDMCoreDataFatalErrorAlertView *)fatalAlertView {
    
    if (_fatalAlertView == nil) {
        _fatalAlertView = [[MDMCoreDataFatalErrorAlertView alloc] init];
    }
    
    return _fatalAlertView;
}

@end
