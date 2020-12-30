//
//  JCYInputView.h
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCYInputView : UIView

@property (nonatomic, strong) NSString *resultString;
@property (nonatomic, copy) void(^resultBlock)(NSString *resultString);
@property (nonatomic, copy) void(^beginBlock)(void);
@property (nonatomic, copy) void(^errBlock)(NSString *msg);

@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
