/**
 * ============================================================
 * 主题②：容器组件（布局）怎么用
 * ============================================================
 * 容器组件用来「摆放」子组件，常见的有：
 *
 *   Column  纵向排列（一列竖着排）
 *   Row     横向排列（一行横着排）
 *   Stack   层叠（子组件叠在一起）
 *   List    列表（可滚动，配合 ListItem）
 *   Scroll  滚动容器（可包任意内容）
 *   Flex    弹性布局（更灵活）
 *
 * 布局三件套最容易记：
 *   Column 负责「上下」
 *   Row    负责「左右」
 *   Stack 负责「叠加」
 * ============================================================
 */

import { promptAction } from '@kit.ArkUI'; // 用于点击列表项时弹提示

@Entry
@Component
struct DemoContainer {
  // 给列表用的数据数组（普通成员变量即可）
  private items: string[] = ['苹果', '香蕉', '西瓜', '葡萄', '橙子', '草莓', '芒果', '菠萝'];

  build() {
    Scroll() {
      Column({ space: 16 }) {

        // ---------- 1. Column 纵向排列 ----------
        Text('一、Column：子组件竖着排，用 space 控制间距')
          .fontSize(14)
          .fontWeight(700)
        Column({ space: 8 }) { // space=8 表示子组件之间间隔 8
          Text('第 1 行')
          Text('第 2 行')
          Text('第 3 行')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#eef4ff')
        .borderRadius(8)

        // ---------- 2. Row 横向排列 ----------
        Text('二、Row：子组件横着排')
          .fontSize(14)
          .fontWeight(700)
        Row({ space: 12 }) {
          Text('左')
          Text('中')
          Text('右')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween) // 主轴对齐：两端对齐
        .padding(12)
        .backgroundColor('#eef8ee')
        .borderRadius(8)

        // ---------- 3. Stack 层叠 ----------
        Text('三、Stack：子组件叠在一起（底层→顶层）')
          .fontSize(14)
          .fontWeight(700)
        Stack({ alignContent: Alignment.Center }) { // alignContent：对齐方式
          // 底层：一个大的色块
          Text('底层')
            .width(120).height(80)
            .textAlign(TextAlign.Center)
            .backgroundColor('#fdeeee')
          // 顶层：一个小的色块，叠在上面
          Text('顶层')
            .width(60).height(40)
            .textAlign(TextAlign.Center)
            .backgroundColor('#fff3d6')
        }
        .width('100%')
        .height(120)
        .border({ width: 1, color: '#e0e0e0' })
        .borderRadius(8)

        // ---------- 4. List 列表 ----------
        Text('四、List 列表：可滚动 + ForEach 循环渲染')
          .fontSize(14)
          .fontWeight(700)
        // List 自带滚动；高度给一个固定值才能看出滚动效果
        List({ space: 8 }) {
          // ForEach(数组, 生成每个条目的函数, key生成函数)
          ForEach(this.items, (item: string) => {
            ListItem() { // 列表里的每一项要包在 ListItem 里
              Row() {
                Text(item).fontSize(15)
                Text('点击我').fontSize(12).fontColor('#999999')
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(8)
            }
            // 每条目点击事件：弹出提示（value 是数组元素）
            .onClick(() => {
              promptAction.showToast({ message: `你点了：${item}` });
            })
          }, (item: string) => item) // key 用条目内容
        }
        .width('100%')
        .height(200) // 固定高度才能滚动
        .border({ width: 1, color: '#e0e0e0' })
        .borderRadius(8)
        .backgroundColor('#fafafa')

        // ---------- 5. Flex 弹性布局 ----------
        Text('五、Flex：按比例分配宽度（layoutWeight）')
          .fontSize(14)
          .fontWeight(700)
        Row({ space: 8 }) {
          // layoutWeight(1) 表示占据 1 份剩余空间；3 个各 1 份 => 三等分
          Text('1/3').layoutWeight(1).height(40).textAlign(TextAlign.Center).backgroundColor('#dbe7ff')
          Text('1/3').layoutWeight(1).height(40).textAlign(TextAlign.Center).backgroundColor('#ffdbe7')
          Text('1/3').layoutWeight(1).height(40).textAlign(TextAlign.Center).backgroundColor('#d9ffe0')
        }
        .width('100%')

        Text('⚠ 提示：以上容器都可以互相嵌套，比如 Column 里放 Row、Row 里再放 Column。')
          .fontSize(12)
          .fontColor('#888888')
      }
      .width('100%')
      .padding(16)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
