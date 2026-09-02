/**
 * ============================================================
 * 主题④：@Prop 父子通讯 —— 父传子（单向）
 * ============================================================
 * 场景：父组件有一个数据，想传给子组件显示。
 *
 * @Prop 的三个特点（重要）：
 *  1. 单向同步：父组件改了，子组件跟着变；子组件改了，父组件不变。
 *  2. 用法：子组件声明 @Prop xxx；父组件在子组件标签里传值。
 *  3. 适合简单类型（number / string / boolean）或一维数组、普通对象。
 *
 * 记忆：@Prop 是「复印一份给子组件」——复印件的改动不影响原件。
 * ============================================================
 */

@Entry
@Component
struct DemoProp {
  // 父组件自己的状态
  @State parentCount: number = 0;

  build() {
    Column({ space: 16 }) {
      Text('父组件（DemoProp）')
        .fontSize(16)
        .fontWeight(700)

      // 父组件显示自己的值
      Text(`父组件 parentCount = ${this.parentCount}`)
        .fontSize(16)
        .fontColor('#4f6ef2')

      // 父组件按钮：修改自己的状态
      Button('父组件 +1')
        .onClick(() => {
          this.parentCount = this.parentCount + 1;
          // parentCount 变化 -> 子组件的 childCount 也会跟着变（单向同步）
        })

      // 分隔线
      Divider().color('#eeeeee')

      Text('子组件（ChildProp）')
        .fontSize(16)
        .fontWeight(700)

      // ===== 关键写法：在子组件标签里用「参数名: 值」传值 =====
      // 这里把父组件的 parentCount 传给子组件的 childCount
      ChildProp({ childCount: this.parentCount })

      Text('操作上方两个按钮，观察：')
        .fontSize(12)
        .fontColor('#888888')
      Text('① 点「父组件 +1」→ 子组件数字也会 +1（父变子跟随）')
        .fontSize(12)
        .fontColor('#888888')
      Text('② 在子组件里点 +1 → 父组件数字不变（子不能反向影响父）')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}

/**
 * 子组件定义（同一个文件里，用 @Component export struct 声明）
 * 它不是页面，所以不加 @Entry。
 */
@Component
export struct ChildProp {
  // @Prop：从父组件接收，单向同步
  // 必须给初始值（父组件没传时用它）
  @Prop childCount: number = 0;

  build() {
    Column({ space: 12 }) {
      Text(`子组件收到的 childCount = ${this.childCount}`)
        .fontSize(16)
        .fontColor('#e63946')

      Button('子组件 +1（试试点）')
        .backgroundColor('#e63946')
        .onClick(() => {
          // 子组件可以修改 @Prop，但只是改自己的副本，不会同步回父组件
          this.childCount = this.childCount + 1;
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#fdeeee')
    .borderRadius(12)
  }
}
