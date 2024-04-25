@CustomDialog
export struct CommonPicker {
  //确认按钮回调
  public onChange?: (value: string | string[], index: number | number[]) => void
  //弹窗控制器
  controller?: CustomDialogController
  list: TextCascadePickerRangeContent[] = []
  private value?: string | string[]
  private index?: number | number[]

  build() {
    Column() {
      Row() {
        Text("取消")
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.color_999'))
          .fontSize($r('app.float.size_text_14'))
          .margin({ left: $r('app.float.size_20') })
          .onClick(() => {
            this.controller?.close()
          })
        Blank()
        Text("确定")
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.color_333'))
          .fontSize($r('app.float.size_text_14'))
          .margin({ right: $r('app.float.size_20') })
          .onClick(() => {
            if (this.value === undefined || this.value === '') {
              let values = this.extractFirstChildren(this.list)
              if (values.length === 1) {
                this.value = values[0]
                this.index = 0
              } else {
                this.value = values
                this.index = new Array(values.length).fill(0);
              }
            }
            this.onChange?.(this.value!, this.index!)
            this.controller?.close()
          })

      }
      .height($r('app.float.size_44'))
      .width('100%')
      .borderColor("#f5f5f5")
      .borderWidth({ bottom: $r('app.float.size_1') })

      TextPicker({ range: this.list, value: this.value })
        .canLoop(false)
        .onChange((value: string | string[], index: number | number[]) => {
          this.value = value;
          this.index = index
        })
        .disappearTextStyle({ color: $r('app.color.color_666'), font: { size: $r('app.float.size_text_14') } })
        .textStyle({ color: $r('app.color.color_333'), font: { size: $r('app.float.size_text_15') } })
        .selectedTextStyle({ color: "#1973f4", font: { size: $r('app.float.size_text_16') } })
        .width('100%')
        .layoutWeight(1)
        .margin({ top: $r('app.float.size_10'), bottom: $r('app.float.size_10') })
    }
    .width('100%')
    .height('40%')
    .backgroundColor(Color.White)
  }

  extractFirstChildren(contentArray: TextCascadePickerRangeContent[]): string[] {
    if (contentArray.length === 0) {
      return [];
    }
    const firstContent = contentArray[0];
    if (!firstContent) {
      return [];
    }
    if (firstContent.children && firstContent.children.length > 0) {
      const childrenOfFirstChild = this.extractFirstChildren(firstContent.children);
      return [firstContent.text as string, ...childrenOfFirstChild];
    } else {
      return [firstContent.text as string];
    }
  }
}