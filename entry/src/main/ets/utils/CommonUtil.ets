import { window } from "@kit.ArkUI";

export class CommonUtil {
  static setStatusBarTextColor(isDark: boolean): void {
    window.getLastWindow(getContext()).then((windowInstance) => {
      windowInstance.setWindowSystemBarProperties({
        statusBarContentColor: isDark ? '#FF000000' : '#FFFFFFFF'
      });
    })
  }
}