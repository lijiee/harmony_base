import cryptoFramework from '@ohos.security.cryptoFramework';
import { util } from '@kit.ArkTS';
export class MD5 {
  static async digest(text: String): Promise<string> {
    let md5 = cryptoFramework.createMd("MD5")
    await md5.update({ data: stringToUint8Array(text) })
    let result = await md5.digest()
    return MD5.uint8ArrayToHexStr(result.data);
  }
  static uint8ArrayToHexStr(data: Uint8Array): string {
    let hexString = "";
    let i: number;
    for (i = 0; i < data.length; i++) {
      let char = ('00' + data[i].toString(16)).slice(-2);
      hexString += char;
    }
    return hexString;
  }
}

export class RSA {
  static async encrypt(password: string, publicKey: string): Promise<string | null> {
    let base64 = new util.Base64Helper();
    let data = base64.decodeSync(publicKey);
    let rsaGenerator: cryptoFramework.AsyKeyGenerator;
    rsaGenerator = cryptoFramework.createAsyKeyGenerator("RSA1024|PRIMES_2");
    let cipher = cryptoFramework.createCipher("RSA1024|PKCS1");
    let blob: cryptoFramework.DataBlob = { data: data };
    try {
      let keyPair = await rsaGenerator.convertKey(blob, null)
      let pubKey = keyPair.pubKey;
      await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null)
      let input: cryptoFramework.DataBlob = { data: stringToUint8Array(password) };
      let data = await cipher.doFinal(input)
      return base64.encodeToStringSync(data.data)
    } catch (_) {
      return null
    }
  }
}

function  stringToUint8Array(str: String, len?: number) {
  let arr: number[] = [];
  if (len == null) {
    len = str.length;
  }
  for (let i = 0; i < len; i++) {
    if (str.length > i) {
      arr.push(str.charCodeAt(i));
    }
    else {
      arr.push(0);
    }
  }
  return new Uint8Array(arr);
}
