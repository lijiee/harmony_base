import window from '@ohos.window';
import display from '@ohos.display';
export class LoadingManager {
  private static loading_window: string = "loading_window"
  /**
   * 通过创建子窗口来显示Loading弹窗
   */
  static createLoadingWindow(path: string,stage: window.WindowStage) {
    stage?.createSubWindow(this.loading_window).then(async win => {
      // 设置子窗口显示的页面
      await win.setUIContent(path)
      let d = display.getDefaultDisplaySync()
      let windowClass = stage.getMainWindowSync()
      let area = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      // 调整子窗口大小，需剔除状态栏和导航栏高度，否则显示内容不居中
      await win.resize(d.width, d.height - area.topRect.height - area.bottomRect.height)
      // 设置半透明效果
      win.setWindowBackgroundColor('#00000000')
    })
  }

  /**
   * 销毁子窗口来
   */
  static async destroyLoadingWindow() {
    let windowClass: window.Window | undefined = undefined;
    try {
      windowClass = window.findWindow(this.loading_window);
      await windowClass.destroyWindow()
    } catch (_) {

    }
  }


  /**
   * 显示loading子窗口
   * @param stage stage
   */
  static async showLoadingWindow() {
    let windowClass: window.Window | undefined = undefined;
    try {
      windowClass = window.findWindow(this.loading_window);
      await windowClass.showWindow()
    } catch (exception) {

    }

  }

  /**
   * 关闭loading子窗口
   * @param stage stage
   */
  static async closeLoadingWindow() {
    let windowClass: window.Window | undefined = undefined;
    try {
      windowClass = window.findWindow(this.loading_window);
      await windowClass.minimize();
    } catch (_) {

    }
  }
}
