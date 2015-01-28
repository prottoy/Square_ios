//
//  SettingsViewController.h
//  Square
//
//  Created by Mahbub Morshed on 1/23/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITextFieldDelegate>


@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *email;

@property(nonatomic, strong) IBOutlet UISegmentedControl *segments;
-(IBAction)changeView:(id)sender;
@end

