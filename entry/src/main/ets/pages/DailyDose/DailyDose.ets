import { ListPlanV2 } from '../../common/function/medicinePlan';
import { ListPlanData } from '../../common/interface/medicinePlan';
import { listIterm } from './listIterm/listIterm';
import { router } from '@kit.ArkUI';
import { getDate } from '../../common/function/date';
import { CalendarComponent } from './CalendarComponent/CalendarComponent';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { pushService } from '@kit.PushKit';

@Component
export struct DailyDose {
    // @State selectedDate: string = getDate();
    @StorageProp('selectedDate') selectedDate: string | undefined = AppStorage.get('selectedDate');
    @StorageProp('selectedDay') selectedDay: number = AppStorage.get('selectedDay') ?? new Date().getDate();
    @State isRefreshing: boolean = false;
    @State planData: ListPlanData[] = [];
    @Prop @Watch('refreshFlagUpdate') refreshFlag: number = 0;

    async refreshFlagUpdate() {
        this.refreshPlanData()
    }

    async refreshPlanData() {
        // promptAction.showToast({ message: this.selectedDate })
        // this.planData = await ListPlan()
        // AlertDialog.show({ message: this.selectedDate })
        this.planData = await ListPlanV2(this.selectedDate ?? getDate())
    }

    async aboutToAppear(): Promise<void> {
        this.refreshPlanData();
        this.requestEnableNotification();
    };

    build() {
        Column() {
            Refresh({
                refreshing: this.isRefreshing,
                promptText: '刷新中......'
            }) {
                Column() {
                    CalendarComponent({
                        // selectedDate: this.selectedDate,
                        selectedDay: this.selectedDay,
                        onUpdateDateWrapper: { callback: async () => await this.refreshPlanData() }
                    }).height('300.00vp').width('100%')
                    // CalendarComponentV2().height('300.00vp').width('100%')

                    if (this.planData.length > 0) {
                        List({ space: '10.00vp' }) {
                            ForEach(this.planData, (item: ListPlanData) => {
                                ListItem() {
                                    listIterm({
                                        record_id: item.record_id,
                                        is_checked: item.is_checked,
                                        plan_id: item.plan_id,
                                        medicine_name: item.medicine_name,
                                        amount: item.amount,
                                        type: item.type,
                                        plan_time: item.plan_time,
                                        medicine_timing: item.medicine_timing,
                                        onUpdateWrapper: { callback: async () => await this.refreshPlanData() }
                                    })
                                }
                                .width('90%')
                                .margin({ left: '5%', right: '5%' })
                                .border({ width: 1, color: '#cccccc', radius: 8 })
                            })
                        }.margin({ top: '50.00vp' }).layoutWeight(1).width('90%').height('')
                    } else if (this.isBeforeToday(this.selectedDate ?? '')) {
                    } else {
                        Column({ space: '20.00vp' }) {

                            Text('明日再来')
                                .fontSize('40.00vp')
                                .height('150.00vp')

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
                // this.planData = await ListPlan()
                this.refreshPlanData()
                setTimeout(() => {
                    this.isRefreshing = false
                }, 1000)
            })
        }.height('100%').width('100%')
    }

    private isBeforeToday(val: string): boolean {
        const inputDate = new Date(val)
        const today = new Date()
        today.setHours(0, 0, 0, 0)
        return inputDate < today
    }

    private async requestEnableNotification(): Promise<void> {
        try {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            await notificationManager.requestEnableNotification(context).then(async () => {
                const pushToken: string = await pushService.getToken();
                hilog.info(0x0000, 'pushToken', pushToken)
            })
            AlertDialog.show({ message: 'Succeeded in requesting enable notification' })
            // Logger.info('Succeeded in requesting enable notification');
        } catch (e) {
            const err: BusinessError = e;
            AlertDialog.show({ title: err.code.toString(), message: err.message })
            // Logger.error('Failed to request enable notification: %{public}d %{public}s', err.code, err.message);
        }
    }
}