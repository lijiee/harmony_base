# 华为鸿蒙项目框架（api11） 具体包含功能如下：
```
下载安装
ohpm install @ohos/common_base
```
* 1、网络请求的基础封装(基于axios)；
* 2、封装项目页面多状态（加载中，成功，失败，空数据）；
* 3、全局loading实现
* 4、存储工具/权限工具/json 工具等
* 5、视频播放器封装
* 6、日历封装可以左右切换/上下切换
```import { CalendarComponent, OptMode, DateItem } from '@ohos/common_base';

@Entry
@Component
export struct MinePage {
  @State title: string = ""
  @State tags: string[] = []
  @State selectItem: DateItem = new DateItem(new Date())

  build() {
    Row() {
      Column() {
        CalendarComponent({
          optMode: OptMode.WEEK,
          onDateChange: (date?: DateItem) => {
            if (date) {
              this.selectItem = date
            }
          },
          onMonthChange: (after: Date, before: Date) => {
            if (after.getTime() === before.getTime()) {
              return
            }
            this.tags = ["2024-03-03", "2024-03-11", "2024-02-14"]
          },
          cusCellBottomLayout: (item: DateItem) => {
            this.cusCellBottomLayout(item)
          },
          topRightLayout: () => {
            this.topRightBuilder()
          }
        })
      }
      .width('100%')
    }
    .height('100%')
  }

  @Builder
  topRightBuilder() {
    Row() {
      this.rightItemBuilder("直播课", '#32C484')
      this.rightItemBuilder("线下课", '#317FFD')
    }
    .margin({ right: $r('app.float.size_12') })
  }

  @Builder
  rightItemBuilder(text: string, color: ResourceColor) {
    Row({ space: 3 }) {
      Text()
        .height($r('app.float.size_4'))
        .width($r('app.float.size_4'))
        .borderRadius($r('app.float.size_2'))
        .backgroundColor(color)
      Text(text)
        .fontSize($r('app.float.size_text_12'))
        .fontColor($r('app.color.color_666'))
    }
    .margin({ left: $r('app.float.size_12') })
  }

  @Builder
  cusCellBottomLayout(item: DateItem) {
    Row({ space: 4 }) {
      Text()
        .backgroundColor(item.equalDay(this.selectItem) ? Color.White : '#32C484')
        .width(4)
        .height(4)
        .borderRadius(2)
      Text()
        .backgroundColor(item.equalDay(this.selectItem) ? Color.White : '#317FFD')
        .width(4)
        .height(4)
        .borderRadius(2)
    }
    .margin({ bottom: 4 })
    .visibility(this.showTag(item) ? Visibility.Visible : Visibility.Hidden)
  }

  showTag(item: DateItem): boolean {
    return typeof this.tags.find((it) => {
      let its = it.split("-")
      let year = parseInt(its[0])
      let month = parseInt(its[1]) - 1
      let day = parseInt(its[2])
      return year === item.fullYear && month === item.month && day === item.date
    }) !== "undefined"
  }
```
* 7、form kit 的实现
![Screenshot_2024-04-19T150923.png](screenshot%2FScreenshot_2024-04-19T150923.png)