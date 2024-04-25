import { VideoConstants } from '../constants/VideoConstants';
import { AvPlayerUtils } from '../utils/AvPlayerUtils';
import { LogUtils } from '../utils/LogUtils'
import { WindowUtils } from '../utils/WindowUtil';
import { display } from '@kit.ArkUI';
import { VideoSpeed } from '../entity/VideoSpeed';

@Component
export struct VideoComponent {
  @Link isFullScreen: boolean
  @Prop @Watch('urlChange') iUrl: string
  @StorageLink('lastCurrentTime') lastCurrentTime: number = 0;
  @State hiddenSubComponent: boolean = false
  @State showSpeed: boolean = false
  private xComponentController: XComponentController = new XComponentController();
  private surfaceId: string = '';
  private avPlayerUtil: AvPlayerUtils = new AvPlayerUtils();
  private windowUtils?: WindowUtils;
  private videoHeight: string = '';

  urlChange() {
    this.avPlayerUtil.changeVideoUrl(this.iUrl)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      XComponent({
        id: VideoConstants.XComponent_ID,
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .onLoad(() => {
          this.xComponentController.setXComponentSurfaceSize({
            surfaceWidth: VideoConstants.X_COMPONENT_SURFACE_WIDTH,
            surfaceHeight: VideoConstants.X_COMPONENT_SURFACE_HEIGHT
          });
          this.surfaceId = this.xComponentController.getXComponentSurfaceId();
          this.avPlayerUtil.createAvPlayer(this.surfaceId, this.iUrl);
        }).zIndex(0)
      Column() {
        TopComponent({
          isFullScreen: this.isFullScreen, hiddenSubComponent: this.hiddenSubComponent, onCancelFullCallBack: () => {
            this.isFullScreen = false
            this.windowUtils?.setMainWindowPortrait();
          }
        })
        CenterComponent({
          playAgainCallBack: () => {
            this.avPlayerUtil.playerStateControl()
          }
        })
          .onClick(() => {
            this.hiddenSubComponent = !this.hiddenSubComponent;
          })
          .layoutWeight(1)
        BottomComponent({
          isFullScreen: this.isFullScreen,
          hiddenSubComponent: this.hiddenSubComponent,
          onChangeCallBack: (value: number, mode: SliderChangeMode) => {
            this.avPlayerUtil.sliderChange(value, mode);
          },
          onFullCallBack: () => {
            this.isFullScreen = true
            this.windowUtils?.setMainWindowLandscape();
          },
          playCallBack: () => {
            this.avPlayerUtil.playerStateControl();
          },
          playSpeedCallBack: () => {
            this.showSpeed = !this.showSpeed
          }
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.showSpeed) {
        SpeedComponent({
          speedCallBack: (speed) => {
            if (speed) {
              this.avPlayerUtil.setSpeed(speed)
            }
            this.showSpeed = false
          }
        })
      }
    }
    .backgroundColor(Color.Black)
    .width('100%')
    .height(this.isFullScreen ? '100%' : this.videoHeight)
  }

  aboutToAppear(): void {
    LogUtils.info("aboutToAppear")
    this.windowUtils = WindowUtils.getInstance();
    this.videoHeight = `${this.getVideoHeight()}vp`
    this.avPlayerUtil.onTimeUpdate();
    this.avPlayerUtil.setStartTime(this.lastCurrentTime);
    this.avPlayerUtil.play();
  }

  aboutToDisappear(): void {
    LogUtils.info("aboutToDisappear")
    this.avPlayerUtil.pause();
    this.avPlayerUtil.offTimeUpdate();
    this.avPlayerUtil.release();
    if (this.isFullScreen) {
      this.windowUtils?.setMainWindowPortrait();
    }
  }

  getVideoHeight(): number {
    let displayObject = display.getDefaultDisplaySync();
    let screenPixelWidth = displayObject.width;
    return px2vp(screenPixelWidth * 9 / 16)
  }
}

@Component
struct BottomComponent {
  @StorageLink('currentTime') currentTime: string = VideoConstants.INITIAL_TIME;
  @StorageLink('totalTime') totalTime: string = VideoConstants.INITIAL_TIME;
  @StorageLink('playStatus') playStatus: string = VideoConstants.AV_PLAYER_IDLE_STATE;
  @StorageLink('playSpeed') playSpeed: string = "1.0X";
  @StorageLink('progress') progress: number = 0;
  @Prop isFullScreen: boolean
  @Prop hiddenSubComponent: boolean
  private onChangeCallBack?: (value: number, mode: SliderChangeMode) => void
  private onFullCallBack?: () => void
  private playCallBack?: () => void
  private playSpeedCallBack?: () => void

  build() {
    Row() {
      Image(this.playStatus == VideoConstants.AV_PLAYER_PLAYING_STATE ? $r('app.media.icon_pause') : $r('app.media.icon_play'))
        .margin({
          left: $r('app.float.size_20'),
        })
        .height($r('app.float.size_24'))
        .width($r('app.float.size_24'))
        .onClick(this.playCallBack)
      Text(this.currentTime)
        .fontSize($r('app.float.size_text_9'))
        .fontColor(Color.White)
        .lineHeight($r('app.float.size_12'))
        .width($r('app.float.size_38'))
        .margin({
          left: $r('app.float.size_10'),
          right: $r('app.float.size_2')
        })
      Slider({ min: 0, max: VideoConstants.PROGRESS_HUNDRED, step: 1, value: this.progress })
        .blockSize({ width: $r('app.float.size_10'), height: $r('app.float.size_10') })
        .onChange(this.onChangeCallBack)
        .layoutWeight(1)
        .selectedColor($r('app.color.color_main'))
      Text(this.totalTime)
        .fontSize($r('app.float.size_text_9'))
        .fontColor(Color.White)
        .lineHeight($r('app.float.size_12'))
        .width($r('app.float.size_38'))
        .margin({
          left: $r('app.float.size_10'),
          right: $r('app.float.size_10')
        })
      Image($r('app.media.ic_public_enlarge'))
        .height($r('app.float.size_24'))
        .width($r('app.float.size_24'))
        .margin({ right: $r('app.float.size_10') })
        .fillColor(Color.White)
        .align(Alignment.Center)
        .visibility(this.isFullScreen ? Visibility.None : Visibility.Visible)
        .onClick(this.onFullCallBack)
      if (this.isFullScreen) {
        Row() {
          Text($r('app.string.play_speed'))
            .fontSize($r('app.float.size_text_9'))
            .fontColor(Color.White)
            .lineHeight($r('app.float.size_12'))
          Text(this.playSpeed)
            .fontSize($r('app.float.size_text_9'))
            .fontColor(Color.White)
            .lineHeight($r('app.float.size_12'))
            .margin({
              right: $r('app.float.size_10')
            })
        }
        .onClick(this.playSpeedCallBack)
      }
    }
    .visibility(!this.hiddenSubComponent ? Visibility.Visible : Visibility.Hidden)
    .backgroundColor('#33000000')
    .width('100%')
    .height($r('app.float.size_40'))
  }
}

@Component
struct TopComponent {
  @Prop isFullScreen: boolean
  @Prop hiddenSubComponent: boolean
  private onCancelFullCallBack?: () => void

  build() {
    Row() {
      Image($r('app.media.icon_back'))
        .height($r('app.float.size_24'))
        .width($r('app.float.size_24'))
        .fillColor(Color.White)
        .align(Alignment.Center)
        .margin({ left: $r('app.float.size_20') })
        .onClick(this.onCancelFullCallBack)
    }
    .visibility((this.isFullScreen && !this.hiddenSubComponent) ? Visibility.Visible : Visibility.Hidden)
    .backgroundColor('#33000000')
    .width('100%')
    .height($r('app.float.size_40'))
  }
}

@Component
struct CenterComponent {
  @StorageLink('playStatus') playStatus: string = VideoConstants.AV_PLAYER_IDLE_STATE;
  private playAgainCallBack?: () => void

  build() {
    Row() {
      if (this.playStatus === VideoConstants.AV_PLAYER_IDLE_STATE ||
        this.playStatus === VideoConstants.AV_PLAYER_INITIALIZED_STATE ||
        this.playStatus === VideoConstants.AV_PLAYER_PREPARED_STATE) {
        LoadingProgress()
          .width($r('app.float.size_40'))
          .height($r('app.float.size_40'))
          .color(Color.White)
      } else if (this.playStatus === VideoConstants.AV_PLAYER_STOPPED_STATE ||
        this.playStatus === VideoConstants.AV_PLAYER_ERROR_STATE) {
        Button($r('app.string.play_again'))
          .borderRadius($r('app.float.size_8'))
          .backgroundColor($r('app.color.color_main'))
          .width($r('app.float.size_90'))
          .height($r('app.float.size_40'))
          .onClick(this.playAgainCallBack)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

@Component
struct SpeedComponent {
  private speedCallBack?: (speed?: VideoSpeed | null) => void

  build() {
    Row() {
      Blank()
      List() {
        ForEach(VideoConstants.SPEED_ARRAY, (item: VideoSpeed) => {
          ListItem() {
            Text(item.text)
              .width('100%')
              .height('calc(100% / 5)')
              .fontSize($r('app.float.size_text_14'))
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .onClick(() => {
                if (this.speedCallBack) {
                  this.speedCallBack(item)
                }
              })
          }
        })
      }
      .height('100%')
      .width('20%')
      .backgroundColor('#33000000')
    }
    .justifyContent(FlexAlign.End)
    .align(Alignment.Center)
    .height('100%')
    .width('100%')
    .onClick(() => {
      if (this.speedCallBack) {
        this.speedCallBack(null)
      }
    })
  }
}