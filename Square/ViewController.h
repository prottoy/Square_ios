//
//  ViewController.h
//  Square
//
//  Created by Mahbub Morshed on 1/18/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface ViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UIWebView *squareWebview;
@property(nonatomic, strong) IBOutlet UIView *settings;
@property(nonatomic, strong) IBOutlet UIButton *settingsIcon;
@property(nonatomic, strong) IBOutlet UIButton *checkinButton;


@property(nonatomic, strong) IBOutlet UITextField *name;
@property(nonatomic, strong) IBOutlet UITextField *email;

@property(nonatomic, strong) IBOutlet UILabel *loading;

-(IBAction)saveSettings:(id)sender;
-(IBAction)checkinAction:(id)sender;
@end

