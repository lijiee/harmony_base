import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import process from '@ohos.process';
import { LogUtils } from '@ohos/common/src/main/ets/utils/LogUtils';
import { AbilityConstant, Want } from '@kit.AbilityKit';
import { LoadingUtils } from '@ohos/common/src/main/ets/utils/LoadingUtils';
import { WindowUtils } from '@ohos/common';

const TAG: string = 'EntryAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryAbility extends UIAbility {
  private selectPage: string = '';
  private currentWindowStage: window.WindowStage | null = null;
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 获取router事件中传递的targetPage参数
    hilog.info(DOMAIN_NUMBER, TAG, `Ability onCreate, ${JSON.stringify(want)}`);
    if (want.parameters !== undefined) {
      let params: Record<string, string> = JSON.parse(JSON.stringify(want.parameters));
      this.selectPage = params.targetPage;
    }
  }
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onNewWant Want: ${JSON.stringify(want)}`);
    if (want.parameters?.params !== undefined) {
      let params: Record<string, string> = JSON.parse(JSON.stringify(want.parameters?.params));
      this.selectPage = params.targetPage;
    }
    if (this.currentWindowStage !== null) {
      this.onWindowStageCreate(this.currentWindowStage);
    }
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    let windowClass: window.Window | undefined = undefined;
    LoadingUtils.createLoadingWindow(windowStage)
    let windowUtil = WindowUtils.getInstance();
    if (windowUtil !== undefined) {
      windowUtil.setWindowStage(windowStage);
      windowUtil.setMainWindowPortrait();
    }
    windowStage.getMainWindow((err, data) => {

      if (err.code) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }

      windowClass = data;
      console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));


      // 2.实现沉浸式效果：设置导航栏、状态栏不显示。
      // let names = ["status"];
      let names = [];
      windowClass.setWindowSystemBarEnable(names, (err) => {
        if (err.code) {
          console.error('Failed to set the system bar to be visible. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting the system bar to be visible.');
      });
      windowClass.setWindowLayoutFullScreen(true)

    })
    if (this.currentWindowStage === null) {
      this.currentWindowStage = windowStage;
    }
    let targetPage: string;
    // 根据传递的targetPage不同，选择拉起不同的页面
    switch (this.selectPage) {
      case 'funA':
        targetPage = 'pages/HomePage';
        break;
      case 'funB':
        targetPage = 'pages/MinePage';
        break;
      default:
        targetPage = 'pages/MainPage';
    }

    windowStage.loadContent(targetPage, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    LoadingUtils.destroyLoadingWindow()
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
