/**
 * ============================================================
 * 进阶⑧：emitter 事件总线（跨组件 / 跨页面通信）
 * ============================================================
 * 痛点：没有父子关系的两个组件（甚至两个页面）要通信，
 *       用 @State/@Prop 传不动，AppStorage 又太重。
 *
 * 解决：emitter 像「广播电台」——
 *   一方「发布」(emit) 事件，关心的人「订阅」(on) 就能收到。
 *
 * 三步：
 *   1. 定义一个事件 ID（一个数字）
 *   2. 接收方 emitter.on(事件ID, 回调)  订阅
 *   3. 发送方 emitter.emit(事件ID, 数据) 发布
 *
 * 用完一定要 emitter.off 取消订阅（在 aboutToDisappear 里）。
 * ============================================================
 */

import { emitter } from '@kit.BasicServicesKit';

// ① 自定义事件 ID（数字，只要全局唯一就行）
const EVENT_SCORE = 20240901;

@Entry
@Component
struct DemoEmitter {
  // 保存收到的事件数据
  @State received: number = 0;

  // 订阅：页面一创建就监听
  aboutToAppear(): void {
    emitter.on({ eventId: EVENT_SCORE }, (eventData: emitter.EventData) => {
      // 收到事件，把 data 拿出来显示
      const value = eventData.data as number;
      this.received = value;
    });
  }

  // 取消订阅：页面销毁前一定要取消，否则会内存泄漏
  aboutToDisappear(): void {
    emitter.off({ eventId: EVENT_SCORE });
  }

  build() {
    Column({ space: 16 }) {
      Text('emitter 事件总线')
        .fontSize(16)
        .fontWeight(700)

      // 显示收到的数据
      Column({ space: 8 }) {
        Text('本页面订阅了事件，收到数据：')
          .fontSize(13)
          .fontColor('#888888')
        Text(`${this.received}`)
          .fontSize(32)
          .fontWeight(700)
          .fontColor('#e63946')
      }
      .width('100%')
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius(12)

      // 发布事件
      Button('发布事件：发一个随机分数')
        .onClick(() => {
          const score = Math.floor(Math.random() * 100);
          // ② 发布：事件ID + 数据
          emitter.emit({ eventId: EVENT_SCORE }, { data: score });
        })

      Divider()

      Text('跨页面怎么用？')
        .fontSize(14)
        .fontWeight(700)
      Text('A 页面里 emit 发布，B 页面（哪怕是另一个页面）里 on 订阅就能收到。')
        .fontSize(13)
        .fontColor('#666666')
      Text('本页演示了「同一页面订阅+发布」，原理和跨页面完全一样。')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}
