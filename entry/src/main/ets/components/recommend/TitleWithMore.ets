@Component
export struct TitleWithMore {

  @Prop title: string

  build() {
    Row() {

      Text(this.title)
        .fontColor(Color.Black)
        .fontWeight(700)
        .layoutWeight(1)

      Image($r('sys.media.ohos_ic_public_more'))
        .width(22)
        .fillColor(Color.Black)

    }.width('100%')
  }
}