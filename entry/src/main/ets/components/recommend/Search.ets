@Component
export struct SearchWidget {
  build() {
    Row() {
      Text('搜索')
        .fontSize(20)
        .fontColor(Color.Black)
      Row() {
        Image($r('app.media.ic_search'))
          .width(22)
          .fillColor('#817D83')
          .padding({
            left: 8,
          })
        TextInput({ placeholder: 'Search', })
          .placeholderColor('#817D83')
          .placeholderFont({
            size: 12,
          })
          .fontColor('#817D83')
          .fontSize(12)
          .layoutWeight(1)
          .backgroundColor('#FFE6EAEB')
          .padding({
            left: 2
          })
      }
      .height(40)
      .margin({
        left: 20,
      })
      .layoutWeight(1)
      .backgroundColor('#FFE6EAEB')
      .border({
        color: '#FFE6EAEB',
        radius: 15,
      })

    }.width('100%')
  }
}