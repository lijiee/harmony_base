// 引入包名
import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { MD5 } from '@ohos/common';
import { systemDateTime } from '@kit.BasicServicesKit';
let httpRequest = http.createHttp();
httpRequest.on('headersReceive', (header: Object) => {
  console.info('header: ' + JSON.stringify(header));
});

async function setBaseExtraData(options: Record<string,string|number>){
  let baseExtra: Record<string,string|number> = options || {}
  let time: number = await systemDateTime.getCurrentTime(false)
  baseExtra['timestamps'] = time.toString()
  baseExtra['privateKey'] = "vuPgVevkiM7AnzuyjrKYihIGLmFLfk8Fxc8IX3QJtZJc6UUddutOHCOIebZxCK8L"
  let signForString = "";
  Object.keys(baseExtra)
    .sort((a, b) => a.localeCompare(b))
    .forEach((key) => {
      signForString += `${key}|${baseExtra![key]}|`;
    });
  if (signForString.length > 0) {
    signForString = signForString.substring(0, signForString.length - 1);
  }
  let hash = await MD5.digest(signForString)
  baseExtra['sign'] = hash
  let encodedData = Object.keys(baseExtra)
    .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(baseExtra[key])}`)
    .join('&');
  return encodedData
}
export async function loginFunction(options: Record<string,string|number>) {
  let paramsStr = await setBaseExtraData(options);
  httpRequest.request(// 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
    "https://apipre.rhkj.com/api/user/login",
    {
      method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
      extraData: paramsStr,
      expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      header: {
        'content-Type': 'application/x-www-form-urlencoded'
      },
      readTimeout: 60000, // 可选，默认为60000ms
      connectTimeout: 60000, // 可选，默认为60000ms
    },
    (err: BusinessError, data: http.HttpResponse) => {
      if (!err) {
        // data.result为HTTP响应内容，可根据业务需要进行解析
        console.info('Result:' + JSON.stringify(data.result));
        console.info('code:' + JSON.stringify(data.responseCode));
        console.info('type:' + JSON.stringify(data.resultType));
        // data.header为HTTP响应头，可根据业务需要进行解析
        console.info('header:' + JSON.stringify(data.header));
        console.info('cookies:' + JSON.stringify(data.cookies)); // 自API version 8开始支持cookie
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
        httpRequest.destroy();
      } else {
        console.info('error:' + JSON.stringify(err));
        // 取消订阅HTTP响应头事件
        httpRequest.off('headersReceive');
        // 当该请求使用完毕时，开发者务必调用destroy方法主动销毁该JavaScript Object。
        httpRequest.destroy();
      }
    });

}
