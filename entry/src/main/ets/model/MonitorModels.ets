export interface CacheReport {
  resourceSizeBytes: number;
  dnsTimeMs: number;
  connectTimeMs: number;
  tlsTimeMs: number;
  totalTimeMs: number;
}

export function emptyCacheReport(): CacheReport {
  const report: CacheReport = {
    resourceSizeBytes: 0,
    dnsTimeMs: 0,
    connectTimeMs: 0,
    tlsTimeMs: 0,
    totalTimeMs: 0
  };
  return report;
}

export interface AccountSnapshot {
  available: boolean;
  name: string;
  id: string;
  loggedIn: boolean;
  message: string;
}

export function emptyAccountSnapshot(): AccountSnapshot {
  const snapshot: AccountSnapshot = {
    available: false,
    name: '',
    id: '',
    loggedIn: false,
    message: ''
  };
  return snapshot;
}
