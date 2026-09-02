/**
 * ============================================================
 * 进阶⑤：路由传参（发送页）
 * ============================================================
 * 页面之间跳转时，经常要带数据过去 / 拿数据回来。
 *
 * 发送数据：
 *   router.pushUrl({ url: '目标页', params: { 键: 值 } })
 * 接收返回：
 *   在 onPageShow 里用 router.getParams() 读取（详见本页末尾）
 *
 * 配套页面：DemoRouterReceive（接收页）
 * ============================================================
 */

import { router } from '@kit.ArkUI';

@Entry
@Component
struct DemoRouterSend {
  // 保存「从接收页返回带回来的」结果
  @State backMsg: string = '';

  // 页面每次显示都会调用——这里用来读取返回的参数
  onPageShow(): void {
    // getParams() 返回跳转时塞进来的参数对象
    const params = router.getParams() as Record<string, Object>;
    if (params && params['result']) {
      this.backMsg = params['result'] as string; // 读取返回结果
    }
  }

  build() {
    Column({ space: 16 }) {
      Text('发送页（DemoRouterSend）')
        .fontSize(16)
        .fontWeight(700)

      // 跳转并携带参数
      Button('带参数跳到接收页')
        .onClick(() => {
          // ===== 关键：params 里可以放任意键值 =====
          router.pushUrl({
            url: 'pages/demo/DemoRouterReceive',
            params: {
              name: '易文轩',
              score: 95
            }
          });
        })

      Divider()

      Text('接收页返回回来的结果：')
        .fontSize(13)
        .fontColor('#888888')
      Text(this.backMsg.length > 0 ? this.backMsg : '（暂无返回）')
        .fontSize(16)
        .fontWeight(600)
        .fontColor('#e63946')

      Text('流程：本页 → 跳接收页（带 name/score）→ 接收页点返回（带 result）→ 本页 onPageShow 收到')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f6fa')
  }
}
