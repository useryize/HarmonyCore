/**
 * ============================================================
 * 进阶⑤（配套）：组件间传参（接收端）
 * ============================================================
 * 接收父组件传来的参数，处理完后再把结果回传给父组件。
 *
 * 接收参数：父组件把 name / score 作为组件属性传进来
 * 返回结果：通过 onNavigateBack 回调把 result 交给父组件
 * ============================================================
 */

@Component
export struct DemoRouterReceive {
  // 父组件传进来的参数
  name: string = '';
  score: number = 0;
  // 回调：把 result 回传给父组件（父组件会切回发送端组件并带上 result）
  onNavigateBack: (result: string) => void = (result: string) => {};
  // 回调：关闭弹窗
  onClose: () => void = () => {};

  build() {
    Column({ space: 16 }) {
      Text('接收端组件（DemoRouterReceive）')
        .fontSize(16)
        .fontWeight(700)

      // 显示收到的参数
      Column({ space: 8 }) {
        Text(`收到姓名：${this.name}`)
          .fontSize(16)
          .fontColor('#4f6ef2')
        Text(`收到分数：${this.score}`)
          .fontSize(16)
          .fontColor('#4f6ef2')
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(12)

      // 返回并把结果带给发送端（通过回调交给父组件）
      Button('返回，并把结果传回发送端')
        .onClick(() => {
          this.onNavigateBack(`已收到 ${this.name}，分数 ${this.score}`);
        })

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
