import { COLOR_CARD, COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY } from '../constants/AppConstants';

@Component
export struct MetricTile {
  @Prop title: string = '';
  @Prop value: string = '';
  @Prop accent: string = COLOR_TEXT_SECONDARY;
  tapAction: () => void = (): void => {
  };

  build() {
    Row() {
      Column({ space: 2 }) {
        Text(this.title)
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .fontColor(COLOR_TEXT_PRIMARY)
        Text(this.value)
          .fontSize(10)
          .fontColor(this.accent)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      Text('›')
        .fontSize(18)
        .fontColor(COLOR_TEXT_SECONDARY)
    }
    .width('100%')
    .padding({ left: 14, right: 14, top: 10, bottom: 10 })
    .borderRadius(18)
    .backgroundColor(COLOR_CARD)
    .onClick(() => {
      this.tapAction();
    })
  }
}
