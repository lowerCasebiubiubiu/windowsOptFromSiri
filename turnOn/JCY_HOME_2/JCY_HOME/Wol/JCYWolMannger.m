//
//  JCYWolMannger.m
//  JCY_HOME
//
//  Created by 贾创业 on 2020/12/29.
//

#import "JCYWolMannger.h"
#import "GCDAsyncUdpSocket.h" // for UDP

@implementation JCYWolItem

+ (BOOL)supportsSecureCoding
{
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.mac forKey:@"mac"];
    [coder encodeObject:self.ip forKey:@"ip"];
    [coder encodeInt:self.port forKey:@"port"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _mac = [coder decodeObjectOfClass:[NSString class] forKey:@"mac"];
        _ip = [coder decodeObjectOfClass:[NSString class] forKey:@"ip"];
        _port = [coder decodeIntForKey:@"port"];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"MAC:%@ ip:%@ port:%@",self.mac,self.ip,@(self.port)];
}

@end
@interface JCYWolMannger ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;

@end


@implementation JCYWolMannger


+ (void)saveWolItem:(JCYWolItem *)wolItem
{
    //app group 共享数据
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:wolItem requiringSecureCoding:YES error:nil];
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.jcyhome.siri.t2"] setValue:data forKey:@"jcywolItem"];
}

+ (JCYWolItem *)loadWolItem
{
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:@"group.jcyhome.siri.t2"] valueForKey:@"jcywolItem"];
    JCYWolItem *wol = [NSKeyedUnarchiver unarchivedObjectOfClass:[JCYWolItem class] fromData:data error:nil];
    return wol;
}


+ (JCYWolItem *)defaultWolItem
{
    JCYWolItem *wol = [JCYWolItem new];
    wol.mac = @"112233445566";//一共6*2=12个，把分号删掉，否则无法过正则，支持大小写
    wol.ip = @"10.0.0.130";
    wol.port = 1020;
    return wol;
}


- (void)sendUdpWithJCYWolItem:(JCYWolItem *)wolItem completed:(void(^)(NSString *msg,BOOL succ))completed
{
    [self sendUdpWithMac:wolItem.mac ip:wolItem.ip port:wolItem.port completed:completed];
}


- (void)sendUdpWithMac:(NSString *)mac ip:(NSString *)ip port:(uint16_t)port completed:(void(^)(NSString *msg,BOOL succ))completed
{
    //验证mac地址正确性
    if(![[self class] checkoutMac:mac])
    {
        if (completed) {
            completed(@"物理地址校验失败",NO);
        }
        return;
    }
    if(![[self class] checkoutIp:ip])
    {
        if (completed) {
            completed(@"IP地址校验失败",NO);
        }
        return;
    }
    NSMutableString *dataStringM = [NSMutableString string];
    //WOL协议要求16次mac地址重复
    for (int i = 0; i < 16; i++) {
        [dataStringM appendString:mac];
    }
    //计算mac地址数据总长度+标准头长度
    NSInteger count = 6+dataStringM.length/2;
    if (count != 102) {
        if (completed) {
            completed(@"物理地址长度错误",NO);
        }
        return;
    }
    //初始化udp数据空间，并初始化16进制数据头
    Byte byte[102] = {0xff,0xff,0xff,0xff,0xff,0xff};
    
    //填充mac地址数据
    for (NSUInteger i = 0; i < dataStringM.length; i++,i++) {
        if (dataStringM.length > (i+1)) {
           int result  = [self createByteWithHighChar:[dataStringM characterAtIndex:i] lowChar:[dataStringM characterAtIndex:i+1]];
            byte[i/2+6] = result;
        }
    }
    
    //生成data数据段
    NSData *bytes = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    
    //发送udp请求
    [self.udpSocket sendData:bytes toHost:ip port:port withTimeout:-1 tag:0];
    if (completed) {
        completed(@"发送数据成功",YES);
    }
}

//字符串转ASCII，再转10进制
- (int)createByteWithHighChar:(unichar)c1 lowChar:(unichar)c2
{
    //高位
    int high = c1 - '0';
    if (c1 >= 'a') {
        high = c1 - 'a' + 10;
    }
    if (c1 >= 'A') {
        high = c1 - 'A' + 10;;
    }
    
    //低位
    int low = c2 - '0';
    if (c2 >= 'a') {
        low = c2 - 'a' + 10;
    }
    if (c2 >= 'A') {
        low = c2 - 'A' + 10;
    }
    return high * 16 + low;
}

- (GCDAsyncUdpSocket *)udpSocket
{
    if (!_udpSocket) {
        _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _udpSocket;
}

+ (NSArray *)regularExpressionWithPattern:(NSString *)regexString str:(NSString *)str {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange totalRange = NSMakeRange(0, [str length]);
    NSArray *resultArray = [regex matchesInString:str options:0 range:totalRange];
    return resultArray;
}

+ (BOOL)checkoutMac:(NSString *)mac
{
    if (!mac) {
        return NO;
    }
    NSArray *arr = [self regularExpressionWithPattern:@"[0-9a-fA-F]{12}" str:mac];
    if (arr.count == 1) {
        NSTextCheckingResult *result = arr[0];
        if (result.range.length == mac.length) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)checkoutIp:(NSString *)ip
{
    if (!ip) {
        return NO;
    }
    NSArray *arr = [self regularExpressionWithPattern:@"^(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3}$" str:ip];
    if (arr.count == 1) {
        NSTextCheckingResult *result = arr[0];
        if (result.range.length == ip.length) {
            return YES;
        }
    }
    return NO;
}

@end
