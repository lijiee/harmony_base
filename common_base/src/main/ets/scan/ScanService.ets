import Url from '@ohos.url'
export interface ScanService {
  content?: string

  regRex(content: string): boolean

  handleSplitParam(): Record<string, string>
}

export class ScanServiceManager {
  private static instance: ScanServiceManager | null = null; // 静态属性用于存储单例实例

  private constructor() {
  } // 私有构造函数，防止外部直接实例化

  static getInstance(): ScanServiceManager {
    if (!ScanServiceManager.instance) {
      ScanServiceManager.instance = new ScanServiceManager();
    }
    return ScanServiceManager.instance;
  }

  addService(services: Array<ScanService>) {
    this.services = services;
  }

  private services: Array<ScanService> = []

  // 定义一个函数，根据 content 是否包含匹配的字符串来返回对应的 ScanService 实例

  getServiceByContent(content: string): Record<string, string> | undefined {
    let item = this.services.find((it) => {
      return it.regRex(content)
    })
    return item?.handleSplitParam(); // 如果没有匹配的字符串，则返回 undefined
  }
}

export class PreachScanService implements ScanService {
  content?: string

  regRex(content: string): boolean {
    this.content = content;
    return content.includes('preachId') || content.includes('mid')
  }

  handleSplitParam(): Record<string, string> {
    let urlObject = Url.URL.parseURL(this.content);
    let objectParams = new Url.URLParams(urlObject.search);
    return { "preachId": objectParams.get('preachId') ?? objectParams.get('mid') ?? '' }
  }
}

export class ClassScanService implements ScanService {
  content?: string

  regRex(content: string): boolean {
    this.content = content;
    return content.includes('classId')
  }

  handleSplitParam(): Record<string, string> {
    let urlObject = Url.URL.parseURL(this.content);
    let objectParams = new Url.URLParams(urlObject.search);
    return { "classId": objectParams.get('classId') ?? '' }
  }
}
