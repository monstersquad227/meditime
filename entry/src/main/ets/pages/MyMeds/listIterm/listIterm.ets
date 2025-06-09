import { translateMedicineTime, translateType } from "../../../common/function/medicineCourse";

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