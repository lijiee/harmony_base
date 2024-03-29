import { AxiosHeaders } from '@ohos/axios'
import { axiosClient, CommonType } from '@ohos/common';
import { AppVersionInfoEntity } from '../entity/AppVersionInfoEntity';
let baseUrl = "https://xxxx"
let centerUrl = "https://xxxxx"
let commonHeader: AxiosHeaders = new AxiosHeaders({
  'Content-Type': 'application/x-www-form-urlencoded'
})
let centerHeader: AxiosHeaders = new AxiosHeaders()

export async function getKeyMap() {
  return axiosClient.post<Record<string, CommonType>>(
    {
      url: baseUrl + "api/user/getKeyMap",
      headers: commonHeader
    }
  )
}
export async function login<T>(account:string, sign: string,userPassword:string) {
  return axiosClient.post<T>(
    {
      url: baseUrl + "api/user/login",
      params: { "account": account, "rsaSign": sign, "userPassword": userPassword },
      headers: commonHeader
    }
  )
}
export async function checkVersion(map: Record<string, CommonType>) {
  return axiosClient.post<AppVersionInfoEntity>(
    {
      url: centerUrl + "system/appVersion/getLastVersion",
      data: map,
      headers: centerHeader
    }
  )
}

