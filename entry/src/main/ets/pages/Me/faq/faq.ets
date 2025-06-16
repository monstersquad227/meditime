import { router } from '@kit.ArkUI'

@Entry
@Component
struct faq {
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
                    Text('?').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text('关于本APP')
                    Blank().layoutWeight(1)
                    Image($r('app.media.right_grey')).width('16.00vp').height('16.00vp').margin({ right: '10.00vp' })
                }
                .onClick(() => {
                    router.pushUrl({ url: 'pages/Me/faq/aboutApp' })
                })
                .width('90%')
                .height('50.00vp')
                .border({ width: { bottom: '1.00vp' }, color: '#cccccc', radius: { topLeft: 8, topRight: 8 } })
                .backgroundColor('#f9f9f9')

                Row() {
                    Text('?').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text('如何与APP作者交流')
                    Blank().layoutWeight(1)
                    Image($r('app.media.right_grey')).width('16.00vp').height('16.00vp').margin({ right: '10.00vp' })
                }
                .onClick(() => {
                    router.pushUrl({ url: 'pages/Me/faq/authorCommunicate' })
                })
                .width('90%')
                .height('50.00vp')
                .border({ width: { bottom: '1.00vp' }, color: '#cccccc' })
                .backgroundColor('#f9f9f9')

                Row() {
                    Text('?').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text('个人信息如何修改')
                    Blank().layoutWeight(1)
                    Image($r('app.media.right_grey')).width('16.00vp').height('16.00vp').margin({ right: '10.00vp' })
                }
                .onClick(() => {
                    router.pushUrl({ url: 'pages/Me/faq/modifyPersonalInfomation' })
                })
                .width('90%')
                .height('50.00vp')
                .border({ width: { bottom: '1.00vp' }, color: '#cccccc' })
                .backgroundColor('#f9f9f9')

                Row() {
                    Text('?').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text('打卡问题')
                    Blank().layoutWeight(1)
                    Image($r('app.media.right_grey')).width('16.00vp').height('16.00vp').margin({ right: '10.00vp' })
                }
                .onClick(() => {
                    router.pushUrl({ url: 'pages/Me/faq/punchCardProblem' })
                })
                .width('90%')
                .height('50.00vp')
                .border({ color: '#cccccc', radius: { bottomLeft: 8, bottomRight: 8 } })
                .backgroundColor('#f9f9f9')
            }
            .margin({ top: '20.00vp' })
        }
        .height('100%')
        .width('100%')
    }
}