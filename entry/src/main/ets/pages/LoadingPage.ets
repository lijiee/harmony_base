@Entry
@Component
struct LoadingPage {
  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        LoadingProgress().width($r('app.float.size_30')).height($r('app.float.size_30')).color(Color.White)

        Text($r('app.string.loading'))
          .fontColor(Color.White)
          .fontSize($r('app.float.size_text_16'))
          .margin({ top: $r('app.float.size_15') })
          .width('100%')
          .textAlign(TextAlign.Center)
      }
      .justifyContent(FlexAlign.Center)
      .width($r('app.float.size_100'))
      .height($r('app.float.size_100'))
      .backgroundColor('#88000000')
      .borderRadius($r('app.float.size_8'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }
}
