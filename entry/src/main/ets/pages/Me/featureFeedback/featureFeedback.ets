import { router } from '@kit.ArkUI'

@Entry
@Component
struct featureFeedback {
    build() {
        Column() {
            Image($r('app.media.right_grey'))
                .width(16)
                .height(16)
                .rotate({ angle: 180 })
                .onClick(() => {
                    router.back()
                })
                .alignSelf(ItemAlign.Start)
                .margin({ left: 20, top: 20 })
            Text('干中学')
                .margin({ top: '50%' })
        }
        .height('100%')
        .width('100%')
    }
}