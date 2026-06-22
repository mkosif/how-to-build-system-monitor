import { COLOR_BACKGROUND, COLOR_TEXT_SECONDARY } from '../constants/AppConstants';

@Component
export struct StatusBadge {
  @Prop label: string = '';
  @Prop tint: string = COLOR_TEXT_SECONDARY;

  build() {
    Text(this.label)
      .fontSize(11)
      .fontWeight(FontWeight.Medium)
      .fontColor(COLOR_BACKGROUND)
      .backgroundColor(this.tint)
      .padding({ left: 12, right: 12, top: 4, bottom: 4 })
      .borderRadius(12)
  }
}
