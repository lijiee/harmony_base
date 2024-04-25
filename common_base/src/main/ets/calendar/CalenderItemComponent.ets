import { DateItem } from './CalenderEntity'

@Component
export struct CalenderItemComponent {
  // 选中的 item
  @Link selectItem: DateItem
  // 上月是否可用
  @Prop hasPre: boolean
  // 下月是否可用
  @Prop hasNext: boolean
  // 数据 item
  @Prop item: DateItem
  // 自定义底部小点
  @BuilderParam public cusCellBottomLayout: (item: DateItem) => void = this.CusCellBottomLayout
  // 自定义未选中 实现这个后 cusCellBottomLayout无效
  @BuilderParam public cusCellMainLayout: (item: DateItem) => void = this.CusCellMainLayout
  // 自定义选中的背景
  @BuilderParam public selectedLayout: (item: DateItem) => void = this.SelectedLayout
  selectMiddleOpacity: number = 0.15
  itemFontSize: number | string | Resource = 18
  itemFontColor: ResourceColor = "#252a34"
  itemFontWeight: FontWeight = FontWeight.Normal
  todayFontColor: ResourceColor = "317FFD"
  selectFontColor: ResourceColor = "#FFFFFF"
  selectItemBgColor: ResourceColor = this.todayFontColor
  disabledFontColor: ResourceColor = "#9E9E9E"
  cellClick?: (item: DateItem) => void
  disableClick?: (item: DateItem) => void
  getItemColor(): ResourceColor {
    if (this.item.isPre) {
      return this.disabledFontColor
    } else if (this.item.isNext) {
      return this.disabledFontColor
    } else if (this.item.equalDay(this.selectItem)) {
      return this.selectFontColor
    } else if (this.item.isToday) {
      return this.todayFontColor
    }
    return this.itemFontColor
  }

  @Builder
  SelectedLayout() {
    if (this.item.equalDay(this.selectItem)) {
      Column() {
        Column()
          .height("100%")
          .aspectRatio(1)
          .borderRadius(999)
          .backgroundColor(this.selectItemBgColor)
      }
      .position({ x: "10%", y: "10%" })
      .height("80%")
      .aspectRatio(1)
      .clip(true)
      .opacity(this.item.isPre || this.item.isNext ? this.selectMiddleOpacity : 1)
      .transition({ type: TransitionType.Insert, opacity: 1 })
      .transition({ type: TransitionType.Delete, opacity: 0 })
    }
  }

  @Builder
  CusCellMainLayout() {
    Column() {
      this.CusCellBottomLayout()
      Text(this.item.date + '')
        .fontSize(this.itemFontSize)
        .fontColor(this.getItemColor())
        .fontWeight(this.itemFontWeight)
      this.cusCellBottomLayout(this.item)
    }
  }

  @Builder
  CusCellBottomLayout() {
    Text()
      .width(4)
      .height(4)
      .margin({ bottom: 4 })
  }

  build() {
    Column() {
      Stack() {
        this.selectedLayout(this.item)
        this.cusCellMainLayout(this.item)
      }
      .aspectRatio(1)
      .width("100%")
    }
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .aspectRatio(1)
    .onClick(() => {

      if (this.item.isNext) {
        if (!this.hasNext) {
          if (this.disableClick) {
            this.disableClick(this.item)
          }
          return
        }
      }

      if (this.item.isPre) {
        if (!this.hasPre) {
          if (this.disableClick) {
            this.disableClick(this.item)
          }
          return
        }
      }
      this.selectItem = this.item
      if (this.cellClick) {
        this.cellClick(this.item)
      }
    })
  }
}
