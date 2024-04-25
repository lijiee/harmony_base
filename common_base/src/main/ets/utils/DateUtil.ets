export class DateUtil {
  timeInstance: Date;
  time: number;
  year: number;
  month: string;
  date: string;
  hour: string;
  minute: string;
  second: string;
  day: number;
  dayCn: string;
  timeAllStr: string;
  timeStr: string;
  timeStrCn: string;
  timeMonthStr: string;
  timeMonthStrCn: string;

  constructor(data?: number | string) {
    if (data) {
      this.timeInstance = new Date(data)
    } else {
      this.timeInstance = new Date()
    }
    this.time = this.timeInstance.getTime();
    this.year = this.timeInstance.getFullYear();
    this.month = this.getDouble(this.timeInstance.getMonth() + 1);
    this.date = this.getDouble(this.timeInstance.getDate());
    this.hour = this.getDouble(this.timeInstance.getHours());
    this.minute = this.getDouble(this.timeInstance.getMinutes());
    this.second = this.getDouble(this.timeInstance.getSeconds());
    this.day = this.timeInstance.getDay();
    this.dayCn = ['日', '一', '二', '三', '四', '五', '六'][this.timeInstance.getDay()];
    // 构造其他属性值
    this.timeAllStr = `${this.year}-${this.month}-${this.date} ${this.hour}:${this.minute}:${this.second}`;
    this.timeStr = `${this.year}-${this.month}-${this.date}`;
    this.timeStrCn = `${this.year}年${this.month}月${this.date}日`;
    this.timeMonthStr = `${this.year}-${this.month}`;
    this.timeMonthStrCn = `${this.year}年${this.month}月`;
  }

  getDouble(str: number | string) {
    let _str = str + '';
    return _str.length > 1 ? _str : `0${_str}`;
  }
}
