@Component
export struct MusicCard {
  @Prop img: string = '';
  @Prop name: string = '';
  @Prop author: string = '';
  @Prop isPlaying: boolean = false;
  onCardClick?: () => void;

  build() {
    Row() {
      Stack() {
        Image(this.img).width(50)
        if (this.isPlaying === true) {
          Image($r('sys.media.AI_playing'))
            .width(24)
            .fillColor(Color.White)
        }
      }

      Blank().width(20)
      Column() {
        Text(this.name)
        Blank().height(5)
        Row() {

          Text('VIP').border({
            width: 1,
            color: '#9A8E28',
            radius: 15
          }).padding(5)

          Blank().width(10)

          Text(this.author)

        }

      }.alignItems(HorizontalAlign.Start)
    }.width('100%').height(70).padding({
      left: 20,
    })
    .onClick(() => {
      if (this.onCardClick) {
        this.onCardClick();
      }
    })
  }
}