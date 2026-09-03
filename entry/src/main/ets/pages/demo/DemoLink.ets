/**
 * ============================================================
 * 主题⑤：@Link 父子通讯 —— 双向同步
 * ============================================================
 * 场景：父组件和子组件要共用同一个数据，任一方改了，另一方都同步。
 *
 * @Link 的两个特点（重要）：
 *  1. 双向同步：父改子变，子改父也变（同一个数据源）。
 *  2. 传参要用 $ 前缀：父组件写 子组件名({ 参数名: $状态变量 })
 *
 * 和 @Prop 的区别：
 *  @Prop = 复印一份（单向，子改不动父）
 *  @Link = 共享原件（双向，两边都改同一个数据）
 *
 * 注意：@Link 不能写初始值，必须由父组件传进来。
 * ============================================================
 */

@Component
export struct DemoLink {
  // 父组件的状态
  @State parentCount: number = 0;

  build() {
    Column({ space: 16 }) {
      Text('父组件（DemoLink）')
        .fontSize(16)
        .fontWeight(700)

      Text(`父组件 parentCount = ${this.parentCount}`)
        .fontSize(16)
        .fontColor('#4f6ef2')

      Button('父组件 +1')
        .onClick(() => {
          this.parentCount = this.parentCount + 1;
        })

      Divider().color('#eeeeee')

      Text('子组件（ChildLink）')
        .fontSize(16)
        .fontWeight(700)

      // ===== 关键写法：传 $parentCount，前面必须加 $ =====
      ChildLink({ childCount: $parentCount })

      Text('操作任意一边的按钮，两边数字都会一起变（双向）')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}

@Component
export struct ChildLink {
  // @Link：双向同步；不能给初始值，靠父组件传进来
  @Link childCount: number;

  build() {
    Column({ space: 12 }) {
      Text(`子组件看到的 childCount = ${this.childCount}`)
        .fontSize(16)
        .fontColor('#e63946')

      Button('子组件 +1（父组件也会变）')
        .backgroundColor('#e63946')
        .onClick(() => {
          // 直接修改，父组件的 parentCount 同步变化
          this.childCount = this.childCount + 1;
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#fdeeee')
    .borderRadius(12)
  }
}
