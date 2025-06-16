import { router } from "@kit.ArkUI";

@Component
@Entry
export struct punchCardProblem {
    private content: string = `
如您在使用过程中遇到打卡相关问题，应用目前支持以下功能：

    1. 撤销打卡：如不小心误打卡，可再次点击“撤销打卡”按钮进行取消操作。

    2. 打卡：若因遗忘错过打卡时间段，可继续进行打卡，并选择实际的服药时间。

    3. 日期选择打卡：仅支持当天打卡，不可进行提前打卡，但可查看历史打卡记录。

请根据实际情况合理使用上述功能，确保用药记录的准确性与完整性。
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