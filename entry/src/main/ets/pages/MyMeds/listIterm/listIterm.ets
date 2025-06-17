import { DeleteCourse, translateMedicineTime, translateType } from "../../../common/function/medicineCourse";
import { DeleteCourseData } from "../../../common/interface/medicineCourse";

@Component
export struct listIterm {
    @Prop medicine_name: string = '';
    @Prop frequency: number = 0;
    @Prop medicine_timing: number = 0;
    @Prop medicine_type: number = 0;
    @Prop course_start_time: string = '';

    build() {
        Column() {
            Row() {
                Column({ space: '20.00vp' }) {
                    Text(this.medicine_name)
                        .fontWeight(FontWeight.Bold)
                        .alignSelf(ItemAlign.Start)

                    Row() {
                        Text('每日 ' + this.frequency + ' 次, ' +
                        translateMedicineTime(this.medicine_timing))
                        Blank().layoutWeight(1)
                        Text(translateType(this.medicine_type))
                    }

                    Text(this.splitDate(this.course_start_time) + ' 开始')
                        .alignSelf(ItemAlign.Start)

                    Row() {
                        Button('修改方案')
                            .height('30.00vp')
                            .width('50%')
                            .backgroundColor(Color.Transparent)
                            .border({ width: 0 })
                            .fontColor(Color.Blue)
                            .onClick(() => {
                            })
                        Button('结束用药')
                            .height('30.00vp')
                            .width('50%')
                            .backgroundColor(Color.Transparent)
                            .border({ width: 0 })
                            .fontColor(Color.Blue)
                            .onClick(() => {
                                const data: DeleteCourseData = {
                                    medicine_name: this.medicine_name,
                                    user_id: Number(AppStorage.get('user_id'))
                                }
                                DeleteCourse(data)
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