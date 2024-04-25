import { CommonPicker } from './CommonPicker'
import { DateUtil } from './DateUtil'
import { DateItem, OptMode } from './CalenderEntity'
import { CalenderItemComponent } from './CalenderItemComponent'

@Component
export struct CalendarComponent {
  // 日期显示
  @State title: string = ""
  // 计算的总加载
  @State dates: Array<DateItem> = new Array()
  // 切换类型
  @State @Watch("optModeChange") private optMode: OptMode = OptMode.MONTH
  //设置选中
  @State selectItem?: DateItem = new DateItem(new Date())
  private today: Date = new Date() // 当天
  @State private currMonth: number = this.today.getMonth()
  @State private currYear: number = this.today.getFullYear()
  // 是否有上一个月
  @State hasPre: boolean = true
  // 是否有下一个月
  @State hasNext: boolean = true
  // 自定义头部
  @BuilderParam public cusTopLayout: (preAction: () => void,
                                      nextAction: () => void,
                                      openPicker: () => void,
                                      backToday: () => void) => void = this.CusTopLayout
  // 自定义日期下面的tag
  @BuilderParam public cusCellBottomLayout: (item: DateItem) => void
  // 自定义cell
  @BuilderParam public cusCellMainLayout: (item: DateItem) => void
  // 自定义cell背景颜色
  @BuilderParam public selectedLayout: (item: DateItem) => void
  // 自定义头部右边
  @BuilderParam public topRightLayout: () => void = this.TopRightLayout
  // 是不是显示月周切换
  showOptMode: boolean = true
  // 开始日期
  startDate?: Date
  // 截止日期
  endDate?: Date
  // 标题栏高度
  titleHeight: Length = '50vp'
  // 星期标题字体大小
  weekTitleFontSize: number | string | Resource = 13
  // 星期标题字体颜色
  weekTitleFontColor: ResourceColor = "#9E9E9E"
  // 星期背景色
  weekTitleBackgroundColor?: ResourceColor
  // 星期标栏高度
  weekTitleHeight: Length = 40
  // 标题字体大小
  titleFontSize: number | string | Resource = 18
  // 标题字体颜色
  titleFontColor: ResourceColor = "#252a34"
  // 是否显示快捷 今
  showFastToday: boolean = true
  // 今字体大小
  fastTodayFontSize: number | string | Resource = 12
  // 今字颜色
  fastTodayFontColor: ResourceColor = "#FFFFFF"
  // 今字体背景色
  fastTodayBg?: ResourceColor
  // 日期每一项字体大小
  itemFontSize: number | string | Resource = 18
  // item 正常字体色
  itemFontColor: ResourceColor = "#252a34"
  // item 正常字体重
  itemFontWeight: FontWeight = FontWeight.Normal
  // 今日字体颜色
  todayFontColor: ResourceColor = "#317FFD"
  // 不能使用的日期字体颜色
  disabledFontColor: ResourceColor = "#9E9E9E"
  // 选中日期字体颜色
  selectFontColor: ResourceColor = "#FFFFFF"
  // 选中日期背景颜色, 默认与todayFontColor一致
  selectItemBgColor?: ResourceColor
  // 选中日期事件
  onDateChange?: (date?: DateItem) => void
  // 月份变化事件
  onMonthChange?: (after: Date, befor: Date) => void
  // 不可选中项的点击事件
  disableCellClick?: (item: DateItem) => void
  // 当前选中的年月
  private currentDate: DateUtil = new DateUtil()
  // 滑动展示月周切换的位移量
  private offsetY: number = 0;
  private offsetX: number = 0;
  // 当前页开始计算的日期
  private startDay: Date = new Date(this.today.getFullYear(), this.today.getMonth(), 1) // 当前显示的月份的第一天
  dateArray: TextCascadePickerRangeContent[] = []
  datePickerController: CustomDialogController = new CustomDialogController({
    builder: CommonPicker({
      list: this.dateArray,
      value: [`${this.currentDate.year}`, this.currentDate.month],
      onChange: (value: string | string[]) => {
        this.currentDate = new DateUtil(`${value[0]}-${value[1]}-01`)
        this.changeMonth(this.currentDate.timeInstance)
      }
    }),
    autoCancel: false,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  })

