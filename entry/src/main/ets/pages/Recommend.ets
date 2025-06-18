import { Carousel } from "../components/recommend/Carousel"
import { Category } from "../components/recommend/Category"
import { SearchWidget } from "../components/recommend/Search"
import { Song } from "../components/recommend/Song"
import { TitleWithMore } from "../components/recommend/TitleWithMore"
import { Banner, MusicService, CategoryInfoData, SongData } from "../services/MusicService"
import { hilog } from "@kit.PerformanceAnalysisKit"
import { AppStorageV2, window } from "@kit.ArkUI"
import { CommonUtil } from "../utils/CommonUtil"

const TAG = 'Recommend';
const DOMAIN = 0xFF00;

@ComponentV2
export struct Recommend {

  pathStack : NavPathStack = AppStorageV2.connect(NavPathStack, 'pathStack', () => new NavPathStack())!;

  @Local newSongs: SongData[] = [];
  @Local banner: Banner[] = []
  @Local songCategories: CategoryInfoData = new CategoryInfoData();
  @Local isRefreshing: boolean = false;

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

      MusicService.getCategories().then((category) => {
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
              Category({
                songCategories: this.songCategories,
                onClickEvent: (category) => {
                  hilog.info(DOMAIN, TAG, `-->> 点中的item是${category.rankname}`)
                  this.pathStack.pushPathByName('CategoryList', category, (popInfo) => {
                    hilog.info(DOMAIN, TAG, `popInfo: ${popInfo}`)
                    CommonUtil.setStatusBarTextColor(true);
                  }, true)
                }
              })
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