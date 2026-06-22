import { COLOR_TEXT_PRIMARY, COLOR_TEXT_SECONDARY } from '../constants/AppConstants';

@Component
export struct KeyValueRow {
  @Prop label: string = '';
  @Prop value: string = '';

  build() {
    Row() {
      Text(this.label)
        .fontSize(10)
        .fontColor(COLOR_TEXT_SECONDARY)
        .layoutWeight(1)
      Text(this.value)
        .fontSize(10)
        .fontColor(COLOR_TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
  }
}
