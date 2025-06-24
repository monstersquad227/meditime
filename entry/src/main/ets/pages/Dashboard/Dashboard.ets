import { DailyDose } from '../DailyDose/DailyDose';
import { DoseLog } from '../DoseLog/DoseLog';
import { Me } from '../Me/Me';
import { MyMeds } from '../MyMeds/MyMeds';
import { promptAction } from '@kit.ArkUI';
import { CalendarUtils, getDate } from '../../common/function/date';

@Entry
@Component
@Preview
struct Dashboard {
    // @State currentIndex: number = 0;
    @StorageProp('currentIndex') currentIndex: number = AppStorage.get('currentIndex') ?? 0;
    @State DailyDoseRefreshFlag: number = 0;

    @Builder
    dashboardBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
        Column() {
            Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
                .width('24.00vp')
                .height('24.00vp')
            Text(title)
                .fontFamily('HarmonyHeiTi-Medium')
                .fontSize('10.00vp')
                .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : 'rgba(0,0,0,0.60)')
                .textAlign(TextAlign.Center)
                .lineHeight('14.00vp')
                .fontWeight('500.00vp')
        }
        .width('100%')
        .height('50.00vp')
        .justifyContent(FlexAlign.Center)
    }

    build() {
        Tabs({ index: this.currentIndex, barPosition: BarPosition.End }) {
            TabContent() {
                DailyDose({ refreshFlag: this.DailyDoseRefreshFlag })
            }
            .tabBar(this.dashboardBuilder("吃药打卡", 0, $r('app.media.tab1Icon'), $r('app.media.tab1Icon')))

            TabContent() {
                MyMeds({ refreshFlag: this.DailyDoseRefreshFlag })
            }
            .tabBar(this.dashboardBuilder('我的用药', 1, $r('app.media.tab1Icon'), $r('app.media.tab1Icon')))

            TabContent() {
                DoseLog({ refreshFlag: this.DailyDoseRefreshFlag })
            }
            .tabBar(this.dashboardBuilder('用药记录', 2, $r('app.media.tab1Icon'), $r('app.media.tab1Icon')))

            TabContent() {
                Me()
            }
            .tabBar(this.dashboardBuilder('我的', 3, $r('app.media.tab1Icon'), $r('app.media.tab1Icon')))

        }
        .scrollable(false)
        .onChange((val) => {
            this.currentIndex = val
            // AppStorage.setOrCreate('selectedDay', new Date().getDate())
            AppStorage.setOrCreate('currentIndex', val)
            // AppStorage.setOrCreate('selectedDate', CalendarUtils.getToday())
            // 刷新flag
            this.DailyDoseRefreshFlag++
            // if (val === 0) {
            //     this.DailyDoseRefreshFlag++
            // } else if (val === 1) {
            //     this.DailyDoseRefreshFlag++
            // } else if (val === 2) {
            //     this.DailyDoseRefreshFlag++
            // } else if (val === 3) {
            //     this.DailyDoseRefreshFlag++
            // }
        })
    }
}