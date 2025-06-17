import { AppStorageV2 } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {

  pathStack : NavPathStack = AppStorageV2.connect(NavPathStack, 'pathStack', () => new NavPathStack())!;

  build() {
    Navigation(this.pathStack) {
    }.onAppear(() => {
      this.pathStack.pushPathByName("Splash", null, false);
    })
    .hideNavBar(true) // 不会把自己放到控制跳转的对象里面 -> 点返回的时候不会返回到这个导航页
  }
}