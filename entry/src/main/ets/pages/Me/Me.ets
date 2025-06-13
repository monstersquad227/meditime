import { router } from "@kit.ArkUI";
import { authentication } from "@kit.AccountKit";
import { util } from '@kit.ArkTS';
import { hilog } from "@kit.PerformanceAnalysisKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { dealAllError } from "../../common/function/error";


@Component
export struct Me {
    @StorageProp('nickname') nickname: string | undefined = AppStorage.get('nickname') ?? '默认昵称';
    @State avatarUri: string | undefined = ''

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
        Column({ space: '20.00vp' }) {
            Image(this.avatarUri ? this.avatarUri : $r('app.media.circle'))
                .border({ radius: 50 })
                .width('80')
                .height('80')
                .margin({
                    top: 50
                })

            Text(this.nickname)

            Row() {
                Column({ space: '8.00vp' }) {
                    Image($r('app.media.record'))
                        .width('32.00vp')
                        .height('32.00vp')
                    Text($r('app.string.FAQ'))
                }
                .margin({ left: '10.00vp' })
                .onClick(() => {
                    router.pushUrl({ url: 'pages/Me/featureFeedback/featureFeedback' })
                })

                Blank().layoutWeight(1)

                Column({ space: '8.00vp' }) {
                    Image($r('app.media.edit'))
                        .width('32.00vp')
                        .height('32.00vp')
                    Text($r('app.string.PersonalInformation'))
                }
                .onClick(() => {
                    router.pushUrl({ url: 'pages/Me/personalInformation/personalInformation' })
                })

                Blank().layoutWeight(1)

                Column({ space: '8.00vp' }) {
                    Image($r('app.media.circle'))
                        .width('32.00vp')
                        .height('32.00vp')
                    Text($r('app.string.Feedback'))
                }
                .margin({ right: '10.00vp' })
                .onClick(() => {
                    router.pushUrl({ url: 'pages/Me/featureFeedback/featureFeedback' })
                })
            }
            .width('90%')
            .height('100.00vp')
            .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
            .backgroundColor('#f9f9f9')

            Row() {
                Text($r('app.string.SupportAuthor')).margin({ left: '10.00vp' })

                Blank().layoutWeight(1)

                Image($r('app.media.right_grey'))
                    .width('16.00vp')
                    .height('16.00vp')
                    .margin({ right: '10.00vp' })
            }
            .width('90%')
            .height('50.00vp')
            .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
            .backgroundColor('#f9f9f9')

        }.height('100%').width('100%')
    }
}