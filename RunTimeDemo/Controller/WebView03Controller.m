//
//  WebViewController.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/30.
//  Copyright © 2018 whs. All rights reserved.
//

#import "WebView03Controller.h"
#import "UIViewExt.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol OCJSExport <JSExport>

//为OC的-jsToOC:params:方法起个JS认识的别名jsToOc
JSExportAs(jsToOc, - (void)jsToOc:(NSString *)action params:(NSString *)params);
JSExportAs(showSendMsg, - (void)showSendMsg:(NSString *)phone params:(NSString *)msg);
JSExportAs(showName, - (void)showName:(NSString *)name);
//无参数和单参数时可不起别名
- (void)showMobile;

@end


@interface WebView03Controller ()<UIWebViewDelegate, OCJSExport>

@property(nonatomic, strong)UIWebView *webView;

@end

@implementation WebView03Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"WebView";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MAINSCREENWIDTH, 200)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test03" ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    UIButton *loginBtn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn01.frame = CGRectMake(20, _webView.bottom + 30, 120, 40);
    [loginBtn01 setBackgroundColor:[UIColor grayColor]];
    [loginBtn01 setTitle:@"OC调用JS01" forState:UIControlStateNormal];
    [loginBtn01 addTarget:self action:@selector(loginBtn01Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn01];
    
    UIButton *alertMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    alertMobile.frame = CGRectMake(20, loginBtn01.bottom + 10, 120, 40);
    [alertMobile setBackgroundColor:[UIColor grayColor]];
    alertMobile.tag = 123;
    [alertMobile setTitle:@"alertMobile" forState:UIControlStateNormal];
    [alertMobile addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertMobile];
    
    UIButton *alertName = [UIButton buttonWithType:UIButtonTypeCustom];
    alertName.frame = CGRectMake(20, alertMobile.bottom + 10, 120, 40);
    [alertName setBackgroundColor:[UIColor grayColor]];
    alertName.tag = 234;
    [alertName setTitle:@"alertName" forState:UIControlStateNormal];
    [alertName addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertName];
    
    UIButton *alertSendMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    alertSendMsg.frame = CGRectMake(20, alertName.bottom + 10, 120, 40);
    [alertSendMsg setBackgroundColor:[UIColor grayColor]];
    alertSendMsg.tag = 345;
    [alertSendMsg setTitle:@"alertSendMsg" forState:UIControlStateNormal];
    [alertSendMsg addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertSendMsg];
    
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

//UIWebView在每次加载请求完成后会调用此方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //获取JS代码的执行环境/上下文/作用域
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //! 在context注册OCJSBridge对象为self
    context[@"OCJSBridge"] = self;//!< 有循环引用问题
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - Action
- (void)loginBtn01Action:(UIButton *)btn{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        [context evaluateScript:[NSString stringWithFormat:@"ocToJs('loginSucceed', 'oc_tokenString')"]];
        
    });
}



- (void)btnAction:(UIButton *)sender{
    if (sender.tag == 123) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"alertMobile()"];
    }
    
    if (sender.tag == 234) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"alertName('小红')"];
    }
    
    if (sender.tag == 345) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"alertSendMsg('18870707070','周末爬山真是件愉快的事情')"];
    }
}

#pragma mark - JSExport functions

//! 实现OCJSExport协议的方法
- (void)jsToOc:(NSString *)action params:(NSString *)params {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:action message:params delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

- (void)showMobile{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"showMobile" message:@"showMobile" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

- (void)showName:(NSString *)name{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:name delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

- (void)showSendMsg:(NSString *)phone params:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:phone message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


