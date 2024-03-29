import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { scanBarcode, customScan } from '@kit.ScanKit';
import { display } from '@kit.ArkUI';

@Entry
@Component
struct CustomScanPage {
  // 设置预览流高度，默认单位：vp
  @State cameraHeight: number = 640
  // 设置预览流宽度，默认单位：vp
  @State cameraWidth: number = 360
  private mXComponentController: XComponentController = new XComponentController();
  aboutToAppear(): void {
    try {
      let displayClass = display.getDefaultDisplaySync();
      this.cameraHeight = displayClass.height;
      this.cameraWidth = displayClass.width;
    } catch (exception) {
      console.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
    }

  }


  build() {
    Stack() {
      XComponent({
        id: 'componentId',
        type: 'surface',
        controller: this.mXComponentController
      })
        .onLoad(() => {
          hilog.info(0x0001, '[Scan Sample]', 'onLoad is called')
          // 获取XComponent的surfaceId
          let surfaceId: string = this.mXComponentController.getXComponentSurfaceId();
          hilog.info(0x0001, 'viewControl', `onLoad surfaceId: ${surfaceId}`);
          // 设置ViewControl相应字段
          let viewControl: customScan.ViewControl = {
            width: this.cameraWidth,
            height: this.cameraHeight,
            surfaceId: surfaceId
          };
          try {
            customScan.start(viewControl, (error: BusinessError, scanResult: Array<scanBarcode.ScanResult>) => {
              if (error) {
                hilog.error(0x0001, '[Scan Sample]', 'start failed , error: %{public}s', JSON.stringify(error))
                return;
              }
              hilog.info(0x0001, '[Scan Sample]', 'callback scan result: %{public}s', JSON.stringify(scanResult))
            });
          } catch (error) {
            hilog.error(0x0001, '[Scan Sample]', 'start failed , error: %{public}s', JSON.stringify(error))
          }
        })
          // 预览流宽、高，默认单位vp，支持px、lpx、vp
        .height(this.cameraHeight)
        .width(this.cameraWidth)
        .position({ x: 0, y: 0 })
    }
    .alignContent(Alignment.Bottom)
    .height('100%')
    .width('100%')
    .position({ x: 0, y: 0 })
  }
}