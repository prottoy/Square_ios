//
//  ViewController.m
//  Square
//
//  Created by Mahbub Morshed on 1/18/15.
//  Copyright (c) 2015 Mahbub Morshed. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize squareWebview;
@synthesize settings, settingsIcon, checkinButton;
@synthesize name, email;
@synthesize loading;

-(IBAction)showSettings:(id)sender{
    settingsIcon.hidden= YES;
    settings.layer.opacity=1.0;
}

-(IBAction)checkinAction:(id)sender{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *nameString=[prefs objectForKey:@"name"];
    NSString *emailString=[prefs objectForKey:@"email"];
    
    NSLog(@"Name is [%@] and Email is [%@]", nameString, emailString);
    
    [self checkin:emailString nameString:nameString];
}

- (void)checkin:(NSString *)emailString nameString:(NSString *)nameString {
    if (nameString.length>0  && emailString.length>0) {
        settings.layer.opacity= 0.0;
        
        //Check-in
        NSString *url= @"http://www.green-red.com/square/checkin/";
        
        NSMutableURLRequest *req=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        
        NSString *myreqstr=[NSString stringWithFormat:@"name=%@&email=%@", nameString, emailString];
        
        NSData *myreqdata=[NSData dataWithBytes:[myreqstr UTF8String] length:[myreqstr length]];
        [req setHTTPMethod:@"POST"];
        
        [ req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [ req setHTTPBody: myreqdata ];
        
        NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
        NSLog(@"%@",data);
        NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
        NSData *jsondata = [returnstring dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:jsondata options:0 error:nil];
        
        NSString *responseString= [json objectForKey:@"response"];
        
        NSLog(@"[%@]", responseString);
        
        if ([responseString isEqualToString:@"invalid email!"]) {
            settings.layer.opacity=1.0;
        }
        
        if ([responseString isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:responseString];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }

        [self load_square];
    }
    else{
        [self showSettings:nil];
    }
}

- (void)load_square {
    //Square page load
    NSString *squareUrl= @"http://www.green-red.com/square/";
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:squareUrl]];
    [squareWebview loadRequest:urlRequest];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [SVProgressHUD showErrorWithStatus:@"Please connect to GNR WIFI"];
        [loading setText:@"NO INTERNET CONNECTION!"];
        
        settingsIcon.hidden= YES;
        squareWebview.hidden= YES;
        checkinButton.hidden= YES;
    }
    
    self.view.layer.backgroundColor= [UIColor groupTableViewBackgroundColor].CGColor;
    
    // Do any additional setup after loading the view, typically from a nib.
    settings.layer.opacity=1.0;
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *nameString=[prefs objectForKey:@"name"];
    NSString *emailString=[prefs objectForKey:@"email"];
    
    [self checkin:emailString nameString:nameString];
    
    settings.layer.borderColor= [UIColor blackColor].CGColor;
    settings.layer.borderWidth= 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        settings.layer.opacity= 0.0;
        
        [self checkin:emailString nameString:nameString];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
