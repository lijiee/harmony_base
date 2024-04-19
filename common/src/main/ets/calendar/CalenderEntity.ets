
/**
 * 操作模式
 */
export enum OptMode {
  /** 周模式 */
  WEEK = "week",
  /** 月模式 */
  MONTH = "month",
}

export class DateItem {
  fullYear?: number
  month?: number
  date?: number
  week?: number
  time?: number
  isPre?: boolean // 是否是上一个月的 / 在startDate 之前
  isNext?: boolean // 是否是下一个月的 / 在endDate 之后
  isToday?: boolean // 是否是今天
  constructor(date: Date,
              isPre?: boolean,
              isNext?: boolean) {
    if (date) {
      this.fullYear = date.getFullYear()
      this.month = date.getMonth()
      this.date = date.getDate()
      this.week = date.getDay()
      this.time = date.getTime()
      this.isToday = this.checkIfToday(date);
    }

    this.isPre = isPre
    this.isNext = isNext
  }

  private checkIfToday(date: Date): boolean {
    const today = new Date();
    return (
      date.getDate() === today.getDate() &&
        date.getMonth() === today.getMonth() &&
        date.getFullYear() === today.getFullYear()
    );
  }

  equalDay(other: DateItem | number): boolean {
    if (typeof other == "number") {
      other = new DateItem(new Date(other))
    }
    if (other) {
      if (this.fullYear == other.fullYear
        && this.month == other.month
        && this.date == other.date) {
        return true
      }
      return false
    }
    return false
  }
}
