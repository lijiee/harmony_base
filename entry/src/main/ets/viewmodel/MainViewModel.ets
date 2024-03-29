import { TabItem } from '../entity/TabItem';

/**
 * MainAbility的ViewModel
 */
export class MainViewModel {
  /**
   * 首页底部Tab显示数据
   */
  tabTitle: Array<TabItem> = [
    {
      index: 0,
      title: "首页",
      imageActivated: $r('app.media.icon_home_select'),
      imageOriginal: $r('app.media.icon_home')
    },
    {
      index: 1,
      title: "学习",
      imageActivated: $r('app.media.icon_learn_select'),
      imageOriginal: $r('app.media.icon_learn')
    },
    {
      index: 2,
      title: "我的",
      imageActivated: $r("app.media.icon_mine_select"),
      imageOriginal: $r('app.media.icon_mine')
    }
  ]
}

let mainViewModel = new MainViewModel();

export default mainViewModel as MainViewModel;