  aboutToAppear() {
    this.initAttr()
    if (!this.selectItem) {
      let temp = new DateItem(this.today)
      this.selectItem = temp
    }
    this.calcDatas()

    const currentDate = new Date();
    const currentYear = currentDate.getFullYear();
    for (let i = currentYear - 20; i <= currentYear + 20; i++) {
      let content: TextCascadePickerRangeContent = {
        text: `${i}`,
        children: [{ text: "01" }, { text: "02" }, { text: "03" },
          { text: "04" }, { text: "05" }, { text: "06" },
          { text: "07" }, { text: "08" }, { text: "09" },
          { text: "10" }, { text: "11" }, { text: "12" }]
      }
      this.dateArray.push(content);
    }

  }

  // 属性初始化
  initAttr() {
    if (!this.selectItemBgColor) {
      this.selectItemBgColor = this.todayFontColor
    }
    if (!this.fastTodayBg) {
      this.fastTodayBg = this.todayFontColor
    }
    // 开始日期
    if (!this.startDate) {
      this.startDate = new Date(this.today.getFullYear() - 20, 0, 1)
    } else {
      this.startDate = new Date(this.startDate.getFullYear(), this.startDate.getMonth(), this.startDate.getDate())
    }
    // 截止日期
    if (!this.endDate) {
      this.endDate = new Date(this.today.getFullYear() + 20, 11, 31)
    } else {
      this.endDate = new Date(this.endDate.getFullYear(), this.endDate.getMonth(), this.endDate.getDate())
    }

    if (this.today.getTime() < this.startDate.getTime()) {
      this.startDay.setTime(this.startDate.getTime())
      this.showFastToday = false
    } else if (this.today.getTime() > this.endDate.getTime()) {
      this.startDay.setTime(this.endDate.getTime())
      this.showFastToday = false
    } else {
      this.startDay.setTime(this.today.getTime())
    }
  }

  optModeChange() {
    if (this.selectItem && this.selectItem.month === this.currMonth && this.selectItem.fullYear === this.currYear && this.optMode === OptMode.WEEK) {
      this.startDay = new Date(this.selectItem.fullYear, this.selectItem.month, this.selectItem.date)
    }
    this.calcDatas()
  }

