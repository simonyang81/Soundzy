import { CategoryInfo, MusicService, SongByCategoryDataInfo } from "../services/MusicService";
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { CommonUtil } from "../utils/CommonUtil";

const TAG = 'CategoryList';
const DOMAIN = 0xFF00;

// 跳转页面的入口函数
@Builder
export function CategoryListBuilder() {
  CategoryList();
}

@ComponentV2
struct CategoryList {

  pathStack: NavPathStack | undefined = undefined;
  category: CategoryInfo | undefined = undefined;

  @Local songs: SongByCategoryDataInfo[] = [];
  @Local scrollY: number = 0; // 滚动偏移量
  @Local headerHeight: number = 300; // 动态头部高度
  @Local headerOpacity: number = 1; // 头部透明度
  @Local titleOpacity: number = 0; // 标题透明度

  private scroller: Scroller = new Scroller();
  private readonly HEADER_HEIGHT = 300; // 固定头部高度
  private readonly MIN_HEADER_HEIGHT = 100; // 最小头部高度

  /**
   * 加载分类音乐数据
   */
  loadData(): void {
    if (this.category) {
      MusicService.getSongs(this.category.rankid).then((response) => {
        this.songs = response.data.info;
        hilog.info(DOMAIN, TAG, `Loaded ${this.songs.length} songs`);
      })
    }
  }

  /**
   * 计算滚动相关属性
   */
  private calculateScrollEffect(scrollY: number): void {
    // 平滑的透明度计算 - 从开始滚动就开始变化
    const fadeDistance = this.HEADER_HEIGHT * 0.6; // 在60%的滚动距离内完成淡出
    this.headerOpacity = Math.max(0, 1 - (scrollY / fadeDistance));

    // 头部高度计算 - 视差效果
    // const shrinkRatio = Math.min(1, scrollY / this.HEADER_HEIGHT);
    this.headerHeight = Math.max(this.MIN_HEADER_HEIGHT, this.HEADER_HEIGHT - scrollY * 0.5);

    // 标题透明度 - 当头部收缩到一定程度时显示
    const titleShowThreshold = this.HEADER_HEIGHT * 0.7;
    this.titleOpacity = scrollY > titleShowThreshold ?
      Math.min(1, (scrollY - titleShowThreshold) / (this.HEADER_HEIGHT * 0.3)) : 0;

    CommonUtil.setStatusBarTextColor(this.headerOpacity < 0.4);
  }

  /**
   * 组件即将出现时初始化
   */
  onPageShow(): void {
    this.loadData();
    CommonUtil.setStatusBarTextColor(false);
  }

  /**
   * 构建头部背景图片
   */
  @Builder
  buildHeaderImage() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景图片
      Image(this.category?.album_img_9.replace('{size}', '1024') || '')
        .width('100%')
        .height(this.headerHeight)
        .objectFit(ImageFit.Cover)
        .opacity(this.headerOpacity)
        .animation({
          duration: 150,
          curve: Curve.Linear
        })

      // 渐变遮罩
      Column()
        .width('100%')
        .height(this.headerHeight)
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [
            [0x60000000, 0.0],
            [0x80000000, 0.8],
            [0xA0000000, 1.0]
          ]
        })
        .opacity(this.headerOpacity)
        .animation({
          duration: 150,
          curve: Curve.Linear
        })

      // 顶部导航栏
      Row() {
        // 返回按钮
        Button() {
          Image($r('sys.media.ohos_ic_back'))
            .width(24)
            .height(24)
            .fillColor(Color.Black)
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.pathStack?.pop();
        })

        Blank()

        // 标题 - 只有透明度变化，按钮不变
        Text(this.category?.rankname || '')
          .fontSize(18)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
          .opacity(this.titleOpacity)
          .animation({
            duration: 200,
            curve: Curve.EaseInOut
          })

        Blank()

        // 更多按钮
        Button() {
          Image($r('sys.media.ohos_ic_public_more'))
            .width(24)
            .height(24)
            .fillColor(Color.Black)
        }
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
      }
      .width('100%')
      .height(80)
      .padding({ left: 16, right: 16, top: 44 }) // 状态栏高度
      .zIndex(10)
    }
  }

  /**
   * 构建歌曲列表
   */
  @Builder
  buildSongList() {
    List({ scroller: this.scroller }) {
      ForEach(this.songs, (song: SongByCategoryDataInfo, index: number) => {
        ListItem() {
          Row() {
            // 歌曲封面
            Image(song.album_sizable_cover.replace('{size}', '1024') || '')
              .width(50)
              .height(50)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)

            Column({ space: 4 }) {
              // 歌曲名称
              Text(song.songname)
                .fontSize(16)
                .fontColor('#FF333333')
                .fontWeight(FontWeight.Medium)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              // 歌手名称
              Text(song.authors[0].author_name)
                .fontSize(14)
                .fontColor('#FF666666')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
            .margin({ left: 12 })

            // 更多按钮
            Button() {
              Image($r('sys.media.ohos_ic_public_more'))
                .width(20)
                .height(20)
                .fillColor('#FF999999')
            }
            .width(32)
            .height(32)
            .backgroundColor(Color.Transparent)
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        }
      })
    }
    .width('100%')
    .layoutWeight(1)
    .backgroundColor(Color.White)
    .borderRadius({
      topLeft: 0, // 移除左上圆角
      topRight: 0, // 移除右上圆角
      bottomLeft: 0,
      bottomRight: 0
    })
    .padding({ top: 16 })
    .onScroll((scrollOffset: number, scrollState: ScrollState) => {
      // 实时更新滚动位置
      this.scrollY = this.scroller.currentOffset().yOffset;
      this.calculateScrollEffect(this.scrollY);
    })
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      // 保持滚动的原始行为，不做额外处理
      return { offsetRemain: offset };
    })
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        // 头部背景图片
        this.buildHeaderImage()

        // 歌曲列表 - 添加顶部边距让它从图片下方开始
        Column() {
          Blank()
            .height(this.headerHeight - 20) // 让列表从图片底部稍微上移一点

          this.buildSongList()
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFF5F5F5')
    }
    .title('')
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
      this.category = context.pathInfo.param as CategoryInfo;
    })
    .onAppear(() => {
      this.onPageShow();
    })
  }
}