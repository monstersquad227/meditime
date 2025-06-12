import { ListCourse } from "../../common/function/medicineCourse";
import { ListCourseData } from "../../common/interface/medicineCourse";
import { listIterm } from "./listIterm/listIterm";
import { router } from "@kit.ArkUI";

@Component
export struct MyMeds {
    @State isRefreshing: boolean = false;
    @State courseData: ListCourseData[] = [];

    async aboutToAppear(): Promise<void> {
        this.courseData = await ListCourse()
    }

    build() {
        Column() {
            Refresh({
                refreshing: this.isRefreshing,
                promptText: '刷新中......'
            }) {
                Column() {
                    if (this.courseData.length === 0) {
                        Column() {
                            Text('还没有用药方案哦')
                        }
                        .width('100%')
                        .height('90%')
                        .justifyContent(FlexAlign.Center)
                        .align(Alignment.Center)
                    } else {
                        List({ space: '20.00vp' }) {
                            ForEach(this.courseData, (item: ListCourseData) => {
                                ListItem() {
                                    listIterm({
                                        medicine_name: item.medicine_name,
                                        frequency: item.frequency,
                                        medicine_timing: item.medicine_timing,
                                        medicine_type: item.medicine_type,
                                        course_start_time: item.course_start_time
                                    })
                                }
                                .width('90%')
                                .margin({ left: '5%', right: '5%' })
                                .border({ width: 1, color: '#cccccc', radius: 8 })
                            })
                        }
                    }
                }
            }
            .layoutWeight(1)
            .onStateChange(async () => {
                this.isRefreshing = true
                this.courseData = await ListCourse()
                setTimeout(() => {
                    this.isRefreshing = false
                }, 1000)
            })

            Button($r('app.string.AddMedicationRegimen'))
                .width('90%')
                .height('50.00vp')
                .type(ButtonType.Normal)
                .borderRadius(16)
                .fontSize('16.00vp')
                .onClick(() => {
                    router.pushUrl({ url: 'pages/MyMeds/course/course' })
                })
        }
    }
}