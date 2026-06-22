import { common } from '@kit.AbilityKit';
import { KeyValueRow } from '../components/KeyValueRow';
import { StatusBadge } from '../components/StatusBadge';
import {
  COLOR_BACKGROUND,
  COLOR_CARD,
  COLOR_ERROR,
  COLOR_OK,
  COLOR_TEXT_PRIMARY,
  COLOR_TEXT_SECONDARY
} from '../constants/AppConstants';
import { AccountSnapshot, emptyAccountSnapshot } from '../model/MonitorModels';
import { AccountService } from '../services/AccountService';
import { ConfigService } from '../services/ConfigService';

const ID_PREVIEW_LENGTH: number = 10;

@Component
export struct AccountPage {
  @State snapshot: AccountSnapshot = emptyAccountSnapshot();
  @State queried: boolean = false;
  @State busy: boolean = false;
  @State channelId: string = '';

  aboutToAppear(): void {
    this.channelId = ConfigService.getChannelId();
  }

  private async queryAccount(): Promise<void> {
    if (this.busy) {
      return;
    }
    this.busy = true;
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const granted = await AccountService.requestSyncPermission(context);
    if (!granted) {
      const denied: AccountSnapshot = {
        available: false,
        name: '',
        id: '',
        loggedIn: false,
        message: 'Permission request was denied'
      };
      this.snapshot = denied;
      this.queried = true;
      this.busy = false;
      return;
    }
    this.snapshot = await AccountService.fetchSnapshot();
    this.queried = true;
    this.busy = false;
  }

  private displayName(): string {
    if (this.snapshot.name === '') {
      return 'Unknown';
    }
    return this.snapshot.name;
  }

  private displayId(): string {
    const id = this.snapshot.id;
    if (id === '') {
      return 'Unknown';
    }
    if (id.length > ID_PREVIEW_LENGTH) {
      return `${id.substring(0, ID_PREVIEW_LENGTH)}...`;
    }
    return id;
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 8 }) {
          Text('Account & Config')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(COLOR_TEXT_PRIMARY)
            .margin({ top: 8 })
          Text('Distributed account sync state')
            .fontSize(10)
            .fontColor(COLOR_TEXT_SECONDARY)
            .textAlign(TextAlign.Center)
          Button(this.busy ? 'Querying...' : 'Query Account')
            .fontSize(12)
            .height(32)
            .width('80%')
            .enabled(!this.busy)
            .onClick(() => {
              this.queryAccount();
            })
          if (this.queried && this.snapshot.available) {
            StatusBadge({
              label: this.snapshot.loggedIn ? 'Logged in' : 'Not logged in',
              tint: this.snapshot.loggedIn ? COLOR_OK : COLOR_TEXT_SECONDARY
            })
            Column({ space: 4 }) {
              KeyValueRow({ label: 'Name', value: this.displayName() })
              KeyValueRow({ label: 'ID', value: this.displayId() })
            }
            .width('100%')
            .padding(10)
            .borderRadius(14)
            .backgroundColor(COLOR_CARD)
          }
          if (this.queried && !this.snapshot.available) {
            Text(this.snapshot.message)
              .fontSize(10)
              .fontColor(COLOR_ERROR)
              .textAlign(TextAlign.Center)
          }
          Divider()
            .color(COLOR_CARD)
            .width('80%')
          Text('Device Channel')
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(COLOR_TEXT_PRIMARY)
          Text(this.channelId === '' ? 'No channel id configured' : this.channelId)
            .fontSize(10)
            .fontColor(COLOR_TEXT_SECONDARY)
            .textAlign(TextAlign.Center)
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
