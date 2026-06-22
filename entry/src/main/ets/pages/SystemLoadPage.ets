import { systemLoad } from '@kit.BasicServicesKit';
import { ArcGauge } from '../components/ArcGauge';
import { StatusBadge } from '../components/StatusBadge';
import {
  COLOR_BACKGROUND,
  COLOR_ERROR,
  COLOR_TEXT_PRIMARY,
  COLOR_TEXT_SECONDARY
} from '../constants/AppConstants';
import { SystemLoadService } from '../services/SystemLoadService';

@Component
export struct SystemLoadPage {
  @State level: number = systemLoad.SystemLoadLevel.LOW;
  @State liveUpdates: boolean = false;
  @State errorText: string = '';
  private readonly listener: (level: systemLoad.SystemLoadLevel) => void =
    (level: systemLoad.SystemLoadLevel): void => {
      this.level = level;
    };

  aboutToAppear(): void {
    this.refresh();
  }

  aboutToDisappear(): void {
    if (this.liveUpdates) {
      SystemLoadService.stopWatch(this.listener);
    }
  }

  private refresh(): void {
    SystemLoadService.getLevel().then((level: systemLoad.SystemLoadLevel) => {
      this.level = level;
      this.errorText = '';
    }).catch((): void => {
      this.errorText = 'Unable to read system load level';
    });
  }

  private toggleLive(enabled: boolean): void {
    if (enabled) {
      const started = SystemLoadService.startWatch(this.listener);
      this.liveUpdates = started;
      this.errorText = started ? '' : 'Unable to start live updates';
      return;
    }
    SystemLoadService.stopWatch(this.listener);
    this.liveUpdates = false;
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 8 }) {
          Text('System Load')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
            .margin({ top: 8 })
          ArcGauge({ level: this.level })
          StatusBadge({
            label: SystemLoadService.levelName(this.level),
            tint: SystemLoadService.levelColor(this.level)
          })
          Text(SystemLoadService.levelHint(this.level))
            .fontSize(10)
            .fontColor(COLOR_TEXT_SECONDARY)
            .textAlign(TextAlign.Center)
          Button('Refresh')
            .fontSize(12)
            .height(32)
            .width('80%')
            .onClick(() => {
              this.refresh();
            })
          Row() {
            Text('Live updates')
              .fontSize(11)
              .fontColor(COLOR_TEXT_PRIMARY)
              .layoutWeight(1)
            Toggle({ type: ToggleType.Switch, isOn: this.liveUpdates })
              .onChange((isOn: boolean) => {
                this.toggleLive(isOn);
              })
          }
          .width('80%')
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
