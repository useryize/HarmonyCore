interface listItem {
  id: number;
  title: string;
  description: string;
  author: string;
  price: number;
  category: string;
  rating: number;
}

@Entry
@Component
struct Index {
  @State list: listItem[] = [
    {
      id: 1,
      title: "深度学习入门：基于Python的理论与实现",
      description: "日本深度学习专家斋藤康毅所著，用通俗易懂的语言和直观的代码，手把手带你从零实现神经网络，是AI入门必读之作。",
      author: "斋藤康毅",
      price: 89.9,
      category: "技术",
      rating: 9.2
    },
    {
      id: 2,
      title: "长安的荔枝",
      description: "马伯庸以「一骑红尘妃子笑」为引，讲述了一个小吏跨越五千里运送鲜荔枝的荒诞故事，于细微处见大唐盛世的另一面。",
      author: "马伯庸",
      price: 59.0,
      category: "小说",
      rating: 8.8
    },
    {
      id: 3,
      title: "也许你该找个人聊聊",
      description: "心理治疗师洛莉·戈特利布以双重视角——治疗师和来访者——讲述了四个真实案例，温暖而犀利，让人在故事中看见自己的影子。",
      author: "洛莉·戈特利布",
      price: 68.0,
      category: "心理学",
      rating: 9.0
    }
  ];

  build() {
    Column({ space: 10 }) {
      Text('入口页面').fontSize(22).fontWeight(700).margin({ top: 20 })

      List({ space: 10 }) {
        ForEach(this.list, (item: listItem) => {
          ListItem() {
            Row() {
              Column({ space: 10 }) {
                Text(item.title).fontSize(15).fontWeight(600)
                Text(item.description)
                  .fontSize(12)
                  .fontColor('#666')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }.alignItems(HorizontalAlign.Start).layoutWeight(1)

              Column() {
                Text('›').fontSize(24).fontColor('#CCC')

              }.width(20).alignItems(HorizontalAlign.End)
            }
            .border({ width: 1, color: '#eeeeee' })
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(8)
            .padding(16)
          }
        }, (item: listItem) => item.id.toString())
      }.width('100%').padding({ left: 16, right: 16 })

      Text('1246').onClick(() => {
        try {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/demo/index'
          }).catch(() => {
            // TODO: Implement error handling.
          })
        } catch (err) {
        }

      })
    }.width('100%').height('100%').backgroundColor('#f5f6fa')
  }
}