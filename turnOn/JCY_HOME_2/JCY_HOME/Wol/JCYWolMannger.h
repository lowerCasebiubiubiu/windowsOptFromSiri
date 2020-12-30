//
//  JCYWolMannger.h
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCYWolItem : NSObject<NSSecureCoding>

@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, assign) uint16_t port;

@end

@interface JCYWolMannger : NSObject

@property (nonatomic, strong) JCYWolItem *wolItem;

+ (void)saveWolItem:(JCYWolItem *)wolItem;
+ (JCYWolItem *)loadWolItem;
+ (JCYWolItem *)defaultWolItem;

- (void)sendUdpWithJCYWolItem:(JCYWolItem *)wolItem completed:(void(^)(NSString *msg,BOOL succ))completed;

- (void)sendUdpWithMac:(NSString *)mac ip:(NSString *)ip port:(uint16_t)port completed:(void(^)(NSString *msg,BOOL succ))completed;

+ (BOOL)checkoutMac:(NSString *)mac;

+ (BOOL)checkoutIp:(NSString *)ip;

@end

NS_ASSUME_NONNULL_END
