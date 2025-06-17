import { Carousel } from "../components/recommend/Carousel"
import { Category } from "../components/recommend/Category"
import { SearchWidget } from "../components/recommend/Search"
import { Song } from "../components/recommend/Song"
import { TitleWithMore } from "../components/recommend/TitleWithMore"
import { Banner, CategoryInfo, MusicService, CategoryInfoData, SongData } from "../services/MusicService"
import { hilog } from "@kit.PerformanceAnalysisKit"

const TAG = 'Recommend';
const DOMAIN = 0xFF00;

@ComponentV2
// export 导出，别的组件才可以导入去使用
export struct Recommend {

  @Local newSongs: SongData[] = [];
  // = []; CategoryInfoData = new CategoryInfoData();

  @Local banner: Banner[] = []
  @Local songCategories: CategoryInfoData = new CategoryInfoData();

  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.loadNewSongs()
  }
  async loadNewSongs(): Promise<void> {

    try {
      MusicService.getNewSongs().then((songData) => {
        hilog.info(DOMAIN, TAG, `成功加载新歌数据，包含 ${songData.data?.length || 0} 首歌曲`);

        this.banner = songData.banner;
        // this.newSongs.pushDataAll(songData.data)
        this.newSongs = songData.data;
      });


      MusicService.getSongCategories().then((category) => {
        // this.songCategories = category.data.info;
        this.songCategories.pushDataAll(category.data.info);
      })

      // 这里可以根据获取到的数据更新UI状态
      // 例如：this.songList = songData.data;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `加载新歌数据失败: ${error}`);
    }

  }


  build() {

    Scroll() {
      Column() {
        SearchWidget()
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
      .padding({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
  }
}