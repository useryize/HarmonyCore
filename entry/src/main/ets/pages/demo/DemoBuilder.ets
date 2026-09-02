/**
 * ============================================================
 * 进阶②：@Builder —— 自定义构建函数（UI 复用）
 * ============================================================
 * 痛点：页面里有好几块长得差不多的 UI（比如多个卡片），
 *       复制粘贴会又长又乱。
 *
 * 解决：用 @Builder 把「一块 UI」封装成一个函数，
 *       需要时调用一次，传不同参数就能生成不同内容。
 *
 * 记忆：@Builder = 把 UI 片段变成「可复用零件」。
 * ============================================================
 */

@Entry
@Component
struct DemoBuilder {
  // 数据：三本书
  private books: string[][] = [
    ['《鸿蒙开发入门》', '适合新手'],
    ['《ArkTS 进阶实战》', '讲状态管理'],
    ['《组件化设计》', '讲复用']
  ];

  /**
   * ① 定义 @Builder 方法
   * 参数可以按需设计，这里接收标题和副标题
   */
  @Builder
  card(title: string, subtitle: string) {
    // 这一整块 Column 就是「零件」
    Column({ space: 6 }) {
      Text(title)
        .fontSize(16)
        .fontWeight(700)
      Text(subtitle)
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .border({ width: 1, color: '#eeeeee' })
  }

  build() {
    Column({ space: 12 }) {
      Text('一个 @Builder，多处调用，传不同参数')
        .fontSize(15)
        .fontWeight(700)

      // ② 手动调用 @Builder（this.方法名(参数)）
      this.card('固定调用 1', '直接在 build 里 this.card() 调用')

      // ③ 在 ForEach 里循环调用，生成多个卡片
      ForEach(this.books, (book: string[]) => {
        this.card(book[0], book[1])
      }, (book: string[]) => book[0])

      // ④ @Builder 里也能用 if/else、放按钮等任意 UI 逻辑
      this.card('带按钮的卡片', '零件里也可以有交互')
      // ↑ 上面这行只是演示；真正的按钮版在下面用 @Builder 变体演示

      Divider()

      Text('小提示：@Builder 也可以定义在 struct 外面，')
        .fontSize(12)
        .fontColor('#888888')
      Text('用 @Builder function 声明成全局函数，任何页面都能用。')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}
