//
//  FFRegisteredViewController.m
//  xmpper
//
//  Created by liu on 6/14/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import "FFRegisteredViewController.h"
#import "FFTool.h"
#import "FFXMPPManager.h"

@interface FFRegisteredViewController () {

    FFXMPPManager *myXMPPManager;

}
- (IBAction)backGoundTouchDown:(id)sender;

@end

@implementation FFRegisteredViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[myXMPPManager disconnect];
	[[myXMPPManager xmppvCardTempModule] removeDelegate:self];
	
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    _passTF.secureTextEntry = YES;
    _repassTF.secureTextEntry = YES;
    
    //设置XMPPManager
    [self setTheXMPPManager];
    
    //设置返回按钮
    [self defineLeftButton];

}

//设置初始化xmppManager
- (void)setTheXMPPManager{

    myXMPPManager = [[FFXMPPManager alloc] init];
    
    [myXMPPManager setupStream];
    
    [myXMPPManager registeredConnect:@"flymx.cn"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameTF:nil];
    [self setPassTF:nil];
    [self setRepassTF:nil];
    [self setRegisterBut:nil];
    [self setCancelBut:nil];
    [super viewDidUnload];
}

//点击注册
- (IBAction)regesterButOnClick:(id)sender {
    
    NSString *myReName;
    NSString *myPassWord;
    NSString *myRePassWord;
    
    myReName      = _nameTF.text;
    myPassWord    = _passTF.text;
    myRePassWord  = _repassTF.text;
    
    if ([myPassWord isEqualToString:myRePassWord]) {
    
        [myXMPPManager  setTheRegisteredInfo:myReName pass:myPassWord];
        
    } else {
        
        [FFTool waringInfo:@"两次密码不相同！"];
    }
}

- (IBAction)backGoundTouchDown:(id)sender {
    
    [self.nameTF resignFirstResponder];
    [self.passTF resignFirstResponder];
    [self.repassTF resignFirstResponder];
}

#pragma mark-
#pragma mark 返回
//设置navigationbar左边的按钮
- (void)defineLeftButton
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 7, 52, 30);
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"sf_nav_btn1_up.png"] forState:UIControlStateNormal];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"sf_nav_btn1_down.png"] forState:UIControlStateHighlighted];
    leftBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [leftBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(returnBeforeViewAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (IBAction)returnBeforeViewAction:(id)sender
{
    [myXMPPManager disconnect];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
