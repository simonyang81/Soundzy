import { BaseService } from "../services/BaseService";
import { Discover } from "./Discover";
import { Dynamic } from "./Dynamic";
import { Mine } from "./Mine";
import { Recommend } from "./Recommend";

interface TabClass {
  text: string,
  icon: ResourceStr,
}


// 跳转页面的入口函数
@Builder
export function HomeBuilder() {
  Home();
}

@ComponentV2
struct Home {

  @Local currentTabIndex: number = 0;

  // 控制跳转的对象
  pathStack: NavPathStack = new NavPathStack();

  tabData: TabClass[] = [
    {text: '推荐', icon: $r('app.media.ic_recommend')},
    {text: '发现', icon: $r('app.media.ic_discover')},
    {text: '动态', icon: $r('app.media.ic_dynamic')},
    {text: '我的', icon: $r('app.media.ic_mine')},
  ]

  @Builder
  tabBuilder(item: TabClass, tabIndex: number) {
    Column({
      space: 5,
    }) {
      Image(item.icon).width(28)
        .fillColor(this.currentTabIndex === tabIndex ? '#E85A88' : '#63AAAA')
      Text(item.text).fontSize(14)
        .fontColor(this.currentTabIndex === tabIndex ? '#E85A88' : '#63AAAA')
    }
  }

  aboutToAppear(): void {
    BaseService.initialize();
  }

  build() {

    NavDestination() {

      Tabs({
        barPosition: BarPosition.End
      }) {

        ForEach(this.tabData, (item: TabClass, index: number) => {
          TabContent() {

            if (index === 0) {
              Recommend()
            } else if (index === 1) {
              Discover()
            } else if (index === 2) {
              Dynamic()
            } else {
              Mine()
            }
          }
          .tabBar(this.tabBuilder(item, index))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        })

      }
      .backgroundColor('#FFF2F3F5')
      .onChange((index: number) => {
        this.currentTabIndex = index
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })

  }
}