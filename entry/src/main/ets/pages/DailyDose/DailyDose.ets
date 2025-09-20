import { ListPlanV2 } from '../../common/function/medicinePlan';
import { ListPlanData } from '../../common/interface/medicinePlan';
import { listIterm } from './listIterm/listIterm';
import { router } from '@kit.ArkUI';
import { getDate } from '../../common/function/date';
import { CalendarComponent } from './CalendarComponent/CalendarComponent';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { pushService } from '@kit.PushKit';
import { updatePushToken } from '../../common/function/medicineUserPushToken';
import { UpdatePushTokenData } from '../../common/interface/medicineUser';

@Component
export struct DailyDose {
    @StorageProp('selectedDate') selectedDate: string | undefined = AppStorage.get('selectedDate');
    @StorageProp('selectedDay') selectedDay: number = AppStorage.get('selectedDay') ?? new Date().getDate();
    @State isRefreshing: boolean = false;
    @State planData: ListPlanData[] = [];
    @Prop @Watch('refreshFlagUpdate') refreshFlag: number = 0;

    async refreshFlagUpdate() {
        this.refreshPlanData()
    }

    async refreshPlanData() {
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
                        selectedDay: this.selectedDay,
                        onUpdateDateWrapper: { callback: async () => await this.refreshPlanData() }
                    }).height('300.00vp').width('100%')

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
                    } else if (this.isCurrentToday(this.selectedDate)) {
                        Column({ space: '20.00vp' }) {
                            Button($r('app.string.AddMedicationRegimen'))
                                .width('70%')
                                .height('60')
                                .type(ButtonType.Normal)
                                .borderRadius(16)
                                .fontSize('16.00vp')
                                .onClick(() => {
                                    router.pushUrl({ url: 'pages/MyMeds/course/course' })
                                })
                        }.margin({ top: '250.00vp' })
                        .layoutWeight(1)
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
                this.refreshPlanData()
                setTimeout(() => {
                    this.isRefreshing = false
                }, 1000)
            })
        }.height('100%').width('100%')
    }

    private isBeforeToday(val: string): boolean {
        if (val === undefined) {
            return true
        }
        const inputDate = new Date(val)
        const today = new Date()
        today.setHours(0, 0, 0, 0)
        return inputDate < today
    }

    private isCurrentToday(val: string | undefined): boolean {
        if (val === undefined) {
            return true
        }
        const inputDate = new Date(val)
        const today = new Date()
        inputDate.setHours(0, 0, 0, 0);
        today.setHours(0, 0, 0, 0);
        return inputDate.getTime() === today.getTime();
    }

    private async requestEnableNotification(): Promise<void> {
        let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        try {
            await notificationManager.requestEnableNotification(context).then(async () => {
                const pushToken: string = await pushService.getToken();
                const data: UpdatePushTokenData = {
                    push_token: pushToken
                }
                updatePushToken(data)
                hilog.info(0x0000, 'pushToken', pushToken)
            })

        } catch (e) {
            AlertDialog.show({
                title: '通知权限未开启',
                message: '为了接收服药提醒，请前往设置打开通知权限。',
                primaryButton: {
                    value: '前往设置',
                    action: () => {
                        notificationManager.openNotificationSettings(context);
                    }
                },
                secondaryButton: {
                    value: '取消',
                    action: () => {
                    }
                }
            })
        }
    }
}