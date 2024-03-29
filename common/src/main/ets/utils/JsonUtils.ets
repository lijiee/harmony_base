import { CommonType } from '../common/TypeAlias';
export class JsonUtils {
  private constructor() {
  }

  static stringify(data: CommonType, space: number = 2): string {
    return JSON.stringify(data, null, space);
  }

  static parse(jsonString: string): CommonType {
    return JSON.parse(jsonString);
  }
}