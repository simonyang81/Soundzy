import { CategoryInfo, CategoryInfoData } from "../../services/MusicService";

@ComponentV2
export struct Category {

  @Param @Require songCategories: CategoryInfoData;
  @Param @Require onClickEvent: (category: CategoryInfo) => void;

  build() {
    List({space: 10}) {
      LazyForEach(this.songCategories, (item: CategoryInfo,) => {
        ListItem() {

          Column() {

            Text(item.rankname)
              .width('100%')
              .fontSize(16)
              .fontWeight(700)
              .fontColor(Color.Black)

            Row() {
              Image(item.album_img_9.replace('{size}', '512'))
                .width('120')
                .borderRadius(5)
                .padding({
                  top: 5,
                  bottom: 5,
                })
              Text(item.intro)
                .fontSize(12)
                .layoutWeight(1)
                .fontColor(Color.Black)
                .maxLines(5)
                .textOverflow({overflow: TextOverflow.Ellipsis})
                .margin({left: 10, top: 10})

            }
              .layoutWeight(1)
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Top)

          }
          .width('100%')
          .height(140)
          .clip(true)

        }
        .padding(10)
        .borderRadius(8)
        .backgroundColor('#FFE6EAEB')
        .onClick(() => {
          this.onClickEvent(item)
        })
      })

    }
    .width('100%')
    .height('auto')
    .margin({
      bottom: 20,
    })

  }
}