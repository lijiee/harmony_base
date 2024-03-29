import { EventKeys, LoadingDialog, loadingEvent, LogUtils } from '@ohos/common'
import { emitter } from '@kit.BasicServicesKit'
import MainViewModel from '../viewmodel/MainViewModel'
import { HomePage } from './HomePage'
import { LearnPage } from './LearnPage'
import { MinePage } from './MinePage'
import { TabItem } from '../entity/TabItem'

@Entry
@Component
struct MainPage {
  @State selectedIndex: number = 0
  @Provide homeTabSelected: number = 0
  @State loadingTips: string = "加载中..."
  @State loadingShow: boolean = false
  //全局的loading
  loadingDialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ loadingTips: this.loadingTips }),
    alignment: DialogAlignment.Center,
    autoCancel: false,
    gridCount: 2,
    cancel: () => {
      this.loadingShow = false
    }
  })

  aboutToAppear() {
    emitter.on(loadingEvent, (event) => {
      if (event.data?.showLoading == true && !this.loadingShow) {
        this.loadingShow = true
        this.loadingTips = event.data.loadingTips
        this.loadingDialogController.open()
      } else if (event.data?.showLoading == false) {
        this.loadingDialogController.close()
        this.loadingShow = false
      }
    })
  }

  aboutToDisappear() {
    emitter.off(EventKeys.LOADING_DIALOG_EVENT)
  }

  build() {
    Column() {
      Tabs({
        index: this.selectedIndex,
        barPosition: BarPosition.End,
      }) {
        TabContent() {
          HomePage()
        }
        .tabBar(this.TabBottom(MainViewModel.tabTitle[0], 0))

        TabContent() {
          LearnPage()
        }
        .tabBar(this.TabBottom(MainViewModel.tabTitle[1], 1))

        TabContent() {
          MinePage()
        }
        .tabBar(this.TabBottom(MainViewModel.tabTitle[2], 2))
      }
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .scrollable(false)
      .barHeight($r('app.float.tab_bar_height'))
      .onChange((index: number) => {
        this.selectedIndex = index;
        this.homeTabSelected = index
      })
    }
  }

  onPageShow() {
    LogUtils.error("页面可见>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  }

  onPageHide() {
    LogUtils.error("页面不可见>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  }

  @Builder
  TabBottom(item: TabItem, index: number) {
    Column() {
      Image(this.selectedIndex == index ? item.imageActivated : item.imageOriginal)
        .height($r('app.float.tab_image_size'))
        .width($r('app.float.tab_image_size'))
        .margin({
          top: $r('app.float.tab_margin_top'),
          bottom: $r('app.float.tab_margin_bottom')
        })
      Text(item.title)
        .width('100%')
        .height($r('app.float.tab_text_height'))
        .fontSize($r('app.float.tab_text_font_size'))
        .fontWeight(500)
        .fontColor(this.selectedIndex === index ? $r('app.color.color_main') : $r('app.color.color_666'))
        .textAlign(TextAlign.Center)
        .margin({
          bottom: $r('app.float.tab_text_margin_bottom')
        })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.color_f5"))
  }
}
