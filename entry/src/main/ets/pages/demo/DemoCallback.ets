/**
 * ============================================================
 * 主题⑥：子传父 —— 回调函数
 * ============================================================
 * 场景：子组件里发生了某件事（点击、输入…），想告诉父组件。
 *
 * 做法（三句话）：
 *  1. 父组件写一个方法（比如 onChildAdd）
 *  2. 把方法当作「参数」传给子组件
 *  3. 子组件在合适的时机调用这个参数（this.callback(...)）
 *
 * 这是鸿蒙里「子 → 父」最常用、最好懂的方式。
 * 理解成：父组件给子组件一张「纸条」，子组件有事就照着纸条呼叫父组件。
 * ============================================================
 */

@Entry
@Component
struct DemoCallback {
  // 父组件自己的状态
  @State total: number = 0;

  // ===== ① 父组件定义的回调方法 =====
  // 子组件会调用它，把 value 传回来
  onChildAdd(value: number): void {
    this.total = this.total + value; // 累加子组件传来的值
  }

  build() {
    Column({ space: 16 }) {
      Text('父组件（DemoCallback）')
        .fontSize(16)
        .fontWeight(700)

      Text(`父组件累加结果 total = ${this.total}`)
        .fontSize(22)
        .fontWeight(700)
        .fontColor('#4f6ef2')

      Divider().color('#eeeeee')

      Text('子组件：点下面的按钮，把值传回父组件')
        .fontSize(14)

      // ===== ② 把父组件方法作为参数传给子组件 =====
      ChildCallback({ callback: this.onChildAdd })

      Text('说明：子组件内部没有任何 total 状态，')
        .fontSize(12)
        .fontColor('#888888')
      Text('它只是调用父组件传进来的函数，数据完全由父组件保存。')
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
export struct ChildCallback {
  // ===== ③ 子组件用一个「函数类型」的普通成员接收回调 =====
  // 类型：参数 value 是 number，没有返回值
  // 给一个默认空函数，避免父组件忘了传导致报错
  callback: (value: number) => void = () => {};

  build() {
    Row({ space: 12 }) {
      // 三个按钮，分别调用父组件传来的函数，传不同的值
      Button('传 +1')
        .onClick(() => {
          this.callback(1); // 调用父组件传进来的方法，参数 1
        })
      Button('传 +5')
        .onClick(() => {
          this.callback(5);
        })
      Button('传 +10')
        .onClick(() => {
          this.callback(10);
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#eef4ff')
    .borderRadius(12)
  }
}
