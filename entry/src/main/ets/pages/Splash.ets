// 跳转页面的入口函数
@Builder
export function SplashBuilder() {
  Splash();
}

@ComponentV2
struct Splash {

  intervalId: number | null = null;

  // 控制跳转的对象
  pathStack: NavPathStack = new NavPathStack();

  @Local timer: number = 5;

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
            top: 15,
            right: 15
          })
          .onClick(() => {
            this.pathStack.replacePathByName('Home', null, false);
          })
      }

      // Button('跳转到Home页面')
      //   .onClick(() => {
      //     this.pathStack.pushPathByName("Home", null, true);
      //   })
    }
    // .title('广告页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })

  }
}