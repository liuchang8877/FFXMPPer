//
//  FFXMPPManager.h
//  xmpper
//
//  Created by liu on 6/9/13.
//  Copyright (c) 2013 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface FFXMPPManager : NSObject<XMPPRosterDelegate>{

    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPRoster *xmppRoster;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPCapabilities *xmppCapabilities;
    
    BOOL allowSelfSignedCertificates;
    BOOL allowSSLHostNameMismatch;
    
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

//连接
- (BOOL)connect;
//断开
- (void)disconnect;
//设置参数
- (void)setupStream;
//设置注册
- (void)registeredConnect:(NSString *)serverName;
//设置注册信息
- (void)setTheRegisteredInfo:(NSString *)myUserName pass:(NSString *)myUserPass;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;


@end
