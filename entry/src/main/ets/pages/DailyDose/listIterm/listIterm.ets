import { getDate } from "../../../common/function/date";
import { translateMedicineTime } from "../../../common/function/medicineCourse";
import { recordUpdate } from "../../../common/function/medicinePlanRecord";
import { recordPutData } from "../../../common/interface/medicinePlanRecord";

interface GeneratedTypeLiteralInterface_1 {
    callback: () => void;
}

@Component
export struct listIterm {
    @StorageProp('selectedDate') selectedDate: string = AppStorage.get('selectedDate') ?? getDate();
    @Prop medicine_name: string = '';
    @Prop amount: number = 0;
    @Prop type: string = '';
    @Prop plan_time: string = '';
    @Prop medicine_timing: number = 0;
    @Prop plan_id: number = 0
    @Prop is_checked: number = 0
    @Prop record_id: number = 0
    @Prop onUpdateWrapper: GeneratedTypeLiteralInterface_1 = {
        callback: () => {
        }
    };

    private generateActualTime(): string {
        let date = new Date()
        let hourStr = date.getHours().toString()
        let hour = String(hourStr).padStart(2, '0')
        let minuteStr = date.getMinutes().toString()
        let minute = String(minuteStr).padStart(2, '0')
        if (this.selectedDate === undefined) {
            this.selectedDate = getDate()
        }
        return this.selectedDate + ` ${hour}:${minute}`
    }

    build() {
        Column() {
            Row() {
                Column({ space: '10.00vp' }) {
                    Text(this.medicine_name + ' ' + this.amount + ' ' + this.type)
                        .fontWeight(FontWeight.Bold)
                        .alignSelf(ItemAlign.Start)
                        .fontSize('16.00vp')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .width('50%')
                    Text(this.plan_time + ' ' + translateMedicineTime(this.medicine_timing))
                        .alignSelf(ItemAlign.Start)
                        .fontSize('14.00vp')
                        .maxLines(1)
                }
                .padding(10)

                Blank().layoutWeight(1)

                Button(this.is_checked === 0 ? '打卡' :
                    '撤销打卡')
                    .width('30%')
                    .height('13%')
                    .backgroundColor(this.is_checked === 0 ? null : Color.Grey)
                    .onClick(() => {
                        let body: recordPutData = {
                            id: this.record_id,
                            plan_id: this.plan_id,
                            is_checked: this.is_checked === 0 ? 1 : 0,
                            actual_time: this.generateActualTime(),
                        }
                        AlertDialog.show({
                            message: '确定' + (this.is_checked === 0 ? '打卡' : '撤销打卡') + '吗？',
                            buttons: [{
                                value: '取消',
                                action: () => {
                                }
                            }, {
                                value: '确认',
                                action: async () => {
                                    await recordUpdate(body)
                                    this.onUpdateWrapper.callback()
                                }
                            }]
                        })
                        // await recordUpdate(body)
                        //

                        // AlertDialog.show({ title: 'body', message: JSON.stringify(body) })
                        // CreatePlan(body)
                    })
                    .margin({ right: '20.00vp' })
            }
        }
    }
}