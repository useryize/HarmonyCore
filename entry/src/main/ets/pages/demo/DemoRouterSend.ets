/**
 * ============================================================
 * 进阶⑤：组件间传参（发送端）
 * ============================================================
 * 页面改成弹窗里的组件后，跨“页面”传参不再用 router，
 * 而是由父组件（demo/index）统一管理状态：
 *
 *  发送端组件通过回调把参数交给父组件
 *  → 父组件把参数传给接收端组件（DemoRouterReceive）的属性
 *  → 接收端通过回调把 result 回传给父组件
 *  → 父组件再把 result 传给发送端组件显示
 *
 * 配套组件：DemoRouterReceive（接收端）
 * ============================================================
 */

@Component
export struct DemoRouterSend {
  // 父组件传进来的：接收端回传的结果
  backMsg: string = '';
  // 回调：把 name/score 交给父组件，由父组件切到接收端组件
  onNavigateReceive: (name: string, score: number) => void = (name: string, score: number) => {};
  // 回调：关闭弹窗
  onClose: () => void = () => {};

  build() {
    Column({ space: 16 }) {
      Text('发送端组件（DemoRouterSend）')
        .fontSize(16)
        .fontWeight(700)

      // 发送参数：把数据通过回调交给父组件
      Button('带参数切到接收端组件')
        .onClick(() => {
          this.onNavigateReceive('易文轩', 95);
        })

      Divider()

      Text('接收端返回回来的结果：')
        .fontSize(13)
        .fontColor('#888888')
      Text(this.backMsg.length > 0 ? this.backMsg : '（暂无返回）')
        .fontSize(16)
        .fontWeight(600)
        .fontColor('#e63946')

      Text('流程：发送端 → 父组件传参 → 接收端 → 回调回传 result → 发送端显示')
        .fontSize(12)
        .fontColor('#888888')

      Button('关闭弹窗')
        .backgroundColor('#999999')
        .onClick(() => {
          this.onClose();
        })
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}
