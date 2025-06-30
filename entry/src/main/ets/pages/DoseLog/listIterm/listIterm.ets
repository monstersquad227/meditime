import { recordListDataContents } from "../../../common/interface/medicinePlanRecord"
import router from "@ohos.router"
import { AppStorageV2 } from "@kit.ArkUI"
import { dealAllError } from "../../../common/function/error"

@Component
export struct listIterm {
    @Prop date: string
    @Prop contents: recordListDataContents[]

    build() {
        Column() {
            Row() {
                Text(this.cuttingDate(this.date))
                    .fontSize('18.00vp')
                    .fontWeight(FontWeight.Medium)
                    .backgroundColor($r('app.media.background'))
                Image($r('app.media.right_grey'))
                    .width('16.00vp')
                    .height('16.00vp')
                    .onClick(() => {
                        let date = this.cuttingDate(this.date)
                        let dateDay = date.split('-')
                        try {
                            AppStorage.set('currentIndex', 0)
                            AppStorage.set('selectedDate', date)
                            AppStorage.setOrCreate('selectedDay', parseInt(dateDay[2]))
                        } catch (err) {
                            dealAllError(err)
                        }

                    })
            }
            .border({ width: 1, color: '#ff73a2f5', radius: { topLeft: '8.00vp', topRight: '8.00vp' } })
            .width('100%')
            .height('5%')
            .backgroundColor('#6498f1')
            .padding(5)
            .justifyContent(FlexAlign.SpaceBetween)

            ForEach(this.contents, (item: recordListDataContents) => {
                Row() {
                    Text(item.medicine_name)
                        .fontSize(14)
                        .fontColor('#888888')
                        .margin({ top: 4 })
                    Blank()
                    // Text(this.translateStatus(item.status))
                    Text(this.translateStatusAndIsChecked(item.status, item.is_checked))
                        .fontSize(14)// .fontColor(item.status === 1 ? '#FF0000' : '#0000FF')
                        .fontColor(this.translateStatusAndIsCheckedColor(item.status, item.is_checked))
                        .margin({ top: 4 })
                }
                .width('100%')
                .padding('10')
                .justifyContent(FlexAlign.SpaceBetween)
            })
        }
        .width('100%')
        .margin({ bottom: '15.00vp' })
    }

    private cuttingDate(date: string): string {
        let dateTimes = date.split(' ');
        if (dateTimes.length !== 2) {
            return date;
        }
        return dateTimes[0];
    }

    private translateStatus(value: number): string {
        if (value === 1) {
            return '异常'
        } else {
            return '正常'
        }
    }

    private translateStatusAndIsChecked(status: number, isChecked: number): string {
        if (isChecked === 1 && status === 0) {
            return '打卡正常'
        } else if (isChecked === 1 && status === 1) {
            return '打开时间异常'
        } else {
            return '未打卡'
        }
    }

    private translateStatusAndIsCheckedColor(status: number, isChecked: number): string {
        if (isChecked === 1 && status === 0) {
            return '#0000FF'
        } else if (isChecked === 1 && status === 1) {
            return '#FFC107'
        } else {
            return '#FF0000'
        }
    }
}