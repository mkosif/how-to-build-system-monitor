import { systemLoad } from '@kit.BasicServicesKit';
import { ArcGauge } from '../components/ArcGauge';
import { MetricTile } from '../components/MetricTile';
import {
  COLOR_BACKGROUND,
  COLOR_TEXT_PRIMARY,
  COLOR_TEXT_SECONDARY,
  ROUTE_ACCOUNT,
  ROUTE_CACHE,
  ROUTE_SYSTEM_LOAD
} from '../constants/AppConstants';
import { CacheDownloadService } from '../services/CacheDownloadService';
import { SystemLoadService } from '../services/SystemLoadService';
import { AccountPage } from './AccountPage';
import { CachePage } from './CachePage';
import { SystemLoadPage } from './SystemLoadPage';

@Entry
@Component
struct Index {
  @Provide('pathStack') pathStack: NavPathStack = new NavPathStack();
  @State loadLevel: number = systemLoad.SystemLoadLevel.LOW;
  private readonly loadListener: (level: systemLoad.SystemLoadLevel) => void =
    (level: systemLoad.SystemLoadLevel): void => {
      this.loadLevel = level;
    };

  aboutToAppear(): void {
    CacheDownloadService.configureCache();
    this.refreshLevel();
    SystemLoadService.startWatch(this.loadListener);
  }

  aboutToDisappear(): void {
    SystemLoadService.stopWatch(this.loadListener);
  }

  private refreshLevel(): void {
    SystemLoadService.getLevel().then((level: systemLoad.SystemLoadLevel) => {
      this.loadLevel = level;
    }).catch((): void => {
    });
  }

  @Builder
  pageMap(name: string) {
    if (name === ROUTE_SYSTEM_LOAD) {
      SystemLoadPage()
    } else if (name === ROUTE_CACHE) {
      CachePage()
    } else if (name === ROUTE_ACCOUNT) {
      AccountPage()
    }
  }

  build() {
    Navigation(this.pathStack) {
      Scroll() {
        Column({ space: 8 }) {
          Text('System Monitor')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
            .margin({ top: 8 })
          Text('Watch health overview')
            .fontSize(10)
            .fontColor(COLOR_TEXT_SECONDARY)
          ArcGauge({ level: this.loadLevel })
          MetricTile({
            title: 'System Load',
            value: SystemLoadService.levelName(this.loadLevel),
            accent: SystemLoadService.levelColor(this.loadLevel),
            tapAction: (): void => {
              this.pathStack.pushPathByName(ROUTE_SYSTEM_LOAD, null);
            }
          })
          MetricTile({
            title: 'Cache Preload',
            value: 'Manage background cache',
            tapAction: (): void => {
              this.pathStack.pushPathByName(ROUTE_CACHE, null);
            }
          })
          MetricTile({
            title: 'Account & Config',
            value: 'Sync status and channel',
            tapAction: (): void => {
              this.pathStack.pushPathByName(ROUTE_ACCOUNT, null);
            }
          })
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 24, bottom: 36 })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.pageMap)
    .backgroundColor(COLOR_BACKGROUND)
    .width('100%')
    .height('100%')
  }
}
