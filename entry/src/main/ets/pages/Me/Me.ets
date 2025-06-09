import { router } from "@kit.ArkUI";

@Component
export struct Me {
    @StorageProp('nickname') nickname: string = AppStorage.get('nickname') ?? '默认昵称';

    build() {
        Column({ space: '20.00vp' }) {
            Image($r('app.media.circle'))
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