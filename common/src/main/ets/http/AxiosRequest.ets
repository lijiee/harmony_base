import { AxiosError, AxiosRequestHeaders, AxiosResponse } from '@ohos/axios';
import { CommonType } from '../common/TypeAlias';
import { LoadingUtils } from '../utils/LoadingUtils';
import { JsonUtils } from '../utils/JsonUtils';
import { LogUtils } from '../utils/LogUtils';
import { showToast } from '../utils/ToastUtils';
import { AxiosHttpRequest } from './AxiosHttp';

/**
 * axios请求客户端创建
 */
 export const axiosClient = new AxiosHttpRequest({
  baseURL: "/api",
  timeout: 10 * 1000,
  checkResultCode: false,
  headers: {
    'Content-Type': 'application/json'
  } as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      // 在发送请求之前做一些处理，例如打印请求信息
      LogUtils.debug('网络请求Request 请求方法:', `${config.method}`);
      LogUtils.debug('网络请求Request 请求链接:', `${config.url}`);
      LogUtils.debug('网络请求Request Params:', `\n${JsonUtils.stringify(config.params)}`);
      LogUtils.debug('网络请求Request Data:', `${JsonUtils.stringify(config.data)}`);
      axiosClient.config.showLoading = config.showLoading
      if (config.showLoading) {
       await LoadingUtils.showLoadingWindow()
      }
      return config;
    },
    requestInterceptorCatch: async (err) => {
      LogUtils.error("网络请求RequestError", err?.toString())
      if (axiosClient.config.showLoading) {
       await LoadingUtils.closeLoadingWindow()
      }
      return err;
    },
    responseInterceptor: async (response: AxiosResponse) => {
      //优先执行自己的请求响应拦截器，在执行通用请求request的
      if (axiosClient.config.showLoading) {
        await LoadingUtils.closeLoadingWindow()
      }
      LogUtils.debug('网络请求响应Response:', `\n${JsonUtils.stringify(response.data)}`);
      if (response.status === 200) {
        if (response.data.success != null) {
          if (response.data.success == false ) {
            showToast(response.data.message)
            return Promise.reject(response)
          }
          return Promise.resolve(response.data.entity);
        } else {
          if (response.data.code != 200 ) {
            showToast(response.data.msg)
            return Promise.reject(response)
          }
          return Promise.resolve(response.data.data);

        }
      } else {
        return Promise.reject(response);
      }
    },
    responseInterceptorCatch: async (error) => {
      if (axiosClient.config.showLoading) {
        await LoadingUtils.closeLoadingWindow()
      }
      LogUtils.error("网络请求响应异常", error?.toString())
      errorHandler(error);
      return Promise.reject(error);
    },
  }
});

export function errorHandler(error: CommonType) {
  if (error instanceof AxiosError) {
    showToast(error.message)
  }
}
