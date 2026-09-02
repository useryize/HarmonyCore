/**
 * ============================================================
 * 进阶⑨：CustomDialog 自定义弹窗
 * ============================================================
 * 系统弹窗（promptAction 等）样式固定，想要自己的弹窗
 * 就用 @CustomDialog 自定义一个，再用 CustomDialogController 控制。
 *
 * 三步：
 *   1. 用 @CustomDialog 定义一个弹窗组件
 *   2. 在页面里 new 一个 CustomDialogController（配置弹窗内容）
 *   3. 需要时 controller.open() 打开，close() 关闭
 * ============================================================
 */

@Entry
@Component
struct DemoDialog {
  // 记录弹窗的操作结果
  @State dialogResult: string = '';

  // ===== ② 创建弹窗控制器（页面成员属性）=====
  // builder 里传入自定义弹窗，可以给弹窗传参数和回调
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      title: '删除确认',
      message: '确定要删除这条学习记录吗？',
      // 把「确定」的行为交给页面处理（回调）
      onConfirm: () => {
        this.dialogResult = '你点击了「确定」';
      }
    }),
    autoCancel: true,            // 点击弹窗外部区域自动关闭
    alignment: DialogAlignment.Center, // 弹窗位置：居中
    cornerRadius: 16             // 圆角
  });

  build() {
    Column({ space: 16 }) {
      Text('自定义弹窗演示')
        .fontSize(16)
        .fontWeight(700)

      Text('弹窗结果：' + (this.dialogResult.length > 0 ? this.dialogResult : '（未操作）'))
        .fontSize(15)
        .fontColor('#4f6ef2')

      // ===== ③ 打开弹窗 =====
      Button('打开自定义弹窗')
        .onClick(() => {
          this.dialogController.open();
        })

      Text('弹窗是一个独立的 @CustomDialog 组件，')
        .fontSize(12)
        .fontColor('#888888')
      Text('可以像普通组件一样传参、回调，下面就是它的定义。')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(24)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}

/**
 * ===== ① 自定义弹窗组件 =====
 * 用 @CustomDialog 修饰（不是 @Component）
 */
@CustomDialog
struct ConfirmDialog {
  // controller 是固定写法：用于控制这个弹窗关闭
  controller: CustomDialogController;
  // 弹窗自己的属性（由页面创建时传入）
  title: string = '';
  message: string = '';
  // 回调：确定按钮的行为由调用方决定
  onConfirm: () => void = () => {};

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(700)
      Text(this.message)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 8 })

      Row({ space: 16 }) {
        Button('取消')
          .backgroundColor('#cccccc')
          .onClick(() => {
            this.controller.close(); // 关闭弹窗
          })
        Button('确定')
          .onClick(() => {
            this.onConfirm(); // 通知页面
            this.controller.close();
          })
      }
      .margin({ top: 20 })
    }
    .padding(24)
  }
}
