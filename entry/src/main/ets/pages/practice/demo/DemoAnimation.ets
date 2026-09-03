/**
 * ============================================================
 * 进阶⑥：动画（三种常用写法）
 * ============================================================
 * 1. animateTo 显式动画：把「修改状态」包在 animateTo 里，
 *    状态一变，被影响到的 UI 会自动过渡。
 * 2. animation  属性动画：给组件挂 .animation()，
 *    之后这个组件的任何属性变化都自动补间。
 * 3. transition 转场：组件「出现 / 消失」时播放过渡效果。
 *
 * 记忆：
 *   animateTo  = 手动喊开始（包住改状态的动作）
 *   animation  = 自动跟随（挂组件上，变了就动）
 *   transition = 进出场特效（配合 if/else 显隐）
 * ============================================================
 */

@Component
export struct DemoAnimation {
  // ① 控制方块大小（animateTo）
  @State big: boolean = false;
  // ② 控制方块位移（animation）
  @State moved: boolean = false;
  // ③ 控制组件显隐（transition）
  @State visible: boolean = true;

  build() {
    Scroll() {
      Column({ space: 16 }) {

        // ---------- 一、animateTo 显式动画 ----------
        Text('一、animateTo 显式动画')
          .fontSize(14)
          .fontWeight(700)
        Row() {
          Text('方块')
            .width(this.big ? 120 : 60)   // 宽度根据状态切换
            .height(60)
            .backgroundColor('#4f6ef2')
            .borderRadius(8)
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .height(80)
        .backgroundColor('#eef4ff')
        .borderRadius(10)
        Button('变大 / 变小')
          .onClick(() => {
            // 关键：把状态修改包在 animateTo 里，就有过渡动画
            animateTo({ duration: 500, curve: Curve.EaseOut }, () => {
              this.big = !this.big;
            });
          })

        // ---------- 二、animation 属性动画 ----------
        Text('二、animation 属性动画')
          .fontSize(14)
          .fontWeight(700)
        Row() {
          Text('方块')
            .width(60)
            .height(60)
            .backgroundColor('#e63946')
            .borderRadius(8)
            .textAlign(TextAlign.Center)
            .translate({ x: this.moved ? 120 : 0 }) // 位移随状态变
            .animation({ duration: 800, curve: Curve.EaseInOut }) // 挂上后自动过渡
        }
        .width('100%')
        .height(80)
        .backgroundColor('#fdeeee')
        .borderRadius(10)
        Button('移动 / 复位')
          .onClick(() => {
            // 这里不用包 animateTo，因为组件挂了 .animation()
            this.moved = !this.moved;
          })

        // ---------- 三、transition 转场 ----------
        Text('三、transition 转场（配合 if/else）')
          .fontSize(14)
          .fontWeight(700)
        if (this.visible) {
          Text('我是会进出场的组件')
            .width('100%')
            .padding(20)
            .textAlign(TextAlign.Center)
            .backgroundColor('#2e9e44')
            .fontColor(Color.White)
            .borderRadius(10)
            // 转场：出现时淡入，消失时淡出
            .transition(TransitionEffect.OPACITY.animation({ duration: 500 }))
        }
        Button('显示 / 隐藏')
          .onClick(() => {
            this.visible = !this.visible;
          })

        Text('提示：TransitionEffect.OPACITY 是淡入淡出，还有 SLIDE 滑动、SCALE 缩放等。')
          .fontSize(12)
          .fontColor('#888888')
      }
      .width('100%')
      .padding(16)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