  // 下一个月或者周
  nextAction(): void {
    if (this.optMode === OptMode.WEEK) {
      const beforDate = new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate())
      this.startDay.setDate(this.startDay.getDate() + 7)
      if (this.onMonthChange) {
        this.onMonthChange(new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate()), beforDate)
      }
      this.calcDatas()
      return
    }
    const beforDate = new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate())
    this.startDay.setMonth(this.startDay.getMonth() + 1)
    if (this.onMonthChange) {
      this.onMonthChange(new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate()), beforDate)
    }
    this.calcDatas()
  }

  changeMonth(selectDate: Date): void {
    const beforDate = new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate())
    this.startDay = new Date(selectDate.getFullYear(), selectDate.getMonth(), selectDate.getDate())
    if (this.onMonthChange) {
      this.onMonthChange(new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate()), beforDate)
    }
    this.calcDatas()
  }

  // 上一个月或周
  preAction(): void {
    if (this.optMode === OptMode.WEEK) {
      const beforDate = new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate())
      this.startDay.setDate(this.startDay.getDate() - 7)
      if (this.onMonthChange) {
        this.onMonthChange(new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate()), beforDate)
      }
      this.calcDatas()
      return
    }
    const beforDate = new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate())
    this.startDay.setMonth(this.startDay.getMonth() - 1)
    if (this.onMonthChange) {
      this.onMonthChange(new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate()), beforDate)
    }
    this.calcDatas()
  }

  // 回到今天
  backToday(): void {
    this.dates = []
    const beforDate = new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate())
    this.startDay = new Date(this.today.getFullYear(), this.today.getMonth(), this.today.getDate())
    let temp = new DateItem(this.today)
    this.selectItem = temp
    if (this.onMonthChange) {
      this.onMonthChange(new Date(this.startDay.getFullYear(), this.startDay.getMonth(), this.startDay.getDate()), beforDate)
    }
    this.calcDatas()
  }

  // 打开日历选择
  openPicker(): void {
    this.datePickerController.open()
  }

  // 计算数据源
  calcDatas() {
    this.dates = []
    const startDay = this.startDay
    this.currMonth = startDay.getMonth()
    this.currYear = startDay.getFullYear()
    this.title = `${startDay.getFullYear()}年${startDay.getMonth() + 1}月`
    this.currentDate = new DateUtil(`${startDay.getFullYear()}-${startDay.getMonth() + 1}-01`)
    if (this.optMode === OptMode.WEEK) {
      // 获取当前周的起始日期和结束日期
      const firstDayOfWeek = new Date(startDay);
      firstDayOfWeek.setDate(startDay.getDate() - startDay.getDay()); // 将日期设置为本周的第一天
      const lastDayOfWeek = new Date(startDay);
      lastDayOfWeek.setDate(startDay.getDate() - startDay.getDay() + 6); // 将日期设置为本周的最后一天
      // 生成一周的日期数组
      const weekArray: Date[] = [];
      let tempDate = new Date(firstDayOfWeek);
      while (tempDate <= lastDayOfWeek) {
        weekArray.push(new Date(tempDate));
        tempDate.setDate(tempDate.getDate() + 1);
      }
      // 将一周的日期信息存储到日期数组中
      for (const date of weekArray) {
        const isPrevMonth = date.getTime() < (this.startDate?.getTime() ?? 0);
        const isNextMonth = date.getTime() > (this.endDate?.getTime() ?? 0);
        const item = new DateItem(date, isPrevMonth, isNextMonth);
        this.dates.push(item);
      }
      return
    }
    startDay.setDate(1)
    if (startDay.getFullYear() < this.startDate!.getFullYear()
      || (startDay.getFullYear() == this.startDate!.getFullYear() && startDay.getMonth() <= this.startDate!.getMonth())) {
      this.hasPre = false
    } else {
      this.hasPre = true
    }
    if (startDay.getFullYear() > this.endDate!.getFullYear()
      || (startDay.getFullYear() == this.startDate!.getFullYear() && startDay.getMonth() >= this.endDate!.getMonth())) {
      this.hasNext = false
    } else {
      this.hasNext = true
    }
    let endDay: Date = new Date(
      startDay.getFullYear(),
      startDay.getMonth() + 1,
      0, 23, 59, 59)

    let tempDate: Date = new Date(
      startDay.getFullYear(),
      startDay.getMonth(),
      startDay.getDate()
    )
    const count = endDay.getDate()
    const preCount = startDay.getDay()
    const nextCount = 6 - endDay.getDay()
    const finilCount = count + preCount + nextCount
    tempDate.setDate(tempDate.getDate() - preCount)
    for (let index = 0; index < finilCount; index++) {
      let item = new DateItem(
        tempDate,
        (index < preCount ? true : false) || this.startDate!.getTime() > tempDate.getTime(),
        (index >= preCount + count ? true : false) || this.endDate!.getTime() < tempDate.getTime()
      )
      this.dates.push(item)
      tempDate.setDate(tempDate.getDate() + 1)
    }
  }

  build() {
    Column() {
      this.cusTopLayout(
        () => {
          this.preAction()
        },
        () => {
          this.nextAction()
        },
        () => {
          this.openPicker()
        },
        () => {
          this.backToday()
        },
      )
      // 星期title
      Row() {
        ForEach(["日", "一", "二", "三", "四", "五", "六"], (item: string) => {
          Text(item)
            .textAlign(TextAlign.Center)
            .fontColor(this.weekTitleFontColor)
            .fontSize(this.weekTitleFontSize)
            .layoutWeight(1)
        })
      }
      .backgroundColor(this.weekTitleBackgroundColor)
      .alignItems(VerticalAlign.Center)
      .height(this.weekTitleHeight)

      Swiper() {
        Flex({ wrap: FlexWrap.Wrap }) {
          this.ItemCell()
        }
        .width("100%")
      }
      .index(0)
      .itemSpace(0)
      .indicator(false)
      .onAnimationStart(( index: number, targetIndex: number, info: SwiperAnimationEvent) => {
        this.offsetX = info.currentOffset;
      })
      .onAnimationEnd(() => {
        if (this.offsetX > 100) {
          this.preAction()
        } else if (this.offsetX < -100) {
          this.nextAction()
        }
      })

      this.showOptModeBuilder()
    }
    .width("100%")
  }

  // 是否显示月周切换
  @Builder
  showOptModeBuilder() {
    Column() {
      Image($r('app.media.icon_opt_change'))
        .height($r('app.float.size_9'))
        .margin({ top: $r('app.float.size_6'), bottom: $r('app.float.size_16') })
        .rotate({
          x: 0,
          y: 0,
          z: 1,
          centerX: '50%',
          centerY: '50%',
          angle: this.optMode === OptMode.MONTH ? 180 : 0
        })
    }
    .width('100%')
    .visibility(this.showOptMode ? Visibility.Visible : Visibility.None)
    .gesture(
      // 绑定拖动手势
      PanGesture({ direction: PanDirection.Vertical })
        .onActionUpdate((event: GestureEvent | undefined) => {
          if (event) {
            this.offsetY = event.offsetY;
          }
        })
        .onActionEnd(() => {
          if (this.offsetY > 0) {
            this.optMode = OptMode.MONTH
          } else {
            this.optMode = OptMode.WEEK
          }
        })
    )
    .onClick(() => {
      this.optMode = this.optMode === OptMode.MONTH ? OptMode.WEEK : OptMode.MONTH
    })

  }

  // 自定义顶部
  @Builder
  CusTopLayout() {
    Row() {
      Row() {
        Text(this.title)
          .fontSize(this.titleFontSize)
          .fontColor(this.titleFontColor)
          .margin({ left: $r('app.float.size_12'), right: $r('app.float.size_6') })
          .onClick(() => {
            this.openPicker()
          })
        Image($r('app.media.icon_white_down'))
          .fillColor(this.titleFontColor)
          .width($r('app.float.size_8'))
          .height($r('app.float.size_8'))
        if ((this.currYear == this.today.getFullYear() && (this.currMonth != this.today.getMonth() || (this.optMode === OptMode.WEEK && !this.dates.some(dateItem => dateItem.isToday)))
          || this.currYear != this.today.getFullYear()) && this.showFastToday) {
          Row() {
            Text("今")
              .fontSize(this.fastTodayFontSize)
              .fontColor(this.fastTodayFontColor)
              .backgroundColor(this.fastTodayBg)
              .borderRadius(50)
              .padding(4)
              .margin({ left: 4 })
          }
          .onClick(() => {
            this.backToday()
          })
        }
      }

      Blank()
      this.topRightLayout()
    }
    .alignItems(VerticalAlign.Center)
    .width("100%")
    .height(this.titleHeight)
  }

  @Builder
  TopRightLayout() {
    Text("")
      .margin({ right: $r('app.float.size_12') })
  }

  @Builder
  ItemCell() {
    ForEach(this.dates, (item: DateItem) => {
      CalenderItemComponent({
        item: item,
        itemFontSize: this.itemFontSize,
        itemFontColor: this.itemFontColor,
        itemFontWeight: this.itemFontWeight,
        todayFontColor: this.todayFontColor,
        selectItem: $selectItem,
        selectFontColor: this.selectFontColor,
        selectItemBgColor: this.selectItemBgColor,
        disabledFontColor: this.disabledFontColor,
        hasPre: this.hasPre,
        hasNext: this.hasNext,
        cusCellBottomLayout: this.cusCellBottomLayout,
        cusCellMainLayout: this.cusCellMainLayout,
        selectedLayout: this.selectedLayout,
        disableClick: (item: DateItem) => {
          if (this.disableCellClick) {
            this.disableCellClick(item)
          }
        },
        cellClick: (item: DateItem) => {
          if (this.optMode === OptMode.MONTH) {
            if (item.isPre) {
              this.preAction()
            } else if (item.isNext) {
              this.nextAction()
            }
          }
          if (this.onDateChange) {
            this.onDateChange(item)
          }
        }
      })
        .width(`14.28%`)
    }, (item: DateItem) => JSON.stringify(item))
  }
}