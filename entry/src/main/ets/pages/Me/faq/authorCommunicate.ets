import { router } from "@kit.ArkUI";

@Component
@Entry
export struct authorCommunicate {
    private content: string = `
如您有任何意见或建议，欢迎通过“功能反馈”页面留言，
您也可以直接联系我们：

    邮箱：15056332824@163.com
    电话/微信：15056332824（微信同号）

感谢您的支持与关注！`;

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
                .margin({ left: '20.00vp', top: '20.00vp', bottom: '20.00vp' })

            Column() {
                Text(this.content)
                    .fontSize(16)
                    .lineHeight(24)
                    .padding({ left: '10.00vp', right: '10.00vp' })
            }

        }
    }
}