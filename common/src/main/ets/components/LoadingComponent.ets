@Component
export struct LoadingComponent {
  @State value: number = 0
  build(){
    Column() {
      Progress({ value: 0, total: 100, type: ProgressType.Ring })
        .width(50).color($r('app.color.color_main'))
        .style({ strokeWidth: 2, status: ProgressStatus.LOADING })
      Text($r('app.string.loading'))
        .fontSize($r('app.float.size_text_16'))
        .fontColor($r('app.color.color_333'))
        .padding({top:$r('app.float.size_text_20')})
    }.width('100%')
    .backgroundColor($r('app.color.color_white'))
  }
}