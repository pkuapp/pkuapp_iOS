# 颐和园路五号
 
## 颐和园路5号 iOS 版本应用工程说明
 
### 一、服务器端接口
 
本应用所使用的全部服务器端接口使用使用说明请参考颐和园路5号开发小组内部 wiki（<http://www.pkucada.org:3000/redmine/projects/org-pkucada-pkuapp-server/wiki/Server-based_Development_Kit>）说明。

### 二、项目所使用的第三方库
 
 1. `ASIHttpRequest` 封装了 iOS 网络连接部分的库，在全部的 HTTP 连接部分使用。
 2. `RegexKitLite` 给 `NSString` 添加了正则表达式功能，目前用来解析网关部分的返回串。在 `IPGateHelper` 类中使用
 3. `Nimbus Attributed Label` 用来显示富文本信息的库。
 4. `MBProgressHUD` 用来模仿 Apple 默认半透明风格的操作通知，在 `FirstViewController`、`GateViewController` 中使用。
 5. `AsyncUdpSocket` iOS UDP 连接库，用来使用 its 的心跳服务，在 `IPGateHelper` 类中使用。
 6. `SBJSON` iOS 的 JSON 解析库，在全部的与服务器通信的部分使用。
 7. `ModalAlert.h` 某本书上的示例代码。忘记是否自己修改过。参见 `ModalAlert.h` 注释说明。在 `GateViewController` 类使用。
 8. `AFNetworking` 用来替代 `ASIHttpRequest` 的网络库。因为 `ASIHttpRequest` 已经停止开发（非常遗憾），在 iOS 5 上其 HTTPS 部分无法正常工作。
 9. `Three20` 一整套的第三方支持开发库，目前只用到了它的 `launcherView`，为了自定义外观而调整了部分代码。由于直接打包了项目目录和 `Three20` 的目录，所以项目文件直接可用。
 10. 未来会添加 Google Analytics 的 SDK。
 
 对以上第三方库的作者表示膜拜与感谢。
 
### 三、工程文件说明
    ./
    -- Environment.h    定义所使用的服务器端接口地址。
    -- SystemHelper.h   系统环境所需学期时间相关方法、部分类无关的方法合集。仅有类方法。
    -- ThirdPart support/    所有第三方库位置
    -- CoreDataModels/  CoreData 模式定义, 由于从 xcdatamodel 文件导出子类定义会覆盖文件，因此请在 ModelsAddon.h 定义自定义方法。
    -- Calendar/    日程部分定义，作业子部分在 CoursesView 部分定义
    -- ClassroomHelper/     教室查询定义
    -- CoursesView/     课程部分视图定义
    -- MainView     主视图定义
    -- FirstView    登录部分定义，命名为 FirstView 源于历史原因。
    -- Supporting Files/    包含全部的图像资源以及初始课程数据库
        -- EULA HTMLS   协议视图内容

### 四、项目已知问题
 
 1. 命名问题，项目名‘iOSOne’及‘FirstViewController’等历史遗留问题目前尚未进行修改，倘若再不修改，恐积重难返吧魂淡。
 2. CoreData Migration 逻辑尚未添加。
 3. 其他无数的小 bug，按下不表……