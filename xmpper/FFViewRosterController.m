//
//  FFViewRosterController.m
//  xmpper
//
//  Created by liu on 6/8/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import "FFViewRosterController.h"
#import "FFXMPPManager.h"

#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "XMPPFramework.h"
#import "DDLog.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface FFViewRosterController () {

    UITableView *myTableView;
    FFXMPPManager *myXMPPManager;
    NSManagedObjectContext *myManagedObContextRoster;
    NSManagedObjectContext *myManagedObContextCapabilities;
}

@end

@implementation FFViewRosterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
	titleLabel.numberOfLines = 1;
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	titleLabel.textAlignment = NSTextAlignmentCenter;
    
	if ([myXMPPManager connect])
	{
		titleLabel.text = [[[myXMPPManager xmppStream] myJID] bare];
	} else
	{
		titleLabel.text = @"No JID";
	}
	
	[titleLabel sizeToFit];
    
	self.navigationItem.titleView = titleLabel;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[myXMPPManager disconnect];
	[[myXMPPManager xmppvCardTempModule] removeDelegate:self];
	
	[super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Accessors
//- (FFViewController *)appDelegate
//{
//	return (FFViewController *)[[UIApplication sharedApplication] delegate];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置返回按钮
    [self defineLeftButton];
    
    //设置FFViewController
    BOOL coonectOrNot = [self setTheRootVC];
    
    if (coonectOrNot) {
        
        //设置table
        [self setTheTableView];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark=  setTheRootVC
- (BOOL)setTheRootVC {

    myXMPPManager = [[FFXMPPManager alloc] init];
    
    //myRootViewController.myXMPPDelegate = self;
    
    [myXMPPManager setupStream];
    
    BOOL ConnectOrNot = [myXMPPManager connect];
    
    return ConnectOrNot;
}

#pragma mark UITableView

//init the table view
- (void)setTheTableView{
    
    //set the table view
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height - 40) style:UITableViewStyleGrouped];
    
    //myTableView.backgroundColor = [UIColor clearColor];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    //myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    //myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:myTableView];
}

//set the number of section in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView---%d",[[[self fetchedResultsController] sections] count]);
    return [[[self fetchedResultsController] sections] count];
}

//刷新sections 头
- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section)
		{
			case 0  : return @"Available";
			case 1  : return @"Away";
			default : return @"Offline";
		}
	}
	
	return @"";
}

//刷新行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        NSLog(@"numberOfRowsInSection---%d",sectionInfo.numberOfObjects);
		return sectionInfo.numberOfObjects;
	}
	
	return 0;
}

//init the cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"identifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize: 15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize: 13];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSLog(@"displayName--%@",user.displayName);
    cell.textLabel.text = user.displayName;
    [self configurePhotoForCell:cell user:user];
    
    return cell;
}

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
	{
		cell.imageView.image = user.photo;
	}
	else
	{
		//NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        NSData *photoData = [[myXMPPManager xmppvCardAvatarModule]photoDataForJID:user.jid];
        
		if (photoData != nil)
			cell.imageView.image = [UIImage imageWithData:photoData];
		else
			cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
	}
}

#pragma mark-
#pragma mark NSFetchedResultsController
//关键处用于从coredata中取出XMPPframeWork定义的数据结构
- (NSFetchedResultsController *)fetchedResultsController
{
    
	if (fetchedResultsController == nil)
	{
        
        
		//NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
        NSManagedObjectContext *moc = [myXMPPManager managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			DDLogError(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}

//用于coredata数据变化后刷新tableview实用
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[myTableView reloadData];
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
