import { promptAction, router } from '@kit.ArkUI'
import { translateMedicineTime } from '../../../common/function/medicineCourse';
import { listIterm } from '../../DailyDose/listIterm/listIterm';

interface params {
    type: string;
    medicine_name: string
    frequency: number
    plat_times: string
    medicine_type: number
    medicine_timing: number
    amount: number
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
                            }).alignSelf(ItemAlign.Start)
                                .width('100%')
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
                                TextInput({ text: String(this.frequency) }).width('40.00vp').border({ radius: 8 })
                                Text('次').margin({ left: '10.00vp' })
                            }

                            Row() {
                                Text('每次')
                                Blank().layoutWeight(1)
                                TextInput({ text: String(this.amount) }).width('40.00vp').border({ radius: 8 })
                                TextInput({ text: String(this.type) })
                                    .width('50.00vp')
                                    .border({ radius: 8 })
                                    .margin({ left: '10.00vp' })
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
                            ForEach(this.courseStartTime, (time: string, _: number) => {
                                Row() {
                                    Text('时间')
                                    Blank().layoutWeight(1)
                                    Button(time).fontColor(Color.Black).backgroundColor('#F2F2F2')
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
                                ])
                                    .value(translateMedicineTime(this.medicine_timing))
                            }
                        }
                        .padding(10)
                    }
                    .width('90%')
                    .border({ width: '1.00vp', color: '#cccccc', radius: 8 })
                    .margin({ left: '5%', right: '5%' })
                }

                ListItem() {
                    Row() {
                        Button('保存').width('100%')
                    }.margin({ left: '5%', right: '5%' })
                }
            }
            .margin({ top: '20.00vp', bottom: '100.00vp' })
        }
    }
}