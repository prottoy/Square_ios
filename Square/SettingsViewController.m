//
//  SettingsViewController.m
//  Square
//
//  Created by Mahbub Morshed on 1/23/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import "SettingsViewController.h"
#import "CheckInViewController.h"
#import "SVProgressHUD.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize segments;
@synthesize name, email;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [segments setSelectedSegmentIndex:1];
    [segments addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *nameString=[prefs objectForKey:@"name"];
    NSString *emailString=[prefs objectForKey:@"email"];
    
    name.delegate= self;
    email.delegate= self;
    
    [name setText:nameString];
    [email setText:emailString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)changeView:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSegment" object:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self changeView:nil];
            break;
        case 1:
            break;
    }
}

-(IBAction)saveSettings:(id)sender{
    NSString *nameString= name.text;
    NSString *emailString= email.text;
    
    if (nameString.length < 1 || emailString.length<1) {
        [SVProgressHUD showErrorWithStatus:@"Please enter name and email!"];
    }else{
        
        [name resignFirstResponder];
        [email resignFirstResponder];
        
        NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
        [prefs setObject:nameString forKey:@"name"];
        [prefs setObject:emailString forKey:@"email"];
    }
    [SVProgressHUD showSuccessWithStatus:@"Saved"];
    [self changeView:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
