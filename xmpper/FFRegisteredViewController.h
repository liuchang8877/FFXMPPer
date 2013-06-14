//
//  FFRegisteredViewController.h
//  xmpper
//
//  Created by liu on 6/14/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFRegisteredViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UITextField *repassTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBut;
@property (weak, nonatomic) IBOutlet UIButton *cancelBut;

- (IBAction)regesterButOnClick:(id)sender;
@end
