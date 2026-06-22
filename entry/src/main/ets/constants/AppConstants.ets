export const COLOR_BACKGROUND: string = '#000000';
export const COLOR_CARD: string = '#1A1A1A';
export const COLOR_TEXT_PRIMARY: string = '#FFFFFF';
export const COLOR_TEXT_SECONDARY: string = '#9E9E9E';
export const COLOR_ERROR: string = '#FF5252';
export const COLOR_OK: string = '#4CAF50';
export const COLOR_PENDING: string = '#FFC107';

export const LEVEL_NAMES: string[] = [
  'Low',
  'Normal',
  'Medium',
  'High',
  'Overheated',
  'Warning',
  'Emergency',
  'Escape'
];

export const LEVEL_HINTS: string[] = [
  'Device load is light',
  'Device load is steady',
  'Moderate pressure on resources',
  'High pressure, avoid heavy work',
  'Thermal pressure detected',
  'Reduce workload now',
  'Critical load, stop background work',
  'Extreme load, app may be limited'
];

export const LEVEL_COLORS: string[] = [
  '#4CAF50',
  '#8BC34A',
  '#CDDC39',
  '#FFC107',
  '#FF9800',
  '#FF5722',
  '#F44336',
  '#B71C1C'
];

export const LEVEL_MAX: number = 7;
export const LEVEL_FALLBACK_TEXT: string = 'Unknown';
export const LEVEL_FALLBACK_COLOR: string = '#9E9E9E';

export const CACHE_SCHEME: string = 'https';
export const CACHE_HOST: string = 'www.example.com';
export const CACHE_PATH: string = 'index.html';
export const CACHE_TARGET_URL: string = `${CACHE_SCHEME}://${CACHE_HOST}/${CACHE_PATH}`;
export const MEMORY_CACHE_BYTES: number = 1048576;
export const FILE_CACHE_BYTES: number = 10485760;
export const DOWNLOAD_INFO_LIST_SIZE: number = 16;
export const CACHE_POLL_DELAY_MS: number = 1200;
export const CACHE_POLL_MAX_ATTEMPTS: number = 5;

export const ROUTE_SYSTEM_LOAD: string = 'SystemLoadPage';
export const ROUTE_CACHE: string = 'CachePage';
export const ROUTE_ACCOUNT: string = 'AccountPage';
