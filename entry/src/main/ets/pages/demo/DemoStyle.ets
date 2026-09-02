/**
 * ============================================================
 * 进阶③：@Styles + @Extend —— 样式 / 属性扩展
 * ============================================================
 * 痛点：很多组件要写同一套样式（同样的背景色、圆角、内边距…），
 *       每次都复制一堆 .fontSize().backgroundColor()… 太啰嗦。
 *
 * 两个工具：
 *   @Styles  封装「通用样式」——所有组件都能用（背景、圆角、宽高…）
 *   @Extend  封装「某个组件特有属性」——比如 Text 的字号颜色
 *
 * 区别一句话：
 *   @Styles 是通用美容（谁都能贴）
 *   @Extend 是专属装备（只能给指定组件）
 * ============================================================
 */

// ===== ① 全局 @Styles：放在 struct 外面，所有页面可用 =====
// 只能写「通用属性」（backgroundColor / borderRadius / padding 等）
@Styles
function globalCardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(12)
  .padding(14)
}

// ===== ② 全局 @Extend：给「指定的组件类型」扩展专属属性 =====
// 这里给 Text 扩展一个标题样式，可以写 Text 特有的 fontSize/fontColor
@Extend(Text)
function textTitle() {
  .fontSize(18)
  .fontWeight(700)
  .fontColor('#1a1a1a')
}

// ===== ③ 给 Text 再扩展一个「副标题」样式 =====
@Extend(Text)
function textSubtitle() {
  .fontSize(12)
  .fontColor('#888888')
}

@Entry
@Component
struct DemoStyle {
  // ===== ④ 成员 @Styles：定义在本组件内，本组件可用 =====
  @Styles
  memberCard() {
    .backgroundColor('#eef4ff')
    .borderRadius(10)
    .padding(12)
  }

  build() {
    Column({ space: 16 }) {
      Text('@Extend 扩展的标题样式')
        .textTitle() // 链式调用全局 @Extend

      Text('@Extend 扩展的副标题样式')
        .textSubtitle()

      // 全局 @Styles 应用
      Column({ space: 6 }) {
        Text('使用全局 @Styles').fontSize(15).fontWeight(600)
        Text('整个页面统一的卡片外观').fontSize(12).fontColor('#888888')
      }
      .globalCardStyle() // 链式调用全局 @Styles
      .width('100%')

      // 成员 @Styles 应用
      Row() {
        Text('使用成员 @Styles')
      }
      .memberCard() // 本组件内定义，本组件内用
      .width('100%')

      // 组合使用：@Extend + @Styles 可以叠加
      Text('组合使用 @Extend + @Styles')
        .textTitle()
        .globalCardStyle()
        .width('100%')

      Text('核心理解：样式先定义一次，之后到处 .样式名() 复用。')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}
