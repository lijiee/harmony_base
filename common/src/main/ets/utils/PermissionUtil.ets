import { abilityAccessCtrl, bundleManager, common, Context, Permissions, Want } from '@kit.AbilityKit';
import { CommonType } from '../common/TypeAlias';
import { LogUtils } from './LogUtils';

export class PermissionUtil {
  static  async checkPermission(context:Context,permissions: Array<Permissions>) {
    let statusArray = new Array<abilityAccessCtrl.GrantStatus>();
    for(let i = 0; i<permissions.length; i++) {
      let status = await PermissionUtil.accessToken(permissions[i])
      statusArray.push(status)
    }
    let filterArray = statusArray.filter((element)=>{
      return element ==  abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
    if (filterArray.length == statusArray.length) {
      return Promise.resolve(true)
    } else {
      let atManager = abilityAccessCtrl.createAtManager()
      let requestResult = await atManager.requestPermissionsFromUser(getContext(),permissions)
      let grantStatus: Array<number> = requestResult.authResults
      let grantPermissions: Array<string> = requestResult.permissions
      let length: number = grantStatus.length
      LogUtils.debug('location user permission length' + JSON.stringify(grantPermissions)+length)
      let needOpen = false
      for(let i = 0; i<length; i++) {
        if (grantStatus[i] !== 0) {
          needOpen = true
          break
        }
      }
      return Promise.resolve(!needOpen)
    }
  }
  static async accessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager()
    let grantStatus: abilityAccessCtrl.GrantStatus = -1
    let tokenID: number = -1
    try {
      let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      tokenID = bundleInfo.appInfo.accessTokenId
    } catch (err) {
      LogUtils.debug('accessTokenId失败')
    }
    try {
      grantStatus = await atManager.checkAccessToken(tokenID,permission)
    } catch (err) {
      LogUtils.debug('grantStatus失败')
    }
    return grantStatus
  }

  static openPermissionSettings(context: Context) {
    let params: Record<string, Object> = {
      "settingsParamBundleName": `${context.applicationInfo.name}`
    }
    let  wantInfo:Want = {
      bundleName: 'com.huawei.hmos.settings',

      abilityName: 'com.huawei.hmos.settings.MainAbility',

      uri: 'application_info_entry',

      parameters: params
    }
    let abilityContext = getContext() as common.UIAbilityContext
    abilityContext.startAbility(wantInfo).then(() => {
      LogUtils.debug('location open setting page')
    }).catch((_: CommonType) => {
      LogUtils.debug('location open setting page failed')
    })
  }
}
