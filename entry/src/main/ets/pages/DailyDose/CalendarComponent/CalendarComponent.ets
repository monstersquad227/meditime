import { getDate } from "../../../common/function/date";

interface todayInterface {
    year: number;
    month: number;
    day: number;
}

interface GeneratedTypeLiteralInterface_1 {
    callback: () => void;
}

@Component
export struct CalendarComponent {
    @State year: number = new Date().getFullYear();
    @State month: number = new Date().getMonth() + 1;
    @State days: Array<string> = this.generateDays();
    private weekTitles: Array<string> = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    private readonly today: todayInterface = {
        year: new Date().getFullYear(),
        month: new Date().getMonth() + 1,
        day: new Date().getDate()
    };
    // @StorageProp('selectedDay') selectedDay: number | undefined = AppStorage.get('selectedDay');
    // @State selectedDay: number = this.today.day;
    @StorageProp('selectedDate') selectedDate: string = AppStorage.get('selectedDate') ?? getDate();
    @Link selectedDay: number
    @Prop onUpdateDateWrapper: GeneratedTypeLiteralInterface_1 = {
        callback: () => {
        }
    };

    build() {
        Column() {
            // 日期头
            Row() {
                Image($r('app.media.right_grey'))
                    .rotate({ angle: 180 })
                    .width(16)
                    .height(16)
                    .onClick(() => {
                        this.getPreviousMonth()
                        this.days = this.generateDays()
                    })
                Text(`${this.formatDate(this.year, this.month)}`)
                    .fontSize(20)
                    .fontWeight('bold')
                    .padding(10)
                Image($r('app.media.right_grey'))
                    .width(16)
                    .height(16)
                    .onClick(() => {
                        this.getNextMonth()
                        this.days = this.generateDays()
                    })

                Button() {
                    Text('今日')
                        .fontSize(16)
                        .fontWeight('bold')
                        .fontColor('#007aff')
                }
                .width(60)
                .height(30)
                .backgroundColor(Color.White)
                .borderRadius(6)
                .onClick(() => {
                    this.goToday()
                    // AppStorage.set('selectedDate', getDate())
                    // this.selectedDate = getDate()
                    this.onUpdateDateWrapper.callback()
                })
            }

            // 日历主体
            Grid() {
                // 周
                ForEach(this.weekTitles, (weekTitles: string) => {
                    GridItem() {
                        Text(weekTitles)
                    }
                    .height(40)
                    .width(40)
                }, (weekTitles: string): string => weekTitles)

                // 天
                ForEach(this.days, (days: string) => {
                    GridItem() {
                        Text(days !== '' ? days : ' ')
                            .fontSize(14)
                            .fontFamily('HarmonyOS Sans')
                            .fontColor(this.shouldHighlight(parseInt(days)) ? '#ffffff' : '#000000')
                            .fontWeight(this.shouldHighlight(parseInt(days)) ? 'bold' : 'normal')
                            .width(30)
                            .height(30)
                            .textAlign(TextAlign.Center)
                            .backgroundColor(this.shouldHighlight(parseInt(days)) ? Color.Red : 'transparent')
                            .borderRadius(15)
                            .onClick(() => {
                                if (days !== '') {
                                    AppStorage.set('selectedDay', parseInt(days))
                                    // this.selectedDay = parseInt(days)
                                    const dateStr =
                                        `${this.year}-${this.month.toString().padStart(2, '0')}-${days.padStart(2,
                                            '0')}`;
                                    // this.selectedDate = dateStr;
                                    AppStorage.set('selectedDate', dateStr)

                                    this.onUpdateDateWrapper.callback()
                                    // AlertDialog.show({ title: 'Selected Date', message: dateStr })
                                }
                            })
                    }
                    .height(30)
                    .width(30)

                }, (day: string): string => day + Math.random())

            }
            .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr' as string)
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr' as string)
        }
        .height('100%')
        .width('100%')
    }

    private shouldHighlight(day: number): boolean {
        if (isNaN(day)) {
            return false
        }
        if (this.selectedDay !== null) {
            // AlertDialog.show({ message: this.selectedDay.toString() })
            return day === this.selectedDay
        }
        return (
            this.year === this.today.year &&
                this.month === this.today.month &&
                day === this.today.day
        )
    }

    private goToday() {
        // this.year = this.today.year
        // this.month = this.today.month
        // // this.selectedDay = this.today.day
        // AppStorage.set('selectedDay', this.today.day)
        // this.days = this.generateDays()
        this.year = this.today.year
        this.month = this.today.month
        this.selectedDay = this.today.day
        AppStorage.set('selectedDay', this.today.day)

        const todayStr = getDate();
        this.selectedDate = todayStr
        AppStorage.set('selectedDate', todayStr)

        this.days = this.generateDays()
    }

    private getPreviousMonth() {
        if (this.month === 1) {
            this.year -= 1;
            this.month = 12;
        } else {
            this.month -= 1;
        }
        this.generateDays()
    }

    private getNextMonth() {
        if (this.month === 12) {
            this.year += 1;
            this.month = 1;
        } else {
            this.month += 1;
        }
        this.generateDays()
    }

    private generateDays(): Array<string> {
        const days: string[] = [];
        // 获取该月第一天是星期几（0=周日，6=周六）
        const firstDayDate = new Date(this.year, this.month - 1, 1)
        const firstDayOfWeek = firstDayDate.getDay()
        // 这个月有多少天
        const daysInMonth = new Date(this.year, this.month, 0).getDate()
        // 添加前导空白
        for (let i = 0; i < firstDayOfWeek; i++) {
            days.push('')
        }
        // 添加实际天数
        for (let i = 1; i <= daysInMonth; i++) {
            days.push(i.toString())
        }
        return days
    }

    private formatDate(year: number, month: number): string {
        return `${year}-${month.toString().padStart(2, '0')}`;
    }
}