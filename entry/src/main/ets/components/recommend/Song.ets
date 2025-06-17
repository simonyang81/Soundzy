import { SongData } from "../../services/MusicService";

const TAG = 'Song';
const DOMAIN = 0xFF00;

@ComponentV2
export struct Song {

  @Param @Require songs: SongData[];

  build() {
    List() {

      ForEach(this.songs, (item: SongData) => {

        ListItem() {
          Column({space: 5}) {

            Image(item.album_sizable_cover.replace('{size}', '512'))
              .width('100%')

            Text(item.filename)
              .fontColor(Color.Black)
              .fontSize(14)
              .maxLines(2)
              .textOverflow({overflow: TextOverflow.Ellipsis})
          }
          .width('40%')
          .height('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({left: 10})
        }
      })

    }
      .width('100%')
      .height(220)
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
  }

}