/**
 * ============================================================
 * 进阶④：页面 / 组件生命周期
 * ============================================================
 * 鸿蒙组件从「创建」到「销毁」会依次触发一些回调方法，
 * 在这些回调里可以做初始化、收尾等工作。
 *
 * 常用回调（按触发顺序）：
 *   aboutToAppear    组件即将显示（创建后、build 前）→ 做初始化
 *   onPageShow       页面每次显示 → 刷新数据
 *   onPageHide       页面被盖住/跳走 → 暂停操作
 *   onBackPress      用户按返回键 → 可拦截
 *   aboutToDisappear 组件即将销毁 → 释放资源
 *
 * 操作建议：点下面「跳到临时页」再返回，观察 onPageHide / onPageShow 触发。
 * ============================================================
 */

import { router } from '@kit.ArkUI';

@Entry
@Component
struct DemoLifecycle {
  // 用一个数组记录触发了哪些回调，直接显示在页面上
  @State logs: string[] = [];

  // ---------- 生命周期回调 ----------
  // ① 组件创建后、界面 build 之前调用（做数据初始化）
  aboutToAppear(): void {
    this.addLog('① aboutToAppear 组件即将显示');
  }

  // ② 页面每次显示都调用（从别的页面跳回来也会触发）
  onPageShow(): void {
    this.addLog('② onPageShow 页面显示了');
  }

  // ③ 页面被遮挡/跳走时调用
  onPageHide(): void {
    this.addLog('③ onPageHide 页面被隐藏了');
  }

  // ④ 按返回键时调用；返回 true 表示拦截，false 表示放行
  onBackPress(): boolean {
    this.addLog('④ onBackPress 点了返回键');
    return false; // 返回 false：不拦截，正常返回
  }

  // ⑤ 组件销毁前调用（释放资源）
  aboutToDisappear(): void {
    this.addLog('⑤ aboutToDisappear 组件即将销毁');
  }

  // 工具方法：往记录数组里加一条
  addLog(msg: string): void {
    this.logs.push(msg);
  }

  build() {
    Column({ space: 12 }) {
      Text('生命周期演示')
        .fontSize(16)
        .fontWeight(700)

      // 跳去临时页再返回，触发 onPageHide / onPageShow
      Button('跳到临时页，再返回观察变化')
        .onClick(() => {
          router.pushUrl({ url: 'pages/demo/DemoLifecycleTarget' });
        })

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
