import { customConfig } from '@kit.BasicServicesKit';

export class ConfigService {
  static getChannelId(): string {
    try {
      return customConfig.getChannelId();
    } catch (err) {
      return '';
    }
  }
}
