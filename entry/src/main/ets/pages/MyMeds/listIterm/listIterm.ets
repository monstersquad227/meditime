import { DeleteCourse, translateMedicineTime, translateType } from "../../../common/function/medicineCourse";
import { DeleteCourseData } from "../../../common/interface/medicineCourse";
import { router } from "@kit.ArkUI";

interface GeneratedTypeLiteralInterface_1 {
    callback: () => void;
}

@Component
export struct listIterm {
    @Prop medicine_name: string = '';
    @Prop frequency: number = 0;
    @Prop medicine_timing: number = 0;
    @Prop medicine_type: number = 0;
    @Prop course_start_time: string = '';
    @Prop plat_times: string = '';
    @Prop type: string = '';
    @Prop amount: number = 0;
    @Prop course_id: number = 0;
    @Prop onDeletedWrapper: GeneratedTypeLiteralInterface_1 = {
        callback: () => {
        }
    };

    build() {
        Column() {
            Row() {
                Column({ space: '10.00vp' }) {
                    Text(this.medicine_name)
                        .fontSize('16.00vp')
                        .fontWeight(FontWeight.Bold)
                        .alignSelf(ItemAlign.Start)

                    Row() {
                        Text('每日 ' + this.frequency + ' 次, ' +
                        translateMedicineTime(this.medicine_timing)).fontSize('14.00vp')
                        Blank().layoutWeight(1)
                        Text(translateType(this.medicine_type)).fontSize('14.00vp')
                    }

                    Text(this.splitDate(this.course_start_time) + ' 开始')
                        .alignSelf(ItemAlign.Start).fontSize('14.00vp')

                    Row() {
                        Button('修改方案')
                            .height('30.00vp')
                            .width('50%')
                            .backgroundColor(Color.Transparent)
                            .border({ width: 0 })
                            .fontColor(Color.Blue)
                            .onClick(() => {
                                router.pushUrl({
                                    url: 'pages/MyMeds/course/updateCourse',
                                    params: {
                                        medicine_name: this.medicine_name,
                                        frequency: this.frequency,
                                        type: this.type,
                                        plat_times: this.plat_times,
                                        medicine_timing: this.medicine_timing,
                                        medicine_type: this.medicine_type,
                                        amount: this.amount,
                                        course_id: this.course_id,
                                    }
                                })
                            })
                        Button('结束用药')
                            .height('30.00vp')
                            .width('50%')
                            .backgroundColor(Color.Transparent)
                            .border({ width: 0 })
                            .fontColor(Color.Blue)
                            .onClick(async () => {
                                const data: DeleteCourseData = {
                                    medicine_name: this.medicine_name,
                                    user_id: Number(AppStorage.get('user_id'))
                                }
                                DeleteCourse(data)

                                this.onDeletedWrapper.callback()
                            })
                    }
                }
            }
            .padding(10)
        }
    }

    private splitDate(date: string): string {
        let sDate = date.split(' ');
        if (sDate.length !== 2) {
            return '0000-00-00'
        }
        return sDate[0];
    }
}