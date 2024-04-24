import { ListItemData } from '../entity/ListItemData';
export class HomeViewModel {
  /**
   * Get data sources required by the LazyForEach interface.
   *
   * @return {ListDataSource} new ListDataSource(listItems)
   */
  getListDataSource(): Array<ListItemData> {
    return []
  }

}

let homeViewModel = new HomeViewModel();

export default homeViewModel as HomeViewModel;