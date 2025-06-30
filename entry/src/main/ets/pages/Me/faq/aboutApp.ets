import { router } from "@kit.ArkUI";
import { AbilityConstant, UIAbility, Want } from "@kit.AbilityKit";
import { pushService } from "@kit.PushKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { hilog } from "@kit.PerformanceAnalysisKit";

@Component
@Entry
export struct aboutApp {
    private content: string = `
按时吃药💊是一款专为中老年人设计的用药管理 App，帮助用户轻松记录和提醒日常吃药，守护每一位用户的健康生活。

通过本应用，您可以：

    1.简单添加药品信息（名称、时间、剂量）
    2.设置贴心的吃药提醒，避免漏服
    3.随时查看用药记录，方便回顾与管理
    4.养成良好的用药习惯，长期呵护身体

界面简洁、操作便捷，即使不熟悉手机的长辈也能快速上手，是您和家人用药管理的好帮手。

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

                Button('PushToken')
                    .onClick(async () => {
                        const pushToken: string = await pushService.getToken();
                        hilog.info(0x0000, 'pushToken', pushToken)
                    })
            }

        }
    }
}