import { router } from '@kit.ArkUI';
import { authentication } from '@kit.AccountKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { dealAllError } from '../../../common/function/error';

@Entry
struct personalInformation {
    @StorageProp('nickname') nickname: string | undefined = AppStorage.get('nickname') ?? '默认昵称';
    @StorageProp('phone') phone: string = AppStorage.get('phone') ?? '18888888888';
    @State inputText: string = '';
    @State type: string = '';
    @State avatarUri: string | undefined = '';

    aboutToAppear(): void {
        const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
        authRequest.scopes = ['profile'];
        authRequest.forceAuthorization = true;
        authRequest.state = util.generateRandomUUID();

        try {
            const controller =
                new authentication.AuthenticationController(this.getUIContext().getHostContext());
            controller.executeRequest(authRequest).then((data) => {
                const authorizationWithHuaweiIDResponse =
                    data as authentication.AuthorizationWithHuaweiIDResponse;
                const state = authorizationWithHuaweiIDResponse?.state;
                if (state && authRequest.state !== state) {
                    hilog.error(0x0000, 'testTag',
                        `Failed to authorize. The state is different, response state: ${state}`);
                    return;
                }
                hilog.info(0x0000, 'testTag', 'Succeeded in authentication.');
                const authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse?.data;
                const avatarUri = authorizationWithHuaweiIDCredential?.avatarUri;
                const nickName = authorizationWithHuaweiIDCredential?.nickName;
                const authorizationCode = authorizationWithHuaweiIDCredential?.authorizationCode;
                this.nickname = nickName
                this.avatarUri = avatarUri
                // 开发者处理avatarUri, nickName, authorizationCode
            }).catch((err: BusinessError) => {
                dealAllError(err);
            });
        } catch (error) {
            dealAllError(error);
        }
    }

    build() {
        Column() {
            Image($r('app.media.right_grey'))
                .width('16.00vp')
                .height('16.00vp')
                .rotate({ angle: 180 })
                .onClick(() => {
                    router.back()
                })
                .alignSelf(ItemAlign.Start)
                .margin({ left: '20.00vp', top: '20.00vp' })

            Column() {
                Row() {
                    Text('头像').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Image(this.avatarUri ? this.avatarUri : $r('app.media.circle'))
                        .width('30.00vp')
                        .height('30.00vp')
                        .border({ radius: 50 })
                        .margin({ right: '10.00vp' })
                }
                .width('90%')
                .height('50.00vp')
                .border({ width: { bottom: '1.00vp' }, color: '#cccccc', radius: { topLeft: 8, topRight: 8 } })
                .backgroundColor('#f9f9f9')

                Row() {
                    Text('昵称').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text(this.nickname).margin({ right: '10.00vp' })
                }
                .width('90%')
                .height('50.00vp')
                .border({ width: { bottom: '1.00vp' }, color: '#cccccc' })
                .backgroundColor('#f9f9f9')

                Row() {
                    Text('手机号').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text(this.phone).margin({ right: '10.00vp' })
                }
                .width('90%')
                .height('50.00vp')
                .border({ width: '1.00vp', color: '#f9f9f9', radius: { bottomLeft: 8, bottomRight: 8 } })
                .backgroundColor('#f9f9f9')
            }
            .margin({ top: '20.00vp' })

            Blank().layoutWeight(1)

            Button($r('app.string.LogOut'))
                .width('90%')
                .height('50.00vp')
                .backgroundColor('rgba(255, 0, 0, 0.15)')// 半透明红色背景
                .fontColor('rgba(255, 0, 0, 0.9)')// 较深红色文字
                .onClick(async () => {
                    await Promise.all([
                        PersistentStorage.deleteProp('token'),
                        PersistentStorage.deleteProp('user_id'),
                        PersistentStorage.deleteProp('huawei_id'),
                        PersistentStorage.deleteProp('phone')
                    ])
                    router.replaceUrl({ url: 'pages/Login/Login' })
                })

        }.height('100%').width('100%')
    }
}