//
//  JCYInputLabel.m
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/29.
//

#import "JCYInputLabel.h"



@implementation JCYInputLabel

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect1 {
    
    CGRect rect = self.bounds;
    
    float width = rect.size.width / self.blockCount;
    float height = rect.size.height;
    
    for (int i =0; i <self.text.length; i++,i++) {
        
        CGRect rectTmp =CGRectMake(i * width,0, width, height);
        
        NSString *cString = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
        if (self.text.length > i+1) {
            cString = [cString stringByAppendingString:[NSString stringWithFormat:@"%c",[self.text characterAtIndex:i+1]]];
        }
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:@{NSFontAttributeName:self.font}];
        CGSize cSize = [cString sizeWithAttributes:mutDic];
        NSInteger index = i/BLOCK_NUMBER;
        CGPoint point =CGPointMake(width * index + (width - cSize.width) /2.0, (rectTmp.size.height - cSize.height) /2.0);
        // 绘制验证码/密码
        [cString drawAtPoint:point withAttributes:mutDic];
    }
    //绘制底部横线
    for (int k=0; k<self.blockCount*BLOCK_NUMBER; k++) {
        [self drawBottomLineWitIndex:k];
        [self drawSenterLineWithIndex:k];
    }
}

//绘制底部的线条
- (void)drawBottomLineWitIndex:(int)k
{
    CGRect rect = self.bounds;
    float width = rect.size.width / self.blockCount;
    float height = rect.size.height;
    //1.获取上下文
    CGContextRef context =UIGraphicsGetCurrentContext();
    //2.设置当前上下问路径
    CGFloat lineHidth =0.25;
    CGFloat strokHidth =0.5;///////////////////
    CGContextSetLineWidth(context, 0.25);
    
    if (k <= self.text.length) {
        CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
        CGContextSetFillColorWithColor(context,[UIColor blueColor].CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
        CGContextSetFillColorWithColor(context,[UIColor greenColor].CGColor);
    }
    k /= BLOCK_NUMBER;
    CGRect rectangle =CGRectMake(k*width+width/10,height-lineHidth-strokHidth,width-width/5,strokHidth);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
}
//绘制中间的输入的线条
- (void)drawSenterLineWithIndex:(int)k{
    if ( k==self.text.length && self.showInputLine) {
        NSInteger index = k/BLOCK_NUMBER;
        CGRect rect = self.bounds;
        float width = rect.size.width / (float)self.blockCount;
        float height = rect.size.height;
        //1.获取上下文
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context,0.5);
        /****  设置竖线的颜色 ****/
        CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);//
        CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
        CGContextMoveToPoint(context, width * (index + (k%BLOCK_NUMBER?0.3:0)) + (width -1.0) /2.0, height/5);
        CGContextAddLineToPoint(context,  width * (index + (k%BLOCK_NUMBER?0.3:0)) + (width -1.0) /2.0,(height - height/4));
        CGContextStrokePath(context);
    }
}

- (void)setShowInputLine:(BOOL)showInputLine
{
    _showInputLine = showInputLine;
    [self setNeedsDisplay];
}

@end
