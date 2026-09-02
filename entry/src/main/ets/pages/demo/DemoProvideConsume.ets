/**
 * ============================================================
 * 主题⑦：@Provide / @Consume —— 跨层级共享（跳过中间层）
 * ============================================================
 * 场景：组件嵌套很深（爷爷 → 爸爸 → 儿子 → 孙子），
 *       孙子要用爷爷的数据。如果一层层用 @Prop 传，太啰嗦。
 *
 * 解决：
 *  爷爷（祖先）用 @Provide 提供数据
 *  孙子（后代）用 @Consume 直接取用
 *  中间的组件什么都不用做，数据自动「穿透」下来
 *
 * 记忆：@Provide = 在楼上「广播」数据；@Consume = 在楼下「收听」。
 * 双向：后代改了 @Consume，祖先的 @Provide 也一起变。
 * ============================================================
 */

@Entry
@Component
struct DemoProvideConsume {
  // ===== 祖先组件：用 @Provide 提供数据 =====
  // 默认以变量名 message 作为 key，后代用 @Consume message 接收
  @Provide message: string = '来自爷爷的消息';

  build() {
    Column({ space: 16 }) {
      Text('祖先组件（最外层，@Provide 提供数据）')
        .fontSize(15)
        .fontWeight(700)

      // 祖先也能显示自己的数据
      Text(`祖先: ${this.message}`)
        .fontSize(14)
        .fontColor('#4f6ef2')

      Button('祖先改消息')
        .onClick(() => {
          this.message = `爷爷第 ${Math.floor(Math.random() * 100)} 次改消息`;
        })

      Divider().color('#eeeeee')

      Text('中间组件（不传任何参数，直接把孙子嵌进来）')
        .fontSize(14)

      // 中间层不写任何传递代码
      MiddleComp()

      Text('说明：中间组件没有 @Prop 也没有 @Link，')
        .fontSize(12)
        .fontColor('#888888')
      Text('孙子的 @Consume 直接拿到祖先的 @Provide。')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}

/** 中间组件：什么参数都不传，纯粹当「中转站」 */
@Component
struct MiddleComp {
  build() {
    // 中间层可以有自己的 UI，也可以直接嵌后代
    Column({ space: 8 }) {
      Text('我是中间组件')
        .fontSize(13)
        .fontColor('#999999')
      // 直接嵌套孙子组件，不传任何参数
      ChildConsume()
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#f4f4f4')
    .borderRadius(12)
  }
}

/** 孙子组件：用 @Consume 直接取祖先的数据 */
@Component
struct ChildConsume {
  // ===== @Consume：直接接收祖先 @Provide 的同名数据 =====
  // 不允许写初始值；key 默认 = 变量名 message
  @Consume message: string;

  build() {
    Column({ space: 12 }) {
      Text(`孙子收到的: ${this.message}`)
        .fontSize(16)
        .fontWeight(600)
        .fontColor('#e63946')

      Button('孙子改消息（祖先也会变）')
        .backgroundColor('#e63946')
        .onClick(() => {
          // 双向：改这里，祖先的 @Provide 也同步
          this.message = '孙子改过了！';
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#fdeeee')
    .borderRadius(12)
  }
}
