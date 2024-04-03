// import {
import { JsonUtils, LogUtils, ScanServiceManager, VideoComponent } from '@ohos/common'
import { scanBarcode, scanCore } from '@kit.ScanKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { hilog } from '@kit.PerformanceAnalysisKit'

//   StateComponent,
//   EmptyState,
//   LogUtils,
//   CommonType,
//   RSA,
//   JsonUtils,
//   LocationUtil,
//   CommonDialog
// } from '@ohos/common'
// import { ListItemData } from '../entity/ListItemData'
// import homeViewModel from '../viewmodel/HomeViewModel'
// import { checkVersion, getKeyMap, login } from '../http/ApiService'
// import { PermissionUtil } from '@ohos/common/src/main/ets/utils/PermissionUtil'
// import { Permissions } from '@kit.AbilityKit'
// import { router } from '@kit.ArkUI'
// import { loginFunction } from '../http/http'
//
// @Entry
// @Component
// export struct HomePage {
//   permissions: Array<Permissions> = ['ohos.permission.LOCATION','ohos.permission.APPROXIMATELY_LOCATION']
//   dialogController: CustomDialogController = new CustomDialogController({
//     builder: CommonDialog({
//       title: '提示', description: '您有权限未开启', positiveCallback: () => {
//         PermissionUtil.openPermissionSettings(getContext(this))
//       }
//     }),
//     autoCancel: false,
//     alignment: DialogAlignment.Center
//   })
//   @State state: number = EmptyState.stateLoading
//
//   aboutToAppear() {
//
//     LogUtils.error("hmoe页面可见>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
//     LocationUtil.getCurrentLocation(getContext(this),this.permissions).then((value)=>{
//       LogUtils.error(value.latitude.toString())
//     }).catch((error: Error)=>{
//       if (error.message == "alert") {
//         this.dialogController.open()
//       }
//     })
//     this.loadNet()
//   }
//
//   async loadNet() {
//     let keyMap = await getKeyMap()
//     let publicKey = keyMap.publicKey as string
//     let sign = keyMap.sign as string
//     let userPassword = await RSA.encrypt("rh123456", publicKey) ?? ""
//     loginFunction({ "account": "18612115211", "rsaSign": sign, "userPassword": userPassword })
//
//     // let loginData = await login<Record<string, CommonType>>("18612115211",sign,userPassword)
//     // LogUtils.info(JsonUtils.stringify(loginData))
//     let map1: Record<string, CommonType> = { "type": 1, "code": 1 }
//     let versionData = await checkVersion(map1)
//     LogUtils.info(JsonUtils.stringify(versionData))
//   }
//
//   build() {
//     Column() {
//       Image($r('app.media.bg_top')).width('100%')
//       Row() {
//         Text($r('app.string.app_name')).margin({ left: 10 })
//         Stack() {
//           Button('').width(72).height(24).backgroundColor('#ffffff').opacity(0.36)
//           Text('退出登录').fontColor('#293D5A').fontSize(12)
//         }.width(72).height(24).margin({ right: 10 }).onClick(() => {
//           // this.state += 1
//           router.pushUrl({ url: 'pages/CustomScanPage' })
//         })
//       }.margin({ top: -100 }).width('100%').justifyContent(FlexAlign.SpaceBetween)
//
//       StateComponent({
//         state: this.state, retryCallback: () => {
//           this.state = EmptyState.stateSuccess
//         }, viewContent: () => {
//           this.createMain()
//         }
//       })
//         .backgroundColor(Color.White)
//         .margin({ top: -20 })
//         .padding({ left: 10, right: 10, top: 30 })
//         .width('100%')
//         .borderRadius({ topLeft: 10, topRight: 10 })
//         .layoutWeight(1)
//     }
//   }
//
//   @Builder
//   createMain() {
//     GridRow({
//       columns: 4,
//       gutter: { x: 1, y: 1 },
//       direction: GridRowDirection.Row
//     }) {
//       ForEach(homeViewModel.getListDataSource(), (item: ListItemData) => {
//         GridCol() {
//           Column() {
//             Image(`${item.image}`).width(32).height(32)
//             Text(`${item.title}`).padding({ top: 10 })
//           }.height(60)
//         }
//       })
//     }
//   }
// }
@Entry
@Component
export struct HomePage {
  @State isFullScreen: boolean = false
  @State iUrl: string = 'xxxx.mp4'
  private intervalID?: number

  build() {
    Column() {
      // VideoComponent({ isFullScreen: this.isFullScreen, iUrl: this.iUrl })
      // Button("切换按钮")
      //   .onClick(() => {
      //     this.iUrl = "xxxxx.mp4"
      //   })
        // .visibility(this.isFullScreen ? Visibility.None : Visibility.Visible)
      Button("classid按钮")
        .onClick(() => {
        let params =  ScanServiceManager.getInstance().getServiceByContent("http://www.baidu.com?classId=2");
          LogUtils.debug(JsonUtils.stringify(params ?? ''))
        })
      Button("PreachId按钮")
        .onClick(() => {
          // this.iUrl = "xxxxx.mp4"
          let params =   ScanServiceManager.getInstance().getServiceByContent("http://www.baidu.com")
          LogUtils.debug(JsonUtils.stringify(params ?? ''))
        })
      Button("mId按钮")
        .onClick(() => {
          // this.iUrl = "xxxxx.mp4"
          let params =   ScanServiceManager.getInstance().getServiceByContent("http://www.baidu.com?preachId=2")
          LogUtils.debug(JsonUtils.stringify(params ?? ''))
        })

    }
    .width('100%')
    .height('100%')
  }

  onPageShow(): void {
    this.intervalID = setInterval(() => {

    }, 3000)
  }

  onPageHide(): void {
    clearInterval(this.intervalID)
  }
}