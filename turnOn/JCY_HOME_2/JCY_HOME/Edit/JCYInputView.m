//
//  JCYInputView.m
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/29.
//

#import "JCYInputView.h"
#import "JCYInputLabel.h"
@interface JCYInputView ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,strong)JCYInputLabel *label;


@end

@implementation JCYInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _textField = [[UITextField alloc]initWithFrame:self.bounds];
        _textField.hidden =YES;
        _textField.delegate =self;
        _textField.font = [UIFont systemFontOfSize:25];
        [self insertSubview:self.textField atIndex:0];
        _label = [[JCYInputLabel alloc]initWithFrame:self.bounds];
        _label.font =self.textField.font;
        _label.blockCount = 6;
        [self addSubview:self.label];
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    self.label.showInputLine = YES;
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    self.label.showInputLine = NO;
    [self.label resignFirstResponder];
    return [self.textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.beginBlock) {
        self.beginBlock();
    }
    [self.textField becomeFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.label.showInputLine = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textFieldStr = textField.text =  [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length != 0) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![string isEqualToString:filtered]) {
            return NO;
        }
        if (textFieldStr.length  < self.label.blockCount * BLOCK_NUMBER) {
            self.label.text = [textFieldStr stringByAppendingString:string];
            self.resultString = self.label.text;
            if (self.label.text.length  == self.label.blockCount * BLOCK_NUMBER) {
                if (self.resultBlock) {
                    self.resultBlock(self.label.text);
                }
            }
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        if (textFieldStr.length == 0 ) {
            self.label.text = @"";
        }
        else {
            self.label.text = [textFieldStr substringToIndex:textFieldStr.length -1];
        }
        self.resultString = self.label.text;
        return YES;
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.resultString = title;
    self.textField.text = title;
    self.label.text = title;
}

@end
