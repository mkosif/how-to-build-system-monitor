import { KeyValueRow } from '../components/KeyValueRow';
import { StatusBadge } from '../components/StatusBadge';
import {
  CACHE_POLL_DELAY_MS,
  CACHE_POLL_MAX_ATTEMPTS,
  CACHE_TARGET_URL,
  COLOR_BACKGROUND,
  COLOR_CARD,
  COLOR_ERROR,
  COLOR_OK,
  COLOR_PENDING,
  COLOR_TEXT_PRIMARY,
  COLOR_TEXT_SECONDARY
} from '../constants/AppConstants';
import { CacheReport, emptyCacheReport } from '../model/MonitorModels';
import { CacheDownloadService } from '../services/CacheDownloadService';

const BYTES_PER_KILOBYTE: number = 1024;

@Component
export struct CachePage {
  @State stage: string = 'Idle';
  @State stageTint: string = COLOR_TEXT_SECONDARY;
  @State report: CacheReport = emptyCacheReport();
  @State hasReport: boolean = false;
  @State errorText: string = '';
  private pollAttempts: number = 0;

  aboutToAppear(): void {
    this.checkInfo('Cached');
  }

  private startPreload(): void {
    const failure = CacheDownloadService.startDownload(CACHE_TARGET_URL);
    if (failure !== '') {
      this.errorText = failure;
      return;
    }
    this.errorText = '';
    this.stage = 'Requested';
    this.stageTint = COLOR_PENDING;
    this.pollAttempts = 0;
    this.schedulePoll();
  }

  private cancelPreload(): void {
    const failure = CacheDownloadService.cancelDownload(CACHE_TARGET_URL);
    if (failure !== '') {
      this.errorText = failure;
      return;
    }
    this.errorText = '';
    this.stage = 'Cancel requested';
    this.stageTint = COLOR_TEXT_SECONDARY;
  }

  private schedulePoll(): void {
    setTimeout(() => {
      this.pollInfo();
    }, CACHE_POLL_DELAY_MS);
  }

  private pollInfo(): void {
    if (this.checkInfo('Cached')) {
      return;
    }
    this.pollAttempts += 1;
    if (this.pollAttempts < CACHE_POLL_MAX_ATTEMPTS) {
      this.schedulePoll();
      return;
    }
    this.stage = 'No download info yet';
    this.stageTint = COLOR_TEXT_SECONDARY;
  }

  private refreshInfo(): void {
    if (!this.checkInfo('Cached')) {
      this.stage = 'No download info yet';
      this.stageTint = COLOR_TEXT_SECONDARY;
    }
  }

  private checkInfo(stageText: string): boolean {
    const report = CacheDownloadService.queryReport(CACHE_TARGET_URL);
    if (report === undefined) {
      return false;
    }
    this.report = report;
    this.hasReport = true;
    this.stage = stageText;
    this.stageTint = COLOR_OK;
    return true;
  }

  private formatSize(bytes: number): string {
    if (bytes >= BYTES_PER_KILOBYTE) {
      return `${(bytes / BYTES_PER_KILOBYTE).toFixed(1)} KB`;
    }
    return `${bytes} B`;
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 8 }) {
          Text('Cache Preload')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
            .margin({ top: 8 })
          StatusBadge({ label: this.stage, tint: this.stageTint })
          Text('Preloads a small web asset into the request cache')
            .fontSize(10)
            .fontColor(COLOR_TEXT_SECONDARY)
            .textAlign(TextAlign.Center)
          Button('Preload Asset')
            .fontSize(12)
            .height(32)
            .width('80%')
            .onClick(() => {
              this.startPreload();
            })
          Button('Cancel')
            .fontSize(12)
            .height(32)
            .width('80%')
            .backgroundColor(COLOR_CARD)
            .onClick(() => {
              this.cancelPreload();
            })
          Button('Refresh Info')
            .fontSize(12)
            .height(32)
            .width('80%')
            .backgroundColor(COLOR_CARD)
            .onClick(() => {
              this.refreshInfo();
            })
          if (this.hasReport) {
            Column({ space: 4 }) {
              KeyValueRow({ label: 'Size', value: this.formatSize(this.report.resourceSizeBytes) })
              KeyValueRow({ label: 'DNS', value: `${Math.round(this.report.dnsTimeMs)} ms` })
              KeyValueRow({ label: 'Connect', value: `${Math.round(this.report.connectTimeMs)} ms` })
              KeyValueRow({ label: 'TLS', value: `${Math.round(this.report.tlsTimeMs)} ms` })
              KeyValueRow({ label: 'Total', value: `${Math.round(this.report.totalTimeMs)} ms` })
            }
            .width('100%')
            .padding(10)
            .borderRadius(14)
            .backgroundColor(COLOR_CARD)
          }
          if (this.errorText !== '') {
            Text(this.errorText)
              .fontSize(10)
              .fontColor(COLOR_ERROR)
              .textAlign(TextAlign.Center)
          }
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 24, bottom: 36 })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor(COLOR_BACKGROUND)
  }
}
