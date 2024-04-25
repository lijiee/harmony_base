import { EmptyState } from './StateComponent'
@Component
export struct EmptyComponent {
  @Prop state: number
  //重试的回调方法
  retryCallback?: () => void
  build(){
        Column() {
          Image(this.createStateImg()).width(200).height(200)
          Text(this.createStateText())
            .fontSize($r('app.float.size_text_16'))
            .fontColor($r('app.color.color_333'))
            .padding({top:$r('app.float.size_text_20')})
          Button('重试')
            .height(40)
            .width(100)
            .backgroundColor($r('app.color.color_main'))
            .fontColor($r('app.color.color_white'))
            .fontSize($r('app.float.size_text_16'))
            .border({ radius: 20 })
            .margin({top:$r('app.float.size_text_20')})
            .onClick(this.retryCallback)
        }.width('100%')
        .backgroundColor($r('app.color.color_white'))
  }
  createStateImg() {
    switch (this.state){
      case EmptyState.stateEmpty:
        return $r('app.media.icon_nodata')
      case EmptyState.stateFail:
        return $r('app.media.icon_load_error')
      case EmptyState.stateNoNet:
        return $r('app.media.icon_nonet')
      default :
      return $r('app.media.icon_nodata')
    }
  }
  createStateText() {
    switch (this.state){
      case EmptyState.stateEmpty:
        return $r('app.string.load_nodata')
      case EmptyState.stateFail:
        return $r('app.string.load_error')
      case EmptyState.stateNoNet:
        return $r('app.string.load_nonet')
      default :
      return $r('app.string.load_nodata')
    }
  }

}
