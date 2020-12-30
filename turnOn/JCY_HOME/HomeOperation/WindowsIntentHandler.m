//
//  WindowsIntentHandler.m
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/29.
//

#import "WindowsIntentHandler.h"
#import "JCYWolMannger.h"
@implementation WindowsIntentHandler

#pragma mark - QuickOrderCoffeeIntentHandling
- (void)handleHomeSiriOperation:(HomeSiriOperationIntent *)intent completion:(void (^)(HomeSiriOperationIntentResponse * _Nonnull))completion
{
    NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁%s",__func__);
//    JCYWolItem *item = [JCYWolMannger loadWolItem];
//    NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁-handleHome-JCYWolItem === %@",item);
    HomeSiriOperationIntentResponse *response = [[HomeSiriOperationIntentResponse alloc] initWithCode:HomeSiriOperationIntentResponseCodeSuccess userActivity:nil];
        completion(response);
   
}


- (void)confirmHomeSiriOperation:(HomeSiriOperationIntent *)intent completion:(void (^)(HomeSiriOperationIntentResponse * _Nonnull))completion
{
    NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁-confirmHomeSiriOperation");
    JCYWolItem *item = [JCYWolMannger loadWolItem];
    NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁-JCYWolItem === %@",item);
    if (!item) {
        item = [JCYWolMannger defaultWolItem];
    }
    if (item) {
        [[[JCYWolMannger alloc] init] sendUdpWithJCYWolItem:item completed:^(NSString * _Nonnull msg, BOOL succ) {
            NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁 sendUdpWithJCYWolItem");
            HomeSiriOperationIntentResponse *readyResponse = [[HomeSiriOperationIntentResponse alloc] initWithCode:HomeSiriOperationIntentResponseCodeReady userActivity:nil];
            completion(readyResponse);
        }];
    }
    else {
        HomeSiriOperationIntentResponse *readyResponse = [[HomeSiriOperationIntentResponse alloc] initWithCode:HomeSiriOperationIntentResponseCodeFailure userActivity:nil];
        completion(readyResponse);
    }
    
    
}


@end
