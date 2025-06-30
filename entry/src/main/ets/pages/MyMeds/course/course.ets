import { promptAction, router } from '@kit.ArkUI';
import { CreateCourse } from '../../../common/function/medicineCourse';
import { CreateCourseData } from '../../../common/interface/medicineCourse';

@Preview
@Component
@Entry
struct course {
    @State selectedDate: Date = new Date()
    @State medicineName: string = '';
    @State medicineType: number = 0;
    @State medicineTiming: number = 0;
    @State courseStartTime: string =
        this.selectedDate.getFullYear().toString() + '-' + this.selectedDate.getMonth().toString() + '-' +
        this.selectedDate.getDay().toString();
    @State courseStartTimes: string[] = [];
    @State amount: number = 0;
    @State type: string = '粒';
    @State frequency: number = 1;
    private selectTime: Date = new Date('2020-12-25T08:30:00')

    build() {
        Column({ space: '20.00vp' }) {
            // 返回图标
            Image($r('app.media.right_grey'))
                .width('16.00vp')
                .height('16.00vp')
                .rotate({ angle: 180 })
                .onClick(() => {
                    router.back()
                })
                .alignSelf(ItemAlign.Start)
                .margin({ left: '20.00vp', top: '20.00vp', })

            List({ space: '20.00vp' }) {
                // 药物名称
                ListItem() {
                    Row() {
                        Column({ space: '20.00vp' }) {
                            Text('药物名称')
                                .margin({ left: '10.00vp' })
                                .alignSelf(ItemAlign.Start)
                                .fontWeight(FontWeight.Bold)

                            TextInput({ placeholder: '请输入药物名称', text: this.medicineName })
                                .alignSelf(ItemAlign.Start)
                                .height('30.00vp')
                                .border({ radius: 0 })
                                .backgroundColor(Color.White)
                                .onChange((value: string) => {
                                    this.medicineName = value
                                })
                                .padding({
                                    top: '0.00vp',
                                    right: '10.00vp',
                                    bottom: '0.00vp',
                                    left: '10.00vp'
                                })
                        }
                        .margin({ top: '20.00vp', bottom: '20.00vp' })
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
                                .margin({ left: '10.00vp' })
                                .alignSelf(ItemAlign.Start)
                                .fontWeight(FontWeight.Bold)

                            Row() {
                                Text('每日')
                                    .width('15%')
                                Blank().width('50%')
                                Row() {
                                    TextInput()
                                        .type(InputType.Number)
                                        .width('50%')
                                        .fontSize(13)
                                        .borderRadius(8)
                                        .onChange((value: string) => {
                                            let num = parseInt(value)
                                            if (isNaN(num)) {
                                                num = 1
                                                this.frequency = 1
                                            }
                                            this.frequency = num
                                        })
                                    Blank().width('5%')
                                    Text('次')
                                }
                                .justifyContent(FlexAlign.SpaceBetween)
                                .height('40.00vp')
                                .width('35%')
                            }
                            .margin({ left: '10.00vp', right: '10.00vp' })


                            Row() {
                                Text('每次')
                                    .width('15%')
                                // Blank().width('50%')
                                Blank().layoutWeight(1)
                                Row() {
                                    TextInput()
                                        .type(InputType.Number)
                                        .fontSize(13)
                                        .width('50%')
                                        .borderRadius(8)
                                        .onChange((value: string) => {
                                            this.amount = parseInt(value)
                                        })
                                    // Blank().width('5%')
                                    Blank().layoutWeight(1)
                                    TextInput({ text: this.type })
                                        .borderRadius(8)
                                        .onChange((value: string) => {
                                            this.type = value
                                        })
                                        .width('45%')
                                }
                                .justifyContent(FlexAlign.SpaceBetween)
                                .height(40)
                                .width('35%')
                            }
                            .margin({ left: '10.00vp', right: '10.00vp' })
                        }
                        .margin({ top: '20.00vp', bottom: '20.00vp' })
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
                                .margin({ left: '10.00vp' })
                                .alignSelf(ItemAlign.Start)
                                .fontWeight(FontWeight.Bold)

                            ForEach(new Array(this.frequency).fill(0).map((_: number, index: number) => index),
                                (index: number) => {
                                    Row() {
                                        Text('时间')
                                            .width('15%')
                                        Blank().width('35%')
                                        Button(this.courseStartTimes[index] === '' ? '选择时间' :
                                        this.courseStartTimes[index])
                                            .width('50%')
                                            .fontSize('13.00vp')
                                            .fontColor(Color.Black)
                                            .type(ButtonType.Normal)
                                            .borderRadius(8)
                                            .backgroundColor('#F2F2F2')
                                            .onClick(() => {
                                                this.getUIContext().showTimePickerDialog({
                                                    useMilitaryTime: true,
                                                    selected: this.selectTime,
                                                    onAccept: (value: TimePickerResult) => {
                                                        if (value.hour != undefined && value.minute != undefined) {
                                                            this.selectTime.setHours(value.hour, value.minute)
                                                        }
                                                        const hourStr = String(value.hour).padStart(2, '0');
                                                        const minuteStr = String(value.minute).padStart(2, '0');
                                                        this.courseStartTimes[index] = `${hourStr}:${minuteStr}`;
                                                    }
                                                })
                                            })
                                    }.margin({ left: '10.00vp', right: '10.00vp' })

                                })

                        }
                        .margin({ top: '20.00vp', bottom: '20.00vp' })
                    }
                    .width('90%')
                    .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
                    .margin({ left: '5%', right: '5%' })
                }

                // 补充信息
                ListItem() {
                    Row() {
                        Column({ space: '20.00vp' }) {
                            Text('补充信息')
                                .margin({ left: '10.00vp' })
                                .alignSelf(ItemAlign.Start)
                                .fontWeight(FontWeight.Bold)

                            Row() {
                                Text('用药方式').width('25%')
                                // 空格填充
                                Blank().width('30%')
                                // 内服
                                Row() {
                                    Text('内服')
                                    Radio({ group: 'medicineType', value: '0', })
                                        .onChange((value) => {
                                            if (value === true) {
                                                this.medicineType = 0
                                            }
                                        })
                                }
                                .justifyContent(FlexAlign.SpaceBetween)
                                .width('20%')

                                // 空格填充
                                Blank().width('5%')
                                // 外服
                                Row() {
                                    Text('外服')
                                    Radio({ group: 'medicineType', value: '1' })
                                        .onChange((value) => {
                                            if (value === true) {
                                                this.medicineType = 1
                                            }
                                        })
                                }
                                .justifyContent(FlexAlign.SpaceBetween)
                                .width('20%')
                            }
                            .margin({ left: '10.00vp', right: '10.00vp' })

                            // 用药时机
                            Row() {
                                Text('用药时机')
                                    .width('25%')
                                Blank().width('35%')
                                Select([
                                    { value: '不限' },
                                    { value: '饭前用药' },
                                    { value: '饭后用药' },
                                    { value: '随餐用药' },
                                    { value: '睡前用药' }
                                ])
                                    .onSelect((index: number) => {
                                        this.medicineTiming = index
                                    })
                                    .width('40%')
                                    .borderRadius(8)
                            }
                            .margin({ left: '10.00vp', right: '10.00vp' })
                        }
                        .margin({ top: '20.00vp', bottom: '20.00vp' })
                    }
                    .width("90%")
                    .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
                    .margin({ left: '5%', right: '5%' })
                }

                // 保存按钮
                ListItem() {
                    Button('保存')
                        .width('100%')
                        .type(ButtonType.Normal)
                        .border({ radius: 8 })
                        .onClick(() => {
                            const data: CreateCourseData = {
                                user_id: Number(AppStorage.get('user_id')),
                                medicine_name: this.medicineName,
                                medicine_image: '',
                                medicine_type: this.medicineType,
                                medicine_timing: this.medicineTiming,
                                course_start_time: this.generateCourseStartTime(),
                                course_start_times: this.courseStartTimes,
                                status: 0,
                                amount: this.amount,
                                type: this.type,
                                plan_time: this.generateTime(this.courseStartTime),
                                frequency: this.frequency
                            }
                            CreateCourse(data)
                            router.back()
                        })
                }
                .margin({ left: '5%', right: '5%' })
            }.margin({ bottom: '100.00vp' })
        }
        .height('100%').width('100%')
    }

    private generateCourseStartTime(): string {
        let yearStr = this.selectedDate.getFullYear().toString()
        let year = String(yearStr).padStart(2, '0')
        let monthStr = (this.selectedDate.getMonth() + 1).toString()
        let month = String(monthStr).padStart(2, '0')
        let dayStr = this.selectedDate.getDate().toString()
        let day = String(dayStr).padStart(2, '0')
        let time = this.courseStartTimes[0]
        return `${year}-${month}-${day} ${time}`
    }

    private generateTime(date: string): string {
        let time = date.split(' ')
        if (time.length !== 2) {
            return '';
        }
        let timePart = time[1];
        let timeParts = timePart.split(':');
        if (timeParts.length < 2) {
            return '';
        }
        return `${timeParts[0]}:${timeParts[1]}`;
    }
}