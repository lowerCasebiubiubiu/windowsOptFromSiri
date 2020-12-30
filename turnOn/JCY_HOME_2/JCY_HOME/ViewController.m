//
//  ViewController.m
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/28.
//



#import "ViewController.h"

#import "JCYInputView.h"
#import "JCYWolMannger.h"


#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>
#import "HomeSiriOperationIntent.h"

@interface ViewController ()
<UITextFieldDelegate,INUIAddVoiceShortcutViewControllerDelegate>


@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *macTitle;
@property (nonatomic, strong) JCYInputView *macInputView;

@property (nonatomic, strong) UILabel *ipTitle;
@property (nonatomic, strong) UITextField *ipTextField;

@property (nonatomic, strong) UILabel *portTitle;
@property (nonatomic, strong) UITextField *portTextField;


@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *checkoutButton;
@property (nonatomic,assign) BOOL addedShortcut;

@property (nonatomic, strong) UIButton *sendButton;    //发送开机指令
@property (nonatomic, strong) UIButton *setSiriButton; //设置Siri捷径

@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 300, 40)];
    self.tipLabel.font = [UIFont boldSystemFontOfSize:14];
    self.tipLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.tipLabel];
    
    self.macTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 40)];
    self.macTitle.text = @"MAC地址:";
    self.macTitle.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:self.macTitle];
    JCYInputView *macView = [[JCYInputView alloc] initWithFrame:CGRectMake(20+80+5, 100, 200, 40)];
    macView.resultBlock = ^(NSString * _Nonnull resultString) {
        NSLog(@"resultString---%@",resultString);
    };
    __weak typeof(self) wself = self;
    macView.beginBlock = ^{
        [wself enableButton:wself.sendButton status:NO];
        [wself enableButton:wself.setSiriButton status:NO];
    };
    self.macInputView = macView;
    [self.view addSubview:macView];
    
    self.ipTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 80, 40)];
    self.ipTitle.text = @"IP地址:";
    self.ipTitle.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:self.ipTitle];
    self.ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(20+80+5, 160, 200, 40)];
    self.ipTextField.delegate = self;
    self.ipTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:self.ipTextField];
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(0.0f, 39, 200, 1.0f);
    bottomLine.backgroundColor = [UIColor blackColor].CGColor;
    [self.ipTextField setBorderStyle:UITextBorderStyleNone];
    [self.ipTextField.layer addSublayer:bottomLine];
    
    
    self.portTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 80, 40)];
    self.portTitle.text = @"端口号:";
    self.portTitle.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:self.portTitle];
    self.portTextField = [[UITextField alloc] initWithFrame:CGRectMake(20+80+5, 220, 200, 40)];
    self.portTextField.delegate = self;
    self.portTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.portTextField];
    CALayer *bottomLine2 = [CALayer layer];
    bottomLine2.frame = CGRectMake(0.0f, 39, 200, 1.0f);
    bottomLine2.backgroundColor = [UIColor blackColor].CGColor;
    [self.portTextField setBorderStyle:UITextBorderStyleNone];
    [self.portTextField.layer addSublayer:bottomLine2];
    
    self.defaultButton = [self createButtonTitle:@"默认填充" action:@selector(defaultAction)];
    self.defaultButton.frame = CGRectMake(20, 300, 100, 50);
    [self.view addSubview:self.defaultButton];
    
    self.checkoutButton = [self createButtonTitle:@"校验数据" action:@selector(checkoutAction)];
    self.checkoutButton.frame = CGRectMake(140, 300, 100, 50);
    [self.view addSubview:self.checkoutButton];
    
    self.sendButton = [self createButtonTitle:@"发送请求" action:@selector(sendAction)];
    self.sendButton.frame = CGRectMake(20, 380, 100, 50);
    [self.view addSubview:self.sendButton];
    
    self.setSiriButton = [self createButtonTitle:@"设置捷径" action:@selector(siriAction)];
    self.setSiriButton.frame = CGRectMake(140, 380, 100, 50);
    [self.view addSubview:self.setSiriButton];
    [self enableButton:self.sendButton status:NO];
    [self enableButton:self.setSiriButton status:NO];
}

