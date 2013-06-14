//
//  FFViewController.h
//  xmpper
//
//  Created by liu on 6/7/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FFViewController : UIViewController <UIApplicationDelegate,UITextFieldDelegate>{    
}


@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passTF;

- (IBAction)registerButOnClick:(id)sender;
- (IBAction)loginButClickOn:(id)sender;
- (IBAction)backGroundTouchDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerBut;

@end
