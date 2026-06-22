import { COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY, LEVEL_MAX } from '../constants/AppConstants';
import { SystemLoadService } from '../services/SystemLoadService';

@Component
export struct ArcGauge {
  @Prop level: number = 0;

  build() {
    Gauge({ value: this.level, min: 0, max: LEVEL_MAX }) {
      Column() {
        Text(`${this.level}`)
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor(COLOR_TEXT_PRIMARY)
        Text(SystemLoadService.levelName(this.level))
          .fontSize(11)
          .fontColor(COLOR_TEXT_SECONDARY)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .startAngle(225)
    .endAngle(135)
    .colors(SystemLoadService.levelColor(this.level))
    .strokeWidth(8)
    .description(null)
    .indicator(null)
    .width(118)
    .height(118)
  }
}
