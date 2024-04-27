import geoLocationManager from '@ohos.geoLocationManager';
import { Context, Permissions } from '@ohos.abilityAccessCtrl';
import { LogUtils } from './LogUtils';
import { PermissionUtil } from './PermissionUtil';
import { showToast } from './ToastUtils';


export class LocationUtil {
  static async getCurrentLocation(permissions:Array<Permissions>): Promise<geoLocationManager.Location> {
    let checkValue = await PermissionUtil.checkPermission(permissions)
    if (checkValue) {
      try {
        let requestInfo: geoLocationManager.CurrentLocationRequest = {'priority': geoLocationManager.LocationRequestPriority.FIRST_FIX, 'scenario': geoLocationManager.LocationRequestScenario.UNSET,'maxAccuracy': 0};
        let location = await geoLocationManager.getCurrentLocation(requestInfo)
        return Promise.resolve(location)
      } catch (err) {
        LogUtils.error("errCode:" + err.code + ",errMessage:" + err.message);
        if (err.code == "3301100") {
          showToast("请开启位置功能的开关")
        }
        return Promise.reject(err)
      }
    } else {
      let error = new Error()
      error.message = "alert"
      return Promise.reject(error)
    }
  }
  static getCurrentLocationAddress(location: geoLocationManager.Location):Promise<Array<geoLocationManager.GeoAddress>> {
    return new Promise((resolve,reject)=>{
      let latitude = location.latitude
      let longitude = location.longitude
      let maxItems = 1
      let reverseGeocodeReq: geoLocationManager.ReverseGeoCodeRequest = {'latitude':latitude,'longitude':longitude,'maxItems':maxItems}
      //根据坐标转化为地理描述
      geoLocationManager.getAddressesFromLocation(reverseGeocodeReq,(err,val) => {
        if (err) {
          LogUtils.debug('location getAddressesFromLocation err = '+JSON.stringify(err))
          reject(err)
        }
        if (val) {
          resolve(val)
          LogUtils.debug('location getAddressesFromLocation = '+JSON.stringify(val))
        }
      })
    })
  }
}
