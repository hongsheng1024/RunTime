//
//  WebViewController.m
//  RunTimeDemo
//
//  Created by yanghuan on 2018/10/30.
//  Copyright © 2018 whs. All rights reserved.
//

#import "WebViewController.h"
#import "UIViewExt.h"

@interface WebViewController ()<UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"WebView";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MAINSCREENWIDTH, 200)];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
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
    NSString *absolutePath = request.URL.absoluteString;
    NSString *scheme = request.URL.scheme;
    NSString *host = request.URL.host;
    NSString *query = request.URL.query;
    
    if ([scheme caseInsensitiveCompare:@"jsToOc"] == NSOrderedSame) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"JS调OC01" message:query delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }else if ([scheme caseInsensitiveCompare:@"rrcc"] == NSOrderedSame){
        NSString *schemeStr = @"rrcc://";
        NSString *subPath = [absolutePath substringFromIndex:schemeStr.length];
        if ([subPath containsString:@"?"]) {//1个或多个参数
            if ([subPath containsString:@"&"]) {//多个参数
                NSArray *components = [subPath componentsSeparatedByString:@"?"];
                NSString *methodName = [components firstObject];
                methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                SEL sel = NSSelectorFromString(methodName);
                NSString *parameter = [components lastObject];
                NSArray *params = [parameter componentsSeparatedByString:@"&"];
                if (params.count == 2) {
                    if ([self respondsToSelector:sel]) {
                        [self performSelector:sel withObject:[params firstObject] withObject:[params lastObject]];
                    }
                }
            }else{//1个参数
                NSArray *components = [subPath componentsSeparatedByString:@"?"];
                
                NSString *methodName = [components firstObject];
                methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                SEL sel = NSSelectorFromString(methodName);
                NSString *parameter = [components lastObject];
                if ([self respondsToSelector:sel]) {
                    [self performSelector:sel withObject:parameter];
                }
            }
        }else{//没有参数
            NSString *methodName = [subPath stringByReplacingOccurrencesOfString:@"_" withString:@":"];
            SEL sel = NSSelectorFromString(methodName);
            
            if ([self respondsToSelector:sel]) {
                [self performSelector:sel];
            }
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - Action
- (void)loginBtn01Action:(UIButton *)btn{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *jsString = [NSString stringWithFormat:@"ocToJs('loginSucceed', 'oc_tokenString')"];
        //只有在整个webView加载完成之后调用此方法才会有响应
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];
        //获取标题
        NSLog(@"标题：%@", [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]);
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

- (void)showMobile{
    NSLog(@"showMobile");
}
- (void)showName:(NSString *)name{
    NSLog(@"showName：%@", name);
   
}

- (void)showSendNumber:(NSString *)phone msg:(NSString *)msg{
    NSLog(@"showSendNumbermsg:==phone：%@===msg：%@", phone, msg);
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
