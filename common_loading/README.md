```
下载安装
ohpm install @hereby/common_loading
```
* 全局loading实现

初始化及销毁 弹窗路径为 page
```
  onWindowStageCreate(windowStage: window.WindowStage) {
    LoadingManager.createLoadingWindow("pages/LoadingPage", windowStage)
    ...
  }

  onWindowStageDestroy() {
    LoadingManager.destroyLoadingWindow()
  }
```
使用
```
//弹出
    LoadingManager.showLoadingWindow()
// 取消
    LoadingManager.closeLoadingWindow()
```
