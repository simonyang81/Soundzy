import { AppStorageV2, window } from "@kit.ArkUI";
import { CommonUtil } from "../utils/CommonUtil";

// 跳转页面的入口函数
@Builder
export function SplashBuilder() {
  Splash();
}

@ComponentV2
struct Splash {

  intervalId: number | null = null;
  @Local timer: number = 5;

  pathStack : NavPathStack = AppStorageV2.connect(NavPathStack, 'pathStack', () => new NavPathStack())!;

  // 生命周期
  aboutToAppear(): void {

    this.intervalId = setInterval(() => {

      console.log('-->> 执行setInterval函数')

      this.timer--;
      if (this.timer <= 0) {
        setTimeout(() => {
          this.pathStack.replacePathByName('Home', null, false);
        }, 50)
      }
    }, 1000)

  }

  aboutToDisappear(): void {
    clearInterval(this.intervalId)
  }

  build() {

    NavDestination() {

      Stack({
        alignContent: Alignment.TopEnd,
      }) {
        Image($r('app.media.bg'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        Button(`跳过 ${this.timer}秒`)
          .backgroundColor(Color.Gray)
          .margin({
            top: 35,
            right: 15
          })
          .onClick(() => {
            this.pathStack.replacePathByName('Home', null, false);
          })
      }

    }
    // .title('广告页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
    .onAppear(() => {
      CommonUtil.setStatusBarTextColor(false)
    })

  }
}