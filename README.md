> **Note:** To access all shared projects, get information about environment setup, and view other guides, please visit [Explore-In-HMOS-Wearable Index](https://github.com/Explore-In-HMOS-Wearable/hmos-index).

# How To Build System Monitor

**How To Build System Monitor** is a HarmonyOS wearable codelab that builds a compact developer health dashboard for the watch. It shows the current system load level on a circular gauge, manages a background cache preload, and inspects the distributed account sync status together with the device channel configuration.

Developers learn how to query and observe `systemLoad` levels, drive `cacheDownload` preloads and read their download info, query `distributedAccount` state with a runtime permission flow, and read `customConfig` channel values.

# Preview

<div align="center">
  <img src="screenshots/1.png" width="24%" />
  <img src="screenshots/2.png" width="24%" />
  <img src="screenshots/3.png" width="24%" />
  <img src="screenshots/4.png" width="24%" />
</div>

# Use Cases

- **System load awareness:** Read the combined system load level and watch live level changes to decide when the app should defer heavy work.
- **Cache preloading:** Submit a background cache download, cancel it, and inspect size and timing details of the cached resource.
- **Account and device inspection:** Check whether the distributed account is logged in and read the device-specific channel configuration value.

# Technology

## Stack

- **Languages**: ArkTS, ArkUI
- **Frameworks**: HarmonyOS SDK 6.0.1
- **Tools**: DevEco Studio NEXT
- **Libraries**:
  - `@kit.BasicServicesKit` (`systemLoad`, `cacheDownload`, `distributedAccount`, `customConfig`)
  - `@kit.AbilityKit` (`abilityAccessCtrl`, `common`)

## Required Permissions

- `ohos.permission.INTERNET`
  > Required by `cacheDownload.download()` to fetch the demo asset into the request cache.
- `ohos.permission.GET_NETWORK_INFO`
  > Required by `cacheDownload.getDownloadInfo()` to read size and timing details of a cached download.
- `ohos.permission.DISTRIBUTED_DATASYNC`
  > Required by `distributedAccount.getOsAccountDistributedInfo()`; requested at runtime before the account query.

# Directory Structure

```text
entry/src/main/ets/
├── components/
│   ├── ArcGauge.ets             # Circular gauge for the system load level
│   ├── KeyValueRow.ets          # Label and value row used in detail cards
│   ├── MetricTile.ets           # Dashboard tile that opens a detail page
│   └── StatusBadge.ets          # Colored capsule showing a short status
├── constants/
│   └── AppConstants.ets         # Colors, level metadata, cache and route constants
├── entryability/
│   └── EntryAbility.ets
├── entrybackupability/
│   └── EntryBackupAbility.ets
├── model/
│   └── MonitorModels.ets        # Cache report and account snapshot models
├── pages/
│   ├── Index.ets                # Dashboard with gauge, tiles and navigation root
│   ├── SystemLoadPage.ets       # Load level detail with live updates toggle
│   ├── CachePage.ets            # Cache preload, cancel and download info
│   └── AccountPage.ets          # Account sync status and channel configuration
└── services/
    ├── SystemLoadService.ets    # systemLoad query and change listener wrapper
    ├── CacheDownloadService.ets # cacheDownload operations and info mapping
    ├── AccountService.ets       # Permission request and account query
    └── ConfigService.ets        # customConfig channel id reader
```

# Constraints and Restrictions

## Supported Devices

- Huawei Watch 5
- DevEco Studio Simulator

The distributed account query needs `ohos.permission.DISTRIBUTED_DATASYNC` to be granted at runtime; when the user denies it, the account page shows a permission-denied state. Cache download info is kept in memory by the system and is cleared when the application exits.

# License

**How To Build System Monitor** is distributed under the terms of the MIT License.
See the [LICENSE](/LICENSE) for more information.
