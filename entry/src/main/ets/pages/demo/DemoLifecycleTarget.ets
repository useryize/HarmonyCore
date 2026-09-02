/**
 * ============================================================
 * 临时页（生命周期演示用）
 * 从 DemoLifecycle 跳过来，再返回去，观察生命周期触发。
 * ============================================================
 */

import { router } from '@kit.ArkUI';

@Entry
@Component
struct DemoLifecycleTarget {
  build() {
    Column({ space: 16 }) {
      Text('我是临时页')
        .fontSize(20)
        .fontWeight(700)
      Text('点击返回，回到上一页看 onPageShow 是否触发')
        .fontSize(13)
        .fontColor('#888888')

      Button('返回上一页')
        .onClick(() => {
          // router.back()：返回上一页
          router.back();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#f5f6fa')
  }
}
