import { BusinessError, cacheDownload } from '@kit.BasicServicesKit';
import { DOWNLOAD_INFO_LIST_SIZE, FILE_CACHE_BYTES, MEMORY_CACHE_BYTES } from '../constants/AppConstants';
import { CacheReport } from '../model/MonitorModels';

export class CacheDownloadService {
  static configureCache(): boolean {
    try {
      cacheDownload.setMemoryCacheSize(MEMORY_CACHE_BYTES);
      cacheDownload.setFileCacheSize(FILE_CACHE_BYTES);
      cacheDownload.setDownloadInfoListSize(DOWNLOAD_INFO_LIST_SIZE);
      return true;
    } catch (err) {
      return false;
    }
  }

  static startDownload(url: string): string {
    try {
      const options: cacheDownload.CacheDownloadOptions = {};
      cacheDownload.download(url, options);
      return '';
    } catch (err) {
      const error = err as BusinessError;
      return `Download request failed (code ${error.code})`;
    }
  }

  static cancelDownload(url: string): string {
    try {
      cacheDownload.cancel(url);
      return '';
    } catch (err) {
      const error = err as BusinessError;
      return `Cancel request failed (code ${error.code})`;
    }
  }

  static queryReport(url: string): CacheReport | undefined {
    try {
      const info = cacheDownload.getDownloadInfo(url);
      if (info === undefined) {
        return undefined;
      }
      const report: CacheReport = {
        resourceSizeBytes: info.resource.size,
        dnsTimeMs: info.performance.dnsTime,
        connectTimeMs: info.performance.connectTime,
        tlsTimeMs: info.performance.tlsTime,
        totalTimeMs: info.performance.totalTime
      };
      return report;
    } catch (err) {
      return undefined;
    }
  }
}
