//
//  FFViewController.m
//  xmpper
//
//  Created by liu on 6/7/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import "FFViewController.h"
#import "FFViewRosterController.h"
#import "FFConfig.h"
#import "FFTool.h"
#import "FFRegisteredViewController.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"



// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface FFViewController () {

    UILabel  *myNameLabel;
    UILabel  *myPassWordLabel;
    NSString *myJID;
    NSString *myPassword;

    FFViewRosterController *myRosterVC;


}

@end

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title  = @"XMPPER";
    self.view.backgroundColor = [UIColor grayColor];
    
    // Configure logging framework
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    myRosterVC = [[FFViewRosterController alloc]init];
    
    //设置密码输入TextField
    _passTF.secureTextEntry = YES;
    

    //设置用户名与密码背景提示
    [self setTheTextField];
    //设置XMPPStream
    //[self setupStream];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击注册界面
- (IBAction)registerButOnClick:(id)sender {
    
    FFRegisteredViewController *registerVC = [[FFRegisteredViewController alloc]init];
    registerVC.title = @"用户注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}

//点击确认登录
- (IBAction)loginButClickOn:(id)sender {
    
//    myJID       = self.nameTF.text;
//    myPassword  = self.passTF.text;
    
    if ([self.nameTF.text length] == 0 || [self.nameTF.text length] == 0) {
    
        [FFTool waringInfo:@"用户名或密码不能为空"];
        return;
    } else {
    
        [[NSUserDefaults alloc] removeObjectForKey:USER_NAME];
        [[NSUserDefaults alloc] removeObjectForKey:USER_PASS];
        //设置用户名密码
        [[NSUserDefaults alloc] setObject:self.nameTF.text forKey:USER_NAME];
        [[NSUserDefaults alloc] setObject:self.passTF.text forKey:USER_PASS];
        
        
        NSLog(@"loginButClickOn---name:%@,pass:%@",self.nameTF.text,self.passTF.text);
        
        myRosterVC.title = @"用户信息";
        [self.navigationController pushViewController:myRosterVC animated:YES];
    
    }

}

- (IBAction)backGroundTouchDown:(id)sender {
    
    [self.nameTF resignFirstResponder];
    [self.passTF resignFirstResponder];
}

#pragma mark -
#pragma mark set the text field
- (void)setTheTextField {
    
    //set the type
    [self.nameTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.passTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    //set the textfield
    [self.nameTF setDelegate:self];
    myNameLabel = [self setTheLabelSetX:10 setY:-5 title:@"用户名"];
    [self.nameTF addSubview:myNameLabel];
    
    [self.passTF setDelegate:self];
    myPassWordLabel = [self setTheLabelSetX:10 setY:-5 title:@"密码"];
    [self.passTF addSubview:myPassWordLabel];
}

//when start to edit the textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.nameTF)
        myNameLabel.text = @"";
    else
        myPassWordLabel.text = @"";
    
    return YES;
}

//when end editing and it is  empty then set the text
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTF) {
        
        if ([self.nameTF.text length] == 0) {
            myNameLabel.text = @"用户名";
        }
        
    } else {
        
        if ([self.passTF.text length] == 0) {
            
            myPassWordLabel.text = @"密码";
        }
    }
}

#pragma mark set the label
- (UILabel *)setTheLabelSetX:(int)x setY:(int)y title:(NSString *)title {
    
    UILabel *myOneLabel = [[UILabel alloc] init];
    //frame
    myOneLabel.frame = CGRectMake(x, y, 100, 40);
    //title
    myOneLabel.text = title;
    //background
    myOneLabel.backgroundColor = [UIColor clearColor];
    //color and font
    [myOneLabel setTextColor:[UIColor grayColor]];
    [myOneLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    return  myOneLabel;
}

- (void)viewDidUnload {
    [self setRegisterBut:nil];
    [super viewDidUnload];
}
@end
