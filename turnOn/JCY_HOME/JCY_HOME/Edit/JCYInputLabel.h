//
//  JCYInputLabel.h
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#define BLOCK_NUMBER 2
NS_ASSUME_NONNULL_BEGIN

@interface JCYInputLabel : UILabel

//输入块数
@property (nonatomic,assign)NSInteger blockCount;

@property (nonatomic,assign)BOOL showInputLine;

@end

NS_ASSUME_NONNULL_END
