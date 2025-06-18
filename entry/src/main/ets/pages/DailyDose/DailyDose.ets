import { ListPlan } from '../../common/function/medicinePlan';
import { ListPlanData } from '../../common/interface/medicinePlan';
import { CalendarComponent } from './CalendarComponent/CalendarComponent'
import { listIterm } from './listIterm/listIterm';
import { router } from '@kit.ArkUI';

@Component
export struct DailyDose {
    @State isRefreshing: boolean = false;
    @State planData: ListPlanData[] = [];
    @Prop @Watch('refreshFlagUpdate') refreshFlag: number = 0

    async refreshFlagUpdate() {
        this.planData = await ListPlan()
    }

    async aboutToAppear(): Promise<void> {
        this.planData = await ListPlan()
    };

    build() {
        Column() {
            Refresh({
                refreshing: this.isRefreshing,
                promptText: '刷新中......'
            }) {
                Column() {
                    CalendarComponent()
                        .height('300.00vp')
                        .width('100%')

                    if (this.planData.length > 0) {
                        List({ space: '10.00vp' }) {
                            ForEach(this.planData, (item: ListPlanData) => {
                                ListItem() {
                                    listIterm({
                                        is_checked: item.is_checked,
                                        plan_id: item.plan_id,
                                        medicine_name: item.medicine_name,
                                        amount: item.amount,
                                        type: item.type,
                                        plan_time: item.plan_time,
                                        medicine_timing: item.medicine_timing
                                    })
                                }
                                .width('90%')
                                .margin({ left: '5%', right: '5%' })
                                .border({ width: 1, color: '#cccccc', radius: 8 })
                            })
                        }.margin({ top: '50.00vp' }).layoutWeight(1).width('90%').height('')
                    } else {
                        Column({ space: '20.00vp' }) {
                            Image($r('app.media.background'))
                                .width('80.00vp')
                                .height('80.00vp')

                            Text($r('app.string.NoNeedToPunchInToday'))

                            Button($r('app.string.AddMedicationRegimen'))
                                .width('70%')
                                .height('60')
                                .type(ButtonType.Normal)
                                .borderRadius(16)
                                .fontSize('16.00vp')
                                .onClick(() => {
                                    router.pushUrl({ url: 'pages/MyMeds/course/course' })
                                })
                        }.margin({ top: '50.00vp' })
                        .layoutWeight(1)
                    }
                }
            }
            .onStateChange(async () => {
                this.isRefreshing = true
                this.planData = await ListPlan()
                setTimeout(() => {
                    this.isRefreshing = false
                }, 1000)
            })
        }.height('100%').width('100%')
    }
}