
######你是否有过这种烦恼？大冬天的，洗漱完了，钻进被窝，发现主机忘记关了,还得爬起来关，怪冷的;早上出门太急，一到家发现主机还开着,一天的电费又浪费了；周末早上不想起床，就像想看个电影，打个游戏，但是游戏手柄在旁边，主机却在两三米开外，过去太冷，想了想，还是继续睡吧。

***

####功能：
* 通过向HomePod发送语音指令“嘿Siri”，唤醒或者关闭windows台式机或者笔记本。

####说明：
1. 开关机均依赖快捷指令，快捷指令刚开始的时候可能无法对应语音操作，让它学习会儿就好了。
- 关机设置贼简单，开机设置稍微麻烦一丢丢。
- 快捷指令中的标题可以随便改，不过siri有记忆功能，你即使改了标题，可能还是会接受原标题的的语音。

####硬件支持：
1. iphone/ipad，HomePod/HomePod mini，windows主机。
- 开机功能还需要能跑xcode的黑苹果或者macbook。

####说明：
homepod也可以用`iPhone7`以上手机或者`ipad2018`以上代替，但是这俩`光感遮挡的情况下`，是无法语音唤醒siri的，而且设置开机的话，必须安装对应app，太麻烦了。并且用这种经常移动的设备，用它们来当智能家居的媒介，多少有点别扭。

####语音操作：
* 对着HomePod说：`"嘿，Siri，打开台式机"`，则唤醒主机。
* 对着HomePod说：`"嘿，Siri，关闭台式机"`，则关闭主机。

***
***

##开机：（turnOn文件）
###&emsp;前置条件：
1. 主板支持网卡启动，只要不是几十块钱的主板，就一定支持。
- iphone系统满足iOS13及以上，用户appleid满足iOS开发者权限。
- 台式机网线保持连接，并且主机电源通电。


###&emsp;操作说明：
1. 使用xcode把app跑到手机上。
- 打开app，查询windows的mac、ip，并前往防火墙设置端口号（入站规则中设置udp端口入站，一定要选择udp），添加到app对应填空中。
- 点击“添加Siri”按钮，输入自己的觉得没毛病的话，并点击蓝色按钮添加。
- 查看“快捷指令”app，是否有自己刚刚添加的没毛病的话。
- 保证homepod和iPhone联网。
- 关闭windows，尝试语音开机。

###&emsp;原理：
   * iPhone应用的产生Siri捷径（其实也是快捷指令，为区别与原生应用“快捷指令”，称为Siri捷径）支持转移到HomePod上的（苹果官网没说明，其实是可以的）。Siri捷径支持向局域网中发送udp包，电脑网卡接收udp并验证mac地址后开机。

###&emsp;说明：
1. 快捷指令仅仅支持应用层协议（http等），因此只能用Siri捷径。
- app生成的Siri捷径会直接添加到快捷指令中，并且在设备联网时，共享到所有同appleid设备。
- 无需唤醒app的Siri捷径均可以转移到HomePod中，但是无法转移到没有安装对应app的iPhone或者iPad中（比如iPhone中的Siri捷径，通过iCloud转移到了iPad中，若ipad无此应用则无法执行对应捷径）；
- Siri捷径不必非要打开app，可以自定义意图。
- 网卡唤醒（WOL）需要接受udp包才能唤醒主板，可以用广播的形式，也可以直接发送。MacBook测试可以用蓝牙共享网络，并且wireshark抓包；windows测试可以直接用WakeOnLAN即可，记得需要开放对应入站端口，Win10测试过程中，如果没开则会报黄框，win7不知道。
- 近十年的主板都支持WOL，不用问主板客服的，想要熟悉WOL，直接百度即可。


##关机：（turnDown文件）
###&emsp;前置条件：
1. windows安装node，并且windows打开对应showdown.js中对应入站端口（默认为1203）。
- iphone安装“快捷指令”app。
- 路由器支持内网穿透。（可选，针对广域网，突然想起家里电脑没关，靠这个）。

###&emsp;操作说明：
1. 把shortcut文件或者“关机快捷指令下载地址.txt”中的地址直接在iPhone或者ipad中打开安装。
- 靠近homepod，休息几分钟。
- 安装node，并cd到shoutdow目录下，查看两个js文件需要哪些库，自行安装。 执行
 ```
 node ./bg_run.js install。
 ```
- 若弹框，则一直点击确定即可。

###&emsp;原理：
* 保证nodejs文件开机自启，可以接收外来请求。homepod发送已经在iPhone设置好的快捷指令请求windows对应nodejs。

###&emsp;说明：
1. 如果要改到公网，记得把接口参数改的复杂些，代码在shoutdow.js中。
- 快捷指令中的“如果 网络名称 包含 jcywifi”，那是因为我的wifi的名字是这个，可以随便改。
- 因为我设置了外网访问，加了花生壳，所有对应逻辑删不删都可以。

