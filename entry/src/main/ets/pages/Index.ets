import json from '@ohos.util.json';

interface TabsType {
  name: string;
  type: string;
}

@ComponentV2
struct TJComponent {
  build() {
    Column() {
      Text('特价')
    }
  }
}

@ComponentV2
struct SYComponent {
  build() {
    Column() {
      Text('首页')
    }
  }
}

@ComponentV2
struct MSComponent {
  build() {
    Column() {
      Text('秒送')
    }
  }
}

@ComponentV2
struct XPComponent {
  build() {
    Column() {
      Text('新品')
    }
  }
}

@Entry
@Component
struct Index {
  @State tabsFocu: number = 0
  @State tabsList: TabsType[] = [
    { name: '特价', type: 'TJ' },
    { name: '首页', type: 'SY' },
    { name: '秒送', type: 'MS' },
    { name: '新品', type: 'XP' },
  ]

  @Builder
  TabsBar(item: TabsType, index: number) {
    Column() {
      Stack() {
        Text(item?.name).fontSize(16).fontWeight(this.tabsFocu === index ? 700 : 300)
        if (this.tabsFocu === index) {
          Divider()
            .width('50%')
            .height(2)
            .backgroundColor(Color.Red)
            .margin({ top: 5 })
            .position({ bottom: -5 })
        }
      }

    }
  }

  build() {

    Column() {
      Tabs() {
        ForEach(this.tabsList, (item: TabsType, index: number) => {
          TabContent() {
            if(item?.type=== 'TJ') {
              TJComponent()
            } else if(item?.type=== 'SY') {
              SYComponent()
            } else if(item?.type=== 'MS') {
              MSComponent()
            } else if(item?.type=== 'XP') {
              XPComponent()
            }
          }.tabBar(this.TabsBar(item, index))
        }, (item: TabsType) => item.type)
      }.height('90%').onChange((number) => this.tabsFocu = number)
    }.width('100%').height('100%').backgroundColor('#f5f6fa')
  }
}