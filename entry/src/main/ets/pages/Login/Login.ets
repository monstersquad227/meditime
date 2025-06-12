import { authentication, loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { promptAction, router } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { JSON, util } from '@kit.ArkTS';
import { medicineLogin } from '../../common/function/medicineLogin';
import { LoginRequestData } from '../../common/interface/medicineLogin';
import { preferences } from '@kit.ArkData';

@Entry
@Component
@Preview
export struct Login {

    @State avatarUri: string|undefined = '';
    @State nickName: string|undefined = '';

    controller: loginComponentManager.LoginWithHuaweiIDButtonController =
        new loginComponentManager.LoginWithHuaweiIDButtonController()
            .setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
            .onClickLoginWithHuaweiIDButton(async (error, response) => {
                if (error) {
                    promptAction.showToast({ message: '请先阅读并同意隐私协议' })
                } else {
                    let data: LoginRequestData = {
                        authorization_code: response.authorizationCode
                    }
                    let result = await medicineLogin(data);

                    if (!result) {
                        promptAction.showToast({ message: '登录失败，请重试' });
                        return;
                    }
                    const token = result.token
                    const user_id = result.user.id
                    const huawei_id = result.user.huawei_id
                    const phone = result.user.phone_num

                    PersistentStorage.persistProp('token', token);
                    PersistentStorage.persistProp('user_id', user_id);
                    PersistentStorage.persistProp('huawei_id', huawei_id);
                    AppStorage.setOrCreate('phone', phone);

                    // AppStorage.setOrCreate('token', result.token);
                    // PersistentStorage.persistProp('token', result.token);
                    // AppStorage.setOrCreate('token', result.token);
                    //
                    // AppStorage.setOrCreate('huaweiID', result.user.huawei_id)
                    // PersistentStorage.persistProp('huaweiID', result.user.huawei_id);
                    //
                    // AppStorage.setOrCreate('user_id', result.user.id)
                    // PersistentStorage.persistProp('user_id', result.user.id);
                    //
                    // AppStorage.setOrCreate('phone', result?.user.phone_num)
                    // PersistentStorage.persistProp('phone', result.user.phone_num);

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