/**
 * ============================================================
 * 电商首页（原 Index.ets 迁移保留）
 * 说明：为了让入口页变成学习导航，把原来的电商原型挪到这里。
 * 代码与之前完全一致，只是结构名改成了 Ecommerce。
 * ============================================================
 */

// 轮播数据模型
interface BannerItem {
  title: string;
  image?: Resource;
}

@Entry
@Component
struct Ecommerce {
  @State currentIndex: number = 0;
  private banners: BannerItem[] = [
    { title: '夏日清爽 · 全场 5 折起' },
    { title: '极客数码 · 新品首发' },
    { title: '暖胃美食 · 满 30 减 15' }
  ];

  build() {
    Column({ space: 10 }) {
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
              .position({ bottom: 0, left: 0 })
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

      Column({ space: 10 }) {
        Row() {
          Text('￥').fontColor(Color.Red).fontSize(14)
          Text('3??').fontColor(Color.Red).fontSize(16).fontWeight(600)
          Text('登录查看价格')
            .fontSize(12)
            .fontColor(Color.White)
            .padding(5)
            .borderRadius({
              topLeft: 10,
              topRight: 10,
              bottomLeft: 2,
              bottomRight: 10,
            })
            .backgroundColor('#f6505e')
            .margin({ left: 10 })
        }.width('100%')

        Text(Array(60).fill('XXXX').join(''))
          .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis }).fontSize(14).fontWeight(600)
      }.padding({ left: 10, right: 10 })
    }
    .width('100%')
    .height('100%')
    .background('#f9fafb')
  }
}
