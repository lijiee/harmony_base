@Entry
@Component
struct WidgetCard {
  build() {
    Row() {
      Button('change1')
        .height('20%')
        .width('40%')
        .margin('5%')
        .onClick(() => {
          postCardAction(this, {
            action: 'router',
            abilityName: 'EntryAbility',
            params: { targetPage: 'funB' }
          });
        })
      Button('change2')
        .height('20%')
        .width('40%')
        .margin('5%')
        .onClick(() => {
          postCardAction(this, {
            action: 'router',
            abilityName: 'EntryAbility',
            params: { targetPage: 'funA' }
          });
        })
    }.height('100%').alignItems(VerticalAlign.Center)
  }
}