import { translateMedicineTime } from "../../../common/function/medicineCourse";
import { recordUpdate } from "../../../common/function/medicinePlanRecord";
import { recordPutData } from "../../../common/interface/medicinePlanRecord";

interface GeneratedTypeLiteralInterface_1 {
    callback: () => void;
}

@Component
export struct listIterm {
    @Prop medicine_name: string = '';
    @Prop amount: number = 0;
    @Prop type: string = '';
    @Prop plan_time: string = '';
    @Prop medicine_timing: number = 0;
    @Prop plan_id: number = 0
    @Prop is_checked: number = 0
    @Prop onUpdateWrapper: GeneratedTypeLiteralInterface_1 = {
        callback: () => {
        }
    };

    private generateActualTime(): string {
        let date = new Date()
        let yearStr = date.getFullYear().toString()
        let year = String(yearStr).padStart(2, '0')
        let monthStr = date.getMonth() + 1
        let month = String(monthStr.toString()).padStart(2, '0')
        let dayStr = date.getDate()
        let day = String(dayStr.toString()).padStart(2, '0')
        let hourStr = date.getHours().toString()
        let hour = String(hourStr).padStart(2, '0')

        let minuteStr = date.getMinutes().toString()
        let minute = String(minuteStr).padStart(2, '0')
        return `${year}-${month}-${day} ${hour}:${minute}:00`
    }

    build() {
        Column() {
            Row() {
                Column({ space: '20.00vp' }) {
                    Text(this.medicine_name + ' ' + this.amount + ' ' + this.type)
                        .fontWeight(FontWeight.Bold)
                        .alignSelf(ItemAlign.Start)
                    Text(this.plan_time + ' ' + translateMedicineTime(this.medicine_timing))
                        .alignSelf(ItemAlign.Start)
                }
                .padding(10)

                Blank().layoutWeight(1)

                Button(this.is_checked === 0 ? '打卡' :
                    '撤销打卡')
                    .width('90.00vp')
                    .height('60.00vp')
                    .backgroundColor(this.is_checked === 0 ? null : Color.Grey)
                    .type(ButtonType.Normal)
                    .border({ radius: '16.00vp' })
                    .onClick(async () => {
                        let body: recordPutData = {
                            plan_id: this.plan_id,
                            is_checked: this.is_checked === 0 ? 1 : 0,
                            actual_time: this.generateActualTime(),
                        }
                        await recordUpdate(body)

                        this.onUpdateWrapper.callback()
                        // AlertDialog.show({ title: 'body', message: JSON.stringify(body) })
                        // CreatePlan(body)
                    })
                    .margin({ right: '20.00vp' })
            }
        }
    }
}