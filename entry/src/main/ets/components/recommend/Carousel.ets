import { Banner } from "../../services/MusicService";

@ComponentV2
export struct Carousel {

  @Param @Require banners: Banner[];

  // swiperList: string[] = [
  //   'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner1.png',
  //   'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner2.png',
  //   'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner3.png',
  //   'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner4.png',
  //   'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner5.png',
  // ]

  build() {
    Swiper() {
      ForEach(this.banners, (item: Banner) => {
        Image(item.imgurl)
          .width('100%')
          .borderRadius(10)
          .margin({
            left: 10,
            right: 10,
          })
          .objectFit(ImageFit.Contain)
      })
    }
      .borderRadius(10)
      .loop(true)
      .autoPlay(true)
      .height(200)
      // .prevMargin(50)
      // .nextMargin(50)
  }
}