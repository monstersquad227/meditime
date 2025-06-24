export function getDate(): string {
    let year = new Date().getFullYear()
    let month = new Date().getMonth() + 1;
    let day = new Date().getDate()
    return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
}


export class CalendarUtils {
    // 获取今年： 2025
    static getYear(): string {
        return new Date().getFullYear().toString()
    }

    // 获取今月： 05
    static getMonth(): string {
        let month = new Date().getMonth() + 1
        return month.toString().padStart(2, '0');
    }

    // 获取今日： 01
    static getDay(): string {
        return new Date().getDate().toString().padStart(2, '0');
    }

    // 月份添加: 2025-03-20 -> 2025-04-20
    static addMonth(val: string): string {
        let valArray = val.split('-')
        let year = parseInt(valArray[0])
        let month = parseInt(valArray[1])

        if (isNaN(year) || isNaN(month)) {
            throw new Error('Invalid input format, expected YYYY-MM')
        }

        month += 1
        if (month > 12) {
            month = 1
            year += 1
        }

        return `${year}-${month.toString().padStart(2, '0')}`
    }

    // 获取今天 格式：2025-06-24
    static getToday(): string {
        let year = new Date().getFullYear()
        let month = new Date().getMonth() + 1;
        let day = new Date().getDate()
        return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
    }

    // 获取这个月有多少天
    static getDaysInMonth(year: number, month: number): number {
        return new Date(year, month, 0).getDate()
    }

    // 获取这个月有多少天的数组
    static getDaysArray(year: number, month: number): Array<string> {
        let result: string[] = [];
        let week = CalendarUtils.getFirstDayOfWeek(year, month)
        let days = CalendarUtils.getDaysInMonth(year, month)
        // 添加前导空白
        for (let i = 0; i < week; i++) {
            result.push('')
        }
        // 添加实际天数
        for (let i = 1; i <= days; i++) {
            result.push(i.toString())
        }
        return result
    }

    // 获取这个月的第一天是星期几
    static getFirstDayOfWeek(year: number, month: number): number {
        const firstDay = new Date(year, month - 1, 1)
        return firstDay.getDay()
    }

    static getAllWeekTitle(): Array<string> {
        return ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    }
}