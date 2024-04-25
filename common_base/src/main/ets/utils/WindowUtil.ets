import { deviceInfo } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import { LogUtils } from './LogUtils';
import { VideoConstants } from '../constants/VideoConstants';

@Observed
export class WindowUtils {
  private windowStage?: window.WindowStage;
  private mainWindowClass?: window.Window;

  static getInstance(): WindowUtils | undefined {
    if (!AppStorage.get<WindowUtils>(VideoConstants.WINDOW_UTIL)) {
      AppStorage.setOrCreate(VideoConstants.WINDOW_UTIL, new WindowUtils());
    } else {
      LogUtils.info(`AppStorage does not have windowUtil`);
    }
    return AppStorage.get<WindowUtils>(VideoConstants.WINDOW_UTIL);
  }

  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
  }

  setMainWindowPortrait(): void {
    if (this.windowStage === undefined) {
      LogUtils.error(`WindowStage is undefined`);
      return;
    }
    // Obtain the main window of the application.
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      this.mainWindowClass = windowClass;
      if (err.code) {
        LogUtils.error(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      if (deviceInfo.deviceType !== VideoConstants.DEVICE_TYPES[0] && deviceInfo.deviceType !==
      VideoConstants.DEVICE_TYPES[1]) {
        // Set portrait display.
        this.mainWindowClass.setPreferredOrientation(window.Orientation.PORTRAIT);
      }
    });
  }

  setMainWindowRestricted(): void {
    if (this.mainWindowClass === undefined) {
      LogUtils.error(`MainWindowClass is undefined`);
      return;
    }
    // Setting restricted display.
    this.mainWindowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
  }

  setPhonePortrait(): void {
    if (this.mainWindowClass === undefined) {
      LogUtils.error(`MainWindowClass is undefined`);
      return;
    }
    // Setting restricted display.
    this.mainWindowClass.setPreferredOrientation(window.Orientation.PORTRAIT);
  }

  setFixedLandscape(): void {
    if (this.mainWindowClass === undefined) {
      LogUtils.error(`MainWindowClass is undefined`);
      return;
    }
    // Setting restricted display.
    this.mainWindowClass.setPreferredOrientation(window.Orientation.LANDSCAPE);
  }

  setMainWindowLandscape(): void {
    if (this.mainWindowClass === undefined) {
      LogUtils.error(`MainWindowClass is undefined`);
      return;
    }
    // Setting landscape display.
    this.mainWindowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
  }

  disableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      LogUtils.error(`MainWindowClass is undefined`);
      return;
    }
    // Set the status bar and navigation bar to be invisible in full-screen mode.
    this.mainWindowClass.setWindowSystemBarEnable([]);
  }

  enableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      LogUtils.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable(['status', 'navigation']);
  }

  setFullScreen(): void {
    if (this.mainWindowClass === undefined) {
      LogUtils.error(`MainWindowClass is undefined`);
      return;
    }
    // Set full-screen display.
    this.mainWindowClass.setWindowLayoutFullScreen(true, (err) => {
      if (err.code) {
        LogUtils.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
        return;
      }
      LogUtils.info('Succeeded in setting the window layout to full-screen mode.');
    });
  }

  getMainWindow(): window.Window | undefined {
    return this.mainWindowClass;
  }
}