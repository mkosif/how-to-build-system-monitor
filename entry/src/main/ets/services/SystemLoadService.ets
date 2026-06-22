import { systemLoad } from '@kit.BasicServicesKit';
import {
  LEVEL_COLORS,
  LEVEL_FALLBACK_COLOR,
  LEVEL_FALLBACK_TEXT,
  LEVEL_HINTS,
  LEVEL_NAMES
} from '../constants/AppConstants';

export class SystemLoadService {
  static getLevel(): Promise<systemLoad.SystemLoadLevel> {
    return systemLoad.getLevel();
  }

  static startWatch(listener: (level: systemLoad.SystemLoadLevel) => void): boolean {
    try {
      systemLoad.on('systemLoadChange', listener);
      return true;
    } catch (err) {
      return false;
    }
  }

  static stopWatch(listener: (level: systemLoad.SystemLoadLevel) => void): void {
    try {
      systemLoad.off('systemLoadChange', listener);
    } catch (err) {
      // The listener may already be unregistered, which is safe to ignore.
    }
  }

  static levelName(level: number): string {
    return SystemLoadService.pick(LEVEL_NAMES, level, LEVEL_FALLBACK_TEXT);
  }

  static levelHint(level: number): string {
    return SystemLoadService.pick(LEVEL_HINTS, level, LEVEL_FALLBACK_TEXT);
  }

  static levelColor(level: number): string {
    return SystemLoadService.pick(LEVEL_COLORS, level, LEVEL_FALLBACK_COLOR);
  }

  private static pick(source: string[], level: number, fallback: string): string {
    if (level < 0 || level >= source.length) {
      return fallback;
    }
    return source[level];
  }
}
