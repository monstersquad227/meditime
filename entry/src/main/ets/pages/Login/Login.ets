import { authentication, loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { promptAction, router } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { JSON, util } from '@kit.ArkTS';
import { medicineLogin } from '../../common/function/medicineLogin';

@Entry
@Component
@Preview
export struct Login {
    @State avatarUri: string|undefined = '';
    @State nickName: string|undefined = '';

    // onPageShow(): void {
    //     // 创建授权请求，并设置参数
    //     const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    //     // 获取头像昵称需要传如下scope
    //     authRequest.scopes = ['profile'];
    //     // 若开发者需要进行服务端开发，则需传如下permission获取authorizationCode
    //     authRequest.permissions = ['serviceauthcode'];
    //     // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    //     authRequest.forceAuthorization = true;
    //     // 用于防跨站点请求伪造
    //     authRequest.state = util.generateRandomUUID();
    //
    //     try {
    //         const controller = new authentication.AuthenticationController(getContext(this));
    //         controller.executeRequest(authRequest).then((data) => {
    //             const authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
    //             const state = authorizationWithHuaweiIDResponse.state;
    //             if (state && authRequest.state !== state) {
    //                 hilog.error(0x0000, 'testTag', `Failed to authorize. The state is different, response state: ${state}`);
    //                 return;
    //             }
    //             hilog.info(0x0000, 'testTag', 'Succeeded in authentication.');
    //             const authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
    //             const avatarUri = authorizationWithHuaweiIDCredential.avatarUri;
    //             const nickName = authorizationWithHuaweiIDCredential.nickName;
    //             const authorizationCode = authorizationWithHuaweiIDCredential.authorizationCode;
    //             // 开发者处理avatarUri, nickName, authorizationCode
    //             this.avatarUri = avatarUri
    //             this.nickName = nickName
    //             // hilog.info(0x0000, 'testTag', 'avatarUri: '+avatarUri);
    //             // hilog.info(0x0000, 'testTag', 'nickName: '+nickName);
    //             // hilog.info(0x0000, 'testTag', 'authorizationCode: '+authorizationCode);
    //         }).catch((err: BusinessError) => {
    //             promptAction.showToast({ message: JSON.stringify(err) })
    //         });
    //     } catch (error) {
    //         promptAction.showToast({ message: JSON.stringify(error) })
    //     }
    // }
    controller: loginComponentManager.LoginWithHuaweiIDButtonController =
        new loginComponentManager.LoginWithHuaweiIDButtonController()
            .setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
            .onClickLoginWithHuaweiIDButton(async (error, response) => {
                if (error) {
                    promptAction.showToast({ message: '请先阅读并同意隐私协议' })
                } else {
                    // hilog.info(0x0000, 'loginSuccess', JSON.stringify(response.authorizationCode));
                    let result = await medicineLogin(JSON.stringify(response.authorizationCode));
                    AlertDialog.show({ title: 'login', message: JSON.stringify(result)})
                    // PersistentStorage.persistProp('token', result?.token)
                    // AppStorage.setOrCreate('huaweiID', result?.user.huawei_id)
                    // AppStorage.setOrCreate('phone', result?.user.phone_num)
                    //
                    // hilog.info(0x0000, 'loginSuccessRepose', result?.user.huawei_id)
                    router.pushUrl({ url: 'pages/Dashboard/Dashboard'})
                }
            })
            .onClickEvent((error, clickEvent) => {
                if (error) {
                    promptAction.showToast({ message: 'onClickEvent error' })
                }
                if (clickEvent) {
                    promptAction.showToast({ message: clickEvent })
                }
            })
    privacyText: loginComponentManager.PrivacyText[] = [{
        text: '已阅读并同意',
        type: loginComponentManager.TextType.PLAIN_TEXT
    }, {
        text: '《用户服务协议》',
        tag: '用户服务协议',
        type: loginComponentManager.TextType.RICH_TEXT
    }, {
        text: '《隐私协议》',
        tag: '隐私协议',
        type: loginComponentManager.TextType.RICH_TEXT
    }, {
        text: '和',
        type: loginComponentManager.TextType.PLAIN_TEXT
    }, {
        text: '《华为账号用户认证协议》',
        tag: '华为账号用户认证协议',
        type: loginComponentManager.TextType.RICH_TEXT
    }];

    build() {
        Column() {
            Column({ space: '30.00vp' }) {
                Image($r('app.media.logo'))
                    .height('80.00vp')
                    .width('80.00vp')
                    .margin({ top: '150.00vp' })

                Text('按时吃药')

                LoginWithHuaweiIDButton({
                    params: {
                        style: loginComponentManager.Style.BUTTON_RED,
                        extraStyle: {
                            buttonStyle: new loginComponentManager.ButtonStyle().loadingStyle({
                                show: true
                            })
                        },
                        borderRadius: 24,
                        loginType: loginComponentManager.LoginType.QUICK_LOGIN,
                        supportDarkMode: true,
                        verifyPhoneNumber: true
                    },
                    controller: this.controller
                })
                    .height(40)
                    .width('90%')
                    .margin({ top: '130.00vp' })
            }

            Row() {
                Row() {
                    Checkbox({ name: 'privacyCheckbox', group: 'privacyCheckboxGroup' })
                        .width(24)
                        .height(24)
                        .focusable(true)
                        .focusOnTouch(true)
                        .margin({ top: 0 })
                        .onChange((value: boolean) => {
                            if (value) {
                                this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED)
                            } else {
                                this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
                            }
                        })
                }

                Row() {
                    Text() {
                        ForEach(this.privacyText, (item: loginComponentManager.PrivacyText) => {
                            if (item?.type === loginComponentManager.TextType.PLAIN_TEXT && item?.text) {
                                Span(item?.text)
                                    .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                                    .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                                    .fontWeight(FontWeight.Regular)
                                    .fontSize($r('sys.float.ohos_id_text_size_body3'))
                            } else if (item?.type === loginComponentManager.TextType.RICH_TEXT && item?.text) {
                                Span(item?.text)
                                    .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
                                    .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                                    .fontWeight(FontWeight.Medium)
                                    .fontSize($r('sys.float.ohos_id_text_size_body3'))
                                    .focusable(true)
                                    .focusOnTouch(true)
                                    .onClick(() => {
                                        if (item.tag === '华为账号用户认证协议') {
                                            this.openURL('https://privacy.consumer.huawei.com/legal/id/authentication-terms.htm?code=CN&language=zh-CN')
                                        } else if (item.tag === '隐私协议') {
                                            router.pushUrl({ url: 'pages/Login/Privacy/PrivacyPolicy'})
                                        } else {
                                            router.pushUrl({ url: 'pages/Login/Privacy/UserService'})
                                        }
                                    })
                            }
                        }, (item: loginComponentManager.PrivacyText) => item.text.toString())
                    }
                    .width('100%')
                }
                .margin({ left: 12 })
                .layoutWeight(1)
                .constraintSize({ minHeight: 24 })
            }
            .alignItems(VerticalAlign.Top)
            .margin({ top: '16.00vp', bottom: '16.00vp' })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height('100%')
        .width('100%')
    }

    private openURL(url: string) {
        let context = this.getUIContext().getHostContext() as common.UIAbilityContext;

        let want: Want = {
            action: 'ohos.want.action.viewData', // 改为 viewData
            uri: url,
            entities: ['entity.system.browser'],
        };

        try {
            context.startAbility(want).then(() => {
                // 成功回调可省略
            }).catch((err: BusinessError) => {
                promptAction.showToast({ message: '启动浏览器失败: ' + JSON.stringify(err) });
            });
        } catch (err) {
            promptAction.showToast({ message: '异常: ' + JSON.stringify(err) });
        }
    }

}