@Entry
@Component
struct LoadingPage {
  @State angle: number = 0

  aboutToAppear(): void {
    setTimeout(() => {
      animateTo({
        duration: 72 * 3 * 1000, //动画时长
        curve: Curve.Linear, //动画匀速
        iterations: 100, //动画次数
        playMode: PlayMode.Alternate, //来回交替
      }, () => {
        this.angle = 720 * 1000
      })
    }, 1000)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {

      Column() {
        Stack() {
          Image($r('app.media.common_loading')).width(25).height(25)

          Gauge({ value: 50, min: 1, max: 100 }) {
          }
          .startAngle(0)
          .endAngle(360)
          .colors(new LinearGradient([{ color: "#ffffff", offset: 0 },
            { color: "#205D96", offset: 1 }]))
          .width(40)
          .height(40)
          .strokeWidth(1.5)
          .indicator(null)
          .trackShadow({ radius: 2, offsetX: 2, offsetY: 2 })
          .rotate({
            z: 1,
            angle: this.angle
          })

        }

        Text('加载中..').fontSize(10).fontColor("#333333").margin({ top: 15 })
      }
      .borderRadius(10)
      .backgroundColor("#fffffff")
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width(150)
      .height(150)
      .alignItems(HorizontalAlign.Center)
    }.width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }
  //   build() {
  //   Stack({ alignContent: Alignment.Center }) {
  //     Column() {
  //       Stack() {
  //         Gauge({ value: 50, min: 1, max: 100 }) {
  //           Image($r('app.media.common_loading')).width(25).height(25)
  //         }
  //         .startAngle(0)
  //         .endAngle(360)
  //         .colors(new LinearGradient([{ color: "#ffffff", offset: 0 },
  //           { color: "#205D96", offset: 1 }]))
  //         .width(40)
  //         .height(40)
  //         .strokeWidth(1.5)
  //         .indicator(null)
  //         .trackShadow({ radius: 2, offsetX: 2, offsetY: 2 })
  //         .rotate({
  //           z: 1,
  //           angle: this.angle
  //         })
  //
  //       }
  //
  //       Text($r('app.string.loading'))
  //         .fontColor(Color.White)
  //         .fontSize($r('app.float.size_text_16'))
  //         .margin({ top: $r('app.float.size_15') })
  //         .width('100%')
  //         .textAlign(TextAlign.Center)
  //     }
  //     .justifyContent(FlexAlign.Center)
  //     .width($r('app.float.size_100'))
  //     .height($r('app.float.size_100'))
  //     .backgroundColor('#88000000')
  //     .borderRadius($r('app.float.size_8'))
  //   }
  //   .width('100%')
  //   .height('100%')
  //   .backgroundColor(Color.Transparent)
  // }
}
