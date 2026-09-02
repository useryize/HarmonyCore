/**
 * ============================================================
 * 进阶⑦：Tabs 底部标签导航
 * ============================================================
 * Tabs 是「多页签」容器，配合 TabContent 实现
 * 底部导航（首页/发现/我的 这种常见 App 结构）。
 *
 * 结构：
 *   Tabs({ barPosition })         外层容器，barPosition 决定标签位置
 *     TabContent() { 内容 } .tabBar('标签文字')   每个页签
 *     ...
 *
 * barPosition: BarPosition.End = 底部；BarPosition.Start = 顶部
 * ============================================================
 */

@Entry
@Component
struct DemoTabs {
  // 记录当前选中的页签下标（Tabs 的 onChange 会通知）
  @State current: number = 0;

  build() {
    // barPosition: BarPosition.End 表示标签栏在底部
    Tabs({ barPosition: BarPosition.End }) {
      // ---------- 页签 1：首页 ----------
      TabContent() {
        Column({ space: 12 }) {
          Text('🏠 首页').fontSize(20).fontWeight(700)
          Text('这里是首页内容').fontSize(14).fontColor('#666666')
          Text(`当前选中页签：${this.current}`).fontSize(13).fontColor('#4f6ef2')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      .tabBar('首页') // 标签文字（简单写法）

      // ---------- 页签 2：发现 ----------
      TabContent() {
        Column({ space: 12 }) {
          Text('🔍 发现').fontSize(20).fontWeight(700)
          Text('这里是发现内容').fontSize(14).fontColor('#666666')
          Text(`当前选中页签：${this.current}`).fontSize(13).fontColor('#4f6ef2')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      .tabBar('发现')

      // ---------- 页签 3：我的 ----------
      TabContent() {
        Column({ space: 12 }) {
          Text('👤 我的').fontSize(20).fontWeight(700)
          Text('这里是个人中心内容').fontSize(14).fontColor('#666666')
          Text(`当前选中页签：${this.current}`).fontSize(13).fontColor('#4f6ef2')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      .tabBar('我的')
    }
    .onChange((index: number) => {
      // 切换页签时触发，index 是选中页签的下标
      this.current = index;
    })
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
