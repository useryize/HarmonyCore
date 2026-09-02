/**
 * ============================================================
 * 进阶⑤（配套）：路由传参（接收页）
 * ============================================================
 * 接收上一页传来的参数，处理完后再把结果传回去。
 *
 * 接收参数：onPageShow 里 router.getParams()
 * 返回传参：router.back({ params: { 键: 值 } })
 * ============================================================
 */

import { router } from '@kit.ArkUI';

@Entry
@Component
struct DemoRouterReceive {
  // 接收到的参数
  @State name: string = '';
  @State score: number = 0;

  // 页面显示时读取上一页传过来的参数
  onPageShow(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      this.name = params['name'] as string;
      this.score = params['score'] as number;
    }
  }

  build() {
    Column({ space: 16 }) {
      Text('接收页（DemoRouterReceive）')
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

      // 返回并把结果带给上一页
      Button('返回，并把结果传回上一页')
        .onClick(() => {
          // ===== 关键：router.back 也可以带 params =====
          router.back({
            params: { result: `已收到 ${this.name}，分数 ${this.score}` }
          });
        })
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}
