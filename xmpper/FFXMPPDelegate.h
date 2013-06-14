//
//  FFXMPPDelegate.h
//  xmpper
//
//  Created by liu on 6/9/13.
//  Copyright (c) 2013 liu. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol FFXMPPDelegate

//回调函数
- (NSManagedObjectContext *)managedObjectContext_rosterCallBack:(NSManagedObjectContext *)myManagedObContext;

- (NSManagedObjectContext *)managedObjectContext_capabilitiesCallBack:(NSManagedObjectContext *)myManagedObContext;
@end