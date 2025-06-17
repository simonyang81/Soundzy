import { Carousel } from "../components/recommend/Carousel"
import { Category } from "../components/recommend/Category"
import { SearchWidget } from "../components/recommend/Search"
import { Song } from "../components/recommend/Song"
import { TitleWithMore } from "../components/recommend/TitleWithMore"
import { Banner, MusicService, CategoryInfoData, SongData } from "../services/MusicService"
import { hilog } from "@kit.PerformanceAnalysisKit"

const TAG = 'Recommend';
const DOMAIN = 0xFF00;

@ComponentV2
// export 导出，别的组件才可以导入去使用
export struct Recommend {

  @Local newSongs: SongData[] = [];
  @Local banner: Banner[] = []
  @Local songCategories: CategoryInfoData = new CategoryInfoData();

  @Local isRefreshing: boolean = false;

  // scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.loadData()
  }

  resetData(): void {
    this.newSongs = []
    this.banner = []
    this.songCategories.clearData()
  }

  async loadData(): Promise<void> {

    try {
      MusicService.getNewSongs().then((songData) => {
        hilog.info(DOMAIN, TAG, `成功加载新歌数据，包含 ${songData.data?.length || 0} 首歌曲`);

        this.banner = songData.banner;
        this.newSongs = songData.data;
      });


      MusicService.getSongCategories().then((category) => {
        this.songCategories.pushDataAll(category.data.info);
      })

    } catch (error) {
      hilog.error(DOMAIN, TAG, `加载新歌数据失败: ${error}`);
    } finally {

    }

  }

  build() {

      Column() {
        SearchWidget()
        Refresh({refreshing: $$this.isRefreshing}) {
          Scroll() {
            Column() {
              Carousel({
                banners: this.banner,
              })

              TitleWithMore({title: '新歌榜单'})
              Blank().height(10)
              Song({
                songs: this.newSongs,
              })
              TitleWithMore({title: '星曜榜'})
              Blank().height(10)
              Category({songCategories: this.songCategories})

            }
            .width('100%')
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
        }
          .onRefreshing(() => {
            this.resetData()
            this.loadData()
            this.isRefreshing = false;
          })
          .pullToRefresh(true)

      }
      .width('100%')
      .padding({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      })

  }
}