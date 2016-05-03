//
//  LoginViewController.m
//  Leisure
//
//  Created by 左建军 on 16/4/7.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//  返回按钮
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//  登录按钮
- (IBAction)login:(id)sender {
    [NetWorkrequestManage requestWithType:POST url:LOGIN_URL parameters:@{@"email" : _emailTextField.text, @"passwd" : _passwordTextField.text} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dataDic = %@", dataDic);
        
        NSNumber *result = [dataDic objectForKey:@"result"];
        
        //登录失败
        if ([result intValue] == 0) {
            NSLog(@"msg = %@", [[dataDic objectForKey:@"data"] objectForKey:@"msg"]);
            NSString *message = [[dataDic objectForKey:@"data"] objectForKey:@"msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alertView show];
        } else { //登录成功
            NSLog(@"data = %@", [dataDic objectForKey:@"data"]);
            //保存用户的auth
            [UserInfoManager conserveUserAuth:[[dataDic objectForKey:@"data"] objectForKey:@"auth"]];
            //保存用户名
            [UserInfoManager conserveUserName:[[dataDic objectForKey:@"data"] objectForKey:@"uname"]];
            //保存用户id
            [UserInfoManager conserveUserID:[[dataDic objectForKey:@"data"] objectForKey:@"uid"]];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } error:^(NSError *error) {
        
    }];
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
