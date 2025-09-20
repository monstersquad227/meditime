import { router } from '@kit.ArkUI'
import { translateMedicineTime, UpdateCourse } from '../../../common/function/medicineCourse';
import { UpdateCourseData } from '../../../common/interface/medicineCourse';
import json from '@ohos.util.json';
import { JSON } from '@kit.ArkTS';
import { CalendarUtils } from '../../../common/function/date';

interface params {
    type: string;
    medicine_name: string
    frequency: number
    plat_times: string
    medicine_type: number
    medicine_timing: number
    amount: number
    course_id: number
}

@Component
@Entry
struct updateCourse {
    @State medicine_name: string = '';
    @State frequency: number = 0;
    @State type: string = '';
    @State plat_times: string = '';
    @State courseStartTime: Array<string> = [];
    @State medicine_type: number = 0;
    @State medicine_timing: number = 0;
    @State amount: number = 0;
    @State course_id: number = 0;
    private selectTime: Date = new Date('2020-12-25T08:30:00')

    aboutToAppear() {
        const params = router.getParams() as params;
        this.medicine_name = params?.medicine_name;
        this.frequency = params?.frequency;
        this.type = params?.type;
        this.plat_times = params?.plat_times;
        this.courseStartTime = this.plat_times.split(',');
        this.medicine_type = params?.medicine_type;
        this.medicine_timing = params?.medicine_timing;
        this.amount = params?.amount;
        this.course_id = params?.course_id;
    }

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

            List({ space: '20.00vp' }) {
                // 药物名称
                ListItem() {
                    Row() {
                        Column({ space: '20.00vp' }) {
                            Text('药物名称')
                                .alignSelf(ItemAlign.Start)
                                .fontWeight(FontWeight.Bold)
                            TextInput({
                                placeholder: '请输入药物名称',
                                text: this.medicine_name
                            }).alignSelf(ItemAlign.Start).width('100%')
                                .border({ radius: 0 })// .backgroundColor(Color.White)
                                .onChange((value: string) => {
                                    this.medicine_name = value
                                })
                        }
                        .padding(10)
                    }
                    .width('90%')
                    .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
                    .margin({ left: '5%', right: '5%' })
                }

                // 药物用量
                ListItem() {
                    Row() {
                        Column({ space: '20.00vp' }) {
                            Text('药物用量')
                                .alignSelf(ItemAlign.Start)
                                .fontWeight(FontWeight.Bold)

                            Row() {
                                Text('每日')
                                Blank().layoutWeight(1)
                                TextInput({ text: String(this.frequency) }).width('25%').border({ radius: 8 })
                                    .onChange((val: string) => {
                                        const newFreq = parseInt(val);
                                        if (!isNaN(newFreq)) {
                                            this.frequency = newFreq;
                                            const diff = newFreq - this.courseStartTime.length;
                                            if (diff > 0) {
                                                this.courseStartTime =
                                                    [...this.courseStartTime, ...Array(diff).fill('')];
                                            } else if (diff < 0) {
                                                this.courseStartTime = this.courseStartTime.slice(0, newFreq);
                                            }
                                        }
                                    }).textAlign(TextAlign.Center)
                                Text('次').margin({ left: '10.00vp' }).width('25%').textAlign(TextAlign.Center)
                            }

                            Row() {
                                Text('每次')
                                Blank().layoutWeight(1)
                                TextInput({ text: String(this.amount) }).width('25%').border({ radius: 8 })
                                    .textAlign(TextAlign.Center)
                                TextInput({ text: String(this.type) }).width('25%').border({ radius: 8 })
                                    .margin({ left: '10.00vp' }).textAlign(TextAlign.Center)
                            }
                        }
                        .padding(10)
                    }
                    .width('90%')
                    .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
                    .margin({ left: '5%', right: '5%' })
                }

                // 用药时间
                ListItem() {
                    Row() {
                        Column({ space: '20.00vp' }) {
                            Text('用药时间')
                                .alignSelf(ItemAlign.Start)
                                .fontWeight(FontWeight.Bold)
                            ForEach(this.courseStartTime, (time: string, index: number) => {
                                Row() {
                                    Text('时间')
                                    Blank().layoutWeight(1)
                                    Button(time === '' ? '请选择时间' : time)
                                        .width('50%')
                                        .borderRadius(8)
                                        .type(ButtonType.Normal)
                                        .fontColor(Color.Black)
                                        .backgroundColor('#F2F2F2')
                                        .onClick(() => {
                                            this.getUIContext().showTimePickerDialog({
                                                useMilitaryTime: true,
                                                selected: this.selectTime,
                                                onAccept: (value: TimePickerResult) => {
                                                    const hourStr = String(value.hour).padStart(2, '0');
                                                    const minuteStr = String(value.minute).padStart(2, '0');
                                                    this.courseStartTime[index] = `${hourStr}:${minuteStr}`;
                                                }
                                            })
                                        })
                                }
                            })
                        }
                        .padding(10)
                    }
                    .width('90%')
                    .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
                    .margin({ left: '5%', right: '5%' })
                }

                // 补充信息
                ListItem() {
                    Row() {
                        Column({ space: '20.00vp' }) {
                            Text('补充信息').alignSelf(ItemAlign.Start).fontWeight(FontWeight.Bold)
                            Row() {
                                Text('用药方式')
                                Blank().layoutWeight(1)
                                Row({ space: '10.00vp' }) {
                                    Row() {
                                        Text('内服')
                                        Radio({ group: 'medicineType', value: '0', }).checked(this.medicine_type === 0)
                                    }

                                    Row() {
                                        Text('外服')
                                        Radio({ group: 'medicineType', value: '1', }).checked(this.medicine_type === 1)
                                    }
                                }

                            }

                            Row() {
                                Text('用药时机')
                                Blank().layoutWeight(1)
                                Select([
                                    { value: '不限' },
                                    { value: '饭前用药' },
                                    { value: '饭后用药' },
                                    { value: '随餐用药' },
                                    { value: '睡前用药' }
                                ]).width('50%').borderRadius(8)
                                    .onSelect((index: number) => {
                                        this.medicine_timing = index
                                    })
                                    .value(translateMedicineTime(this.medicine_timing))
                            }
                        }
                        .padding(10)
                    }
                    .width('90%')
                    .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
                    .margin({ left: '5%', right: '5%' })
                }

                // 保存按钮
                ListItem() {
                    Row() {
                        Button('保存').width('100%').onClick(() => {
                            const body: UpdateCourseData = {
                                course_id: this.course_id,
                                user_id: Number(AppStorage.get('user_id')),
                                medicine_name: this.medicine_name,
                                medicine_type: this.medicine_type,
                                medicine_timing: this.medicine_timing,
                                course_start_time: CalendarUtils.getYear() + '-' + CalendarUtils.getMonth() + '-' +
                                CalendarUtils.getDay() + ' ' + this.courseStartTime[0],
                                course_start_times: this.courseStartTime,
                                amount: this.amount,
                                type: this.type,
                                plan_time: this.plat_times,
                                frequency: this.frequency
                            }
                            // AlertDialog.show({ message: JSON.stringify(body) })
                            UpdateCourse(body)
                            router.back()
                        })
                    }.margin({ left: '5%', right: '5%' })
                }
            }.height('90%').width('100%').margin({ top: '20.00vp', bottom: '50.00vp' })
        }.height('100%').width('100%')
    }
}