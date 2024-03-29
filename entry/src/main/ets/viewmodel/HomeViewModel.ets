import { ListItemData } from '../entity/ListItemData';
export class HomeViewModel {
  /**
   * Get data sources required by the LazyForEach interface.
   *
   * @return {ListDataSource} new ListDataSource(listItems)
   */
  getListDataSource(): Array<ListItemData> {
    let listItems: Array<ListItemData> = [];
    let titleItems: Array<String> = ['授课签到','授课签到']
    let imageItems: Array<String> = ['xxxx/images/icon1.png','xxxx/images/icon1.png']

    for (let i = 0; i < titleItems.length; i++) {
      let itemInfo: ListItemData = new ListItemData();
      itemInfo.image = imageItems[i]
      itemInfo.title = titleItems[i]
      listItems.push(itemInfo);
    }
    return listItems
  }

}

let homeViewModel = new HomeViewModel();

export default homeViewModel as HomeViewModel;