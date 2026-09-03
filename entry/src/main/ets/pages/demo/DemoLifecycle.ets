/**
 * ============================================================
 * 进阶④：组件生命周期
 * ============================================================
 * 这个页面已经改造成普通组件，嵌在首页的弹窗里使用。
 * 组件从「创建」到「销毁」会依次触发回调，用来做初始化和收尾：
 *
 *   aboutToAppear    组件即将显示（创建后、build 前）→ 做初始化
 *   aboutToDisappear 组件即将销毁 → 释放资源
 *
 * 操作建议：打开 / 关闭这个弹窗，观察上面两个回调触发。
 *
 * 说明：原 onPageShow / onPageHide / onBackPress 是「页面级」回调，
 *       页面改成组件后不再触发，所以这里不再演示。
 * ============================================================
 */

@Component
export struct DemoLifecycle {
  // 用一个数组记录触发了哪些回调，直接显示在页面上
  @State logs: string[] = [];

  // ---------- 生命周期回调 ----------
  // ① 组件创建后、界面 build 之前调用（做数据初始化）
  aboutToAppear(): void {
    this.addLog('① aboutToAppear 组件即将显示');
  }

  // ② 组件销毁前调用（释放资源）
  aboutToDisappear(): void {
    this.addLog('② aboutToDisappear 组件即将销毁');
  }

  // 工具方法：往记录数组里加一条
  addLog(msg: string): void {
    this.logs.push(msg);
  }

  build() {
    Column({ space: 12 }) {
      Text('组件生命周期演示')
        .fontSize(16)
        .fontWeight(700)

      Text('打开 / 关闭弹窗，观察 aboutToAppear / aboutToDisappear 触发')
        .fontSize(12)
        .fontColor('#888888')

      Button('清空记录')
        .backgroundColor('#999999')
        .onClick(() => {
          this.logs = []; // 重新赋值空数组也能刷新
        })

      // 显示触发记录
      List({ space: 6 }) {
        ForEach(this.logs, (log: string, index: number) => {
          ListItem() {
            Text(`${index + 1}. ${log}`)
              .fontSize(13)
              .fontColor('#4f6ef2')
              .width('100%')
              .padding(10)
              .backgroundColor(Color.White)
              .borderRadius(8)
          }
        }, (log: string, index: number) => index.toString() + log)
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}
