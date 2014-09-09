//
//  ISUNavigator.h
//  MobileContactApplication
//
//  Created by Justin Yang on 14-9-8.
//  Copyright (c) 2014年 Nanjing University. All rights reserved.
//

@interface ISUNavigator : NSObject

/**
 具体由不同的App来定义。
 一般在业务层中需要重载提供自定义的NVNavigator（使用NVInternal.h NVInternalSetNavigator），并且子类必须实现NVNavigator
 */
+ (ISUNavigator *)sharedInstance;

/**
 设置程序的主导航控制器
 所有的页面跳转都会在mainNavigationContorller中进行
 */
//- (void)setMainNavigationController:(NVCoreNavigationController *)mainNavigationContorller;

/**
 设置可以处理的URL Scheme
 默认是：@"dianping"
 */
//- (void)setHandleableURLScheme:(NSString *)scheme;

/**
 设置URL mapping文件名称
 url mapping文件只能是包含在工程项目中的文件
 例如：
 @[@"dpmapping.dat", @"dptuanmapping.dat"]
 */
- (void)setFileNamesOfURLMapping:(NSArray *)fileNames;


/////////////////////////////////////////////////////////////////////////////////////////

/**
 在当前的NVNavigator栈中打开新的URL，
 简写方法是: NVOpenURL(NSURL *url)
 
 例如：
 [[NVNavigator navigator] openURL:[NSURL URLWithString:@"dianping://shop?id=123"]]
 或
 NVOpenURL([NSURL URLWithString:@"dianping://shop?id=123"])
 */
- (UIViewController *)openURL:(NSURL *)url fromViewController:(UIViewController *)controller;

/**
 在当前的NVNavigator栈中打开新的URL，
 简写方法是: NVOpenURLString(NSString *urlString)
 
 例如:
 [[NVNavigator navigator] openURLString:@"dianping://shop?id=123"]
 或
 NVOpenURL(@"dianping://shop?id=123")
 */
- (UIViewController *)openURLString:(NSString *)urlString fromViewController:(UIViewController *)controller;

/**
 在当前的NVNavigator栈中打开新的URL
 简写方法是: NVOpenURLAction(NVURLAction *urlAction)
 
 可以向NVURLAction中传入制定的参数，参数可以为integer, double, string, NVObject四种类型
 bool的参数可以用0和1表示
 如果希望传入任意对象，可以使用setAnyObject:forKey:方法
 
 URL中附带的参数和setXXX:forKey:所设置的参数等价，
 例如下面两种写法是等价的：
 NVURLAction *a = [NVURLAction actionWithURL:@"dianping://shop?id=1"];
 和
 NVURLAction *a = [NVURLAction actionWithURL:@"dianping://shop"];
 [a setInteger:1 forKey:@"id"]
 
 在获取参数时，调用[a integerForKey:@"id"]，返回值均为1
 */
//- (UIViewController *)openURLAction:(NVURLAction *)urlAction fromViewController:(UIViewController *)controller;

//- (UIViewController *)openURLAction:(NVURLAction *)urlAction;

@end


@interface UIViewController (NVNavigator)
- (UIViewController *)openURLHost:(NSString *)urlHost;
- (UIViewController *)openURL:(NSURL *)url;
- (UIViewController *)openURLString:(NSString *)urlString;
- (UIViewController *)openHttpURLString:(NSString *)httpURLString;
- (UIViewController *)openURLFormat:(NSString *)urlFormat, ...;
//- (UIViewController *)openURLAction:(NVURLAction *)urlAction;
- (void)openURLList:(NSArray *)urlList;
@end