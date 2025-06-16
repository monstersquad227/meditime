import { router } from "@kit.ArkUI";

@Component
@Entry
export struct modifyPersonalInfomation {
    private content: string = `
当前暂不支持在 App 内直接修改个人信息。若需修改姓名、头像等资料，请前往“华为账号”进行更改，修改后系统将自动同步更新，感谢您的理解与支持。

`;

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