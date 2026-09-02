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
 *   1. 定义一个事件 ID（string）
 *   2. 接收方 emitter.on(事件ID, 回调)  订阅
 *   3. 发送方 emitter.emit(事件ID, 数据) 发布
 *
 * 本 SDK 版本的写法要点（已踩坑修正）：
 *   - on / emit / off 的事件 ID 只支持两种形式：
 *       ① emitter.InnerEvent 对象（{ eventId: number, priority? }）
 *       ② string 事件 ID
 *     【不支持直接传 number】，所以这里统一用 string。
 *   - emitter.EventData 的 data 字段是 { [key: string]: any } 索引对象，
 *     要传 { value: xxx } 这样的对象，不能直接传 number。
 *   - ArkTS 禁止 any/unknown，取 data 里的字段时先断言到显式接口。
 *
 * 用完一定要 emitter.off 取消订阅（在 aboutToDisappear 里）。
 * ============================================================
 */

import { emitter } from '@kit.BasicServicesKit';

// ① 自定义事件 ID（string，本 SDK 版本不支持直接传 number）
const EVENT_SCORE = 'demo.score';

// 描述 EventData.data 里放的数据结构（显式接口，避免 any）
interface ScorePayload {
  value: number;
}

@Entry
@Component
struct DemoEmitter {
  // 保存收到的事件数据
  @State received: number = 0;

  // 订阅：页面一创建就监听
  aboutToAppear(): void {
    // string 形式的事件 ID + 回调
    emitter.on(EVENT_SCORE, (eventData: emitter.EventData) => {
      // eventData.data 是 { [key: string]: any }，先断言到显式接口再取值
      const payload = eventData.data as ScorePayload;
      this.received = payload.value;
    });
  }

  // 取消订阅：页面销毁前一定要取消，否则会内存泄漏
  aboutToDisappear(): void {
    // off 也用 string 事件 ID
    emitter.off(EVENT_SCORE);
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
          // ② 发布：string 事件 ID + 数据
          // EventData.data 是索引对象，要传 { value: score }，不能直接传 number
          const eventData: emitter.EventData = { data: { value: score } };
          emitter.emit(EVENT_SCORE, eventData);
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
