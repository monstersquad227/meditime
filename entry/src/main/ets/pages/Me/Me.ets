import { promptAction, router } from "@kit.ArkUI";
import { authentication } from "@kit.AccountKit";
import { util } from '@kit.ArkTS';
import { hilog } from "@kit.PerformanceAnalysisKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { dealAllError } from "../../common/function/error";
import { common, Want } from "@kit.AbilityKit";
import { openBrowser } from "../../common/function/openBrowser";
import { HuaweiAccountUserAuthenticationProtocolAddress, QuestionnaireAddress } from "../../common/constant/constant";


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
                // const authorizationCode = authorizationWithHuaweiIDCredential?.authorizationCode;
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
        Column({ space: '40.00vp' }) {
            Image(this.avatarUri ? this.avatarUri : $r('app.media.circle'))
                .border({ radius: 50 })
                .width('80')
                .height('80')
                .margin({
                    top: '100.00vp'
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
                    router.pushUrl({ url: 'pages/Me/faq/faq' })
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
                    // const context = this.getUIContext().getHostContext() as common.UIAbilityContext
                    // openBrowser(context, QuestionnaireAddress);
                    router.pushUrl({
                        url: 'pages/common/WebPage',
                        params: { url: QuestionnaireAddress, title: $r('app.string.Feedback') }
                    })
                })
            }
            .width('90%')
            .height('100.00vp')
            .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
            .backgroundColor('#f9f9f9')

        }.height('100%').width('100%')
    }
}