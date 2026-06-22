import { BusinessError, distributedAccount } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { AccountSnapshot } from '../model/MonitorModels';

const SYNC_PERMISSION: Permissions = 'ohos.permission.DISTRIBUTED_DATASYNC';
const PERMISSION_DENIED_CODE: number = 201;

export class AccountService {
  static async requestSyncPermission(context: common.UIAbilityContext): Promise<boolean> {
    const manager = abilityAccessCtrl.createAtManager();
    try {
      const response = await manager.requestPermissionsFromUser(context, [SYNC_PERMISSION]);
      const results = response.authResults;
      let granted = results.length > 0;
      for (const result of results) {
        if (result !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          granted = false;
        }
      }
      return granted;
    } catch (err) {
      return false;
    }
  }

  static async fetchSnapshot(): Promise<AccountSnapshot> {
    try {
      const ability = distributedAccount.getDistributedAccountAbility();
      const info = await ability.getOsAccountDistributedInfo();
      const loggedIn = info.status === distributedAccount.DistributedAccountStatus.LOGGED_IN;
      const snapshot: AccountSnapshot = {
        available: true,
        name: info.name,
        id: info.id,
        loggedIn: loggedIn,
        message: ''
      };
      return snapshot;
    } catch (err) {
      const error = err as BusinessError;
      const failure: AccountSnapshot = {
        available: false,
        name: '',
        id: '',
        loggedIn: false,
        message: AccountService.describeError(error.code)
      };
      return failure;
    }
  }

  private static describeError(code: number): string {
    if (code === PERMISSION_DENIED_CODE) {
      return 'Permission denied for distributed account query';
    }
    return `Account query failed (code ${code})`;
  }
}
