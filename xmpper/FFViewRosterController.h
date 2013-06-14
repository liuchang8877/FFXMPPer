//
//  FFViewRosterController.h
//  xmpper
//
//  Created by liu on 6/8/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface FFViewRosterController : UIViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate> {

    NSFetchedResultsController *fetchedResultsController;

}


@end
