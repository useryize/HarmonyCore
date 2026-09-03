@Entry
@Component
struct Idnex {
  build() {
    Column() {
      Row({ space: 10 }) {
        Text('武汉').fontSize(16).fontWeight(700)
        Text('当前天气').fontSize(12).fontColor('#999')
        Blank()
        Button('刷新').fontSize(11).height(25)
      }
      .width('100%')
    }.width('100%').height('100%').padding(16).backgroundColor('#faf6f8')
  }
}