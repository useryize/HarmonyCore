import { text } from '@kit.ArkGraphics2D';

// 轮播数据模型
interface BannerItem {
  title: string;
  image?: Resource;
}

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private banners: BannerItem[] = [
    { title: '夏日清爽 · 全场 5 折起' },
    { title: '极客数码 · 新品首发' },
    { title: '暖胃美食 · 满 30 减 15' }
  ];

  build() {
    Column() {
      Swiper() {
        ForEach(this.banners, (item: BannerItem) => {
          Stack({ alignContent: Alignment.Bottom }) {
            Image(item.image).width('100%').height('100%').objectFit(ImageFit.Cover).backgroundColor('#ddd')
            Text(item.title)
              .width('100%')
              .background('rgba(0,0,0,0.5)')
              .fontColor('#ffffff')
              .padding(5)
              .fontSize(14)
              .textAlign(TextAlign.Start)

            // .position({ x: 0, y: 0 })
          }

        })
      }
      .width('100%')
      .height(200)
      .padding(10)
      .background('#fff')
      .borderRadius(10)
      .borderColor('#cbcbcb')
      .borderWidth(2)
      .clip(true)
      .indicator(Indicator.dot()
        .bottom(25)
        .itemWidth(10)
        .selectedItemWidth(10)
        .selectedColor(Color.White))
    }
    .width('100%')
    .height('100%')
    .background('#f9fafb')
  }
}
