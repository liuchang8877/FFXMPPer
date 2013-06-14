//
//  FFTool.m
//  xmpper
//
//  Created by liu on 6/9/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import "FFTool.h"

@implementation FFTool


//提示框
#pragma  mark init the waring info
+ (void)waringInfo:(NSString *) msgInfo
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:msgInfo
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"确定",nil];
    [alert show];
}
@end