- (void)initData
{
    JCYWolItem *item = [JCYWolMannger loadWolItem];
    if (item
        && [JCYWolMannger checkoutMac:item.mac]
        && [JCYWolMannger checkoutIp:item.ip]
        && item.port > 0
        && item.port < 32767) {
        self.macInputView.title = item.mac;
        self.ipTextField.text = item.ip;
        self.portTextField.text = @(item.port).stringValue;
        [self enableButton:self.sendButton status:YES];
        [self enableButton:self.setSiriButton status:YES];
        
    }
}

- (UIButton *)createButtonTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    button.backgroundColor = [UIColor yellowColor];
    [button sizeToFit];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)enableButton:(UIButton *)button status:(BOOL)status
{
    button.enabled = status;
    if (status) {
        button.backgroundColor = [UIColor yellowColor];
    }
    else {
        button.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view resignFirstResponder];
    [self.macInputView resignFirstResponder];
}

#pragma mark - Action
- (void)sendAction
{
    NSLog(@"sendAction");
    __weak typeof(self) wself = self;
    [[[JCYWolMannger alloc] init] sendUdpWithJCYWolItem:[JCYWolMannger loadWolItem] completed:^(NSString * _Nonnull msg, BOOL succ) {
        wself.tipLabel.text = msg;
    }];
}

- (void)defaultAction
{
    JCYWolItem *item = [JCYWolMannger loadWolItem];
    if (!item) {
        item = [JCYWolMannger defaultWolItem];
        NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁-- 需要自己创建数据");
    }
    self.macInputView.title = item.mac;
    self.ipTextField.text = item.ip;
    self.portTextField.text = @(item.port).stringValue;
}

- (void)siriAction
{
    NSLog(@"siriAction");
    HomeSiriOperationIntent *intent = [[HomeSiriOperationIntent alloc] init];
    intent.suggestedInvocationPhrase = @"打开台式机";
    INShortcut *shortcut = [[INShortcut alloc] initWithIntent:intent];
    
    INUIAddVoiceShortcutViewController *vc = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortcut];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)checkoutAction
{
    //校验MAC
    NSString *mac = self.macInputView.resultString;
    NSString *ip = self.ipTextField.text;
    NSString *port = self.portTextField.text?:@"";
    if (![JCYWolMannger checkoutMac:mac]) {
        NSLog(@"MAC地址校验失败");
        self.tipLabel.text = @"MAC地址校验失败";
    }
    else if (![JCYWolMannger checkoutIp:ip]){
        NSLog(@"ip地址校验失败");
        self.tipLabel.text = @"ip地址校验失败";
    }
    else if ([port intValue] <= 0) {
        NSLog(@"端口号校验失败");
        self.tipLabel.text = @"端口号校验失败";
    }
    else if ([port intValue] > 32767){
        NSLog(@"端口号校验失败,必须小于32767");
        self.tipLabel.text = @"端口号校验失败,必须小于32767";
    }
    else {
        self.tipLabel.text = @"校验成功";
        JCYWolItem *item = [JCYWolItem new];
        item.mac = mac;
        item.ip = ip;
        item.port = [port intValue];
        [JCYWolMannger saveWolItem:item];
        [self enableButton:self.sendButton status:YES];
        [self enableButton:self.setSiriButton status:YES];
    }
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self enableButton:self.sendButton status:NO];
    [self enableButton:self.setSiriButton status:NO];
    [self.macInputView resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0) {
        if (textField == self.ipTextField) {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            if (![string isEqualToString:filtered]) {
                return NO;
            }
        }
        else if (textField == self.portTextField) {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            if (![string isEqualToString:filtered]) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - INUIAddVoiceShortcutViewControllerDelegate
- (void)addVoiceShortcutViewController:(INUIAddVoiceShortcutViewController *)controller didFinishWithVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut error:(nullable NSError *)error
{
    NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁%s",__func__);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)addVoiceShortcutViewControllerDidCancel:(INUIAddVoiceShortcutViewController *)controller
{
    NSLog(@"测试Siri😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁%s",__func__);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
