/**
 * ============================================================
 * 新闻详情页（NewsDetail）
 * ============================================================
 * 从列表页点击条目跳转过来，只接收一个 code（新闻ID），
 * 然后通过东方财富详情接口请求完整正文，解析 HTML 后展示。
 *
 * 详情接口（实测可用，无需 Key）：
 *   GET https://newsinfo.eastmoney.com/kuaixun/v2/api/content
 *   参数：newsid={新闻code}&source=web
 *   返回：title / body(HTML正文) / source / author / showtime / images
 *
 * 知识点：
 *  1. router 传参（只传 code）+ router.getParams() 接收
 *  2. http 请求详情接口 + JSON.parse 解析
 *  3. 正则表达式去除 HTML 标签，转纯文本（段落换行 / 实体转义）
 *  4. Scroll 长正文滚动 + Text 换行展示
 * ============================================================
 */
import { http } from '@kit.NetworkKit';              // 网络请求
import { BusinessError } from '@kit.BasicServicesKit'; // 错误类型
import { router } from '@kit.ArkUI';                   // 路由

// 详情接口地址（末尾拼 newsid）
const NEWS_DETAIL_API: string =
  'https://newsinfo.eastmoney.com/kuaixun/v2/api/content?source=web&newsid=';

// 详情接口返回结构（只声明我们用到的字段）
interface NewsDetailResponse {
  newsid: string;
  title: string;
  description: string;
  body: string;       // HTML 格式的正文
  source: string;     // 来源媒体
  author: string;     // 作者
  showtime: string;   // 发布时间
}

/**
 * 把 HTML 正文转成纯文本
 *  - </p> → 双换行（段落间隔）
 *  - <br> → 单换行
 *  - 其余 HTML 标签全部去掉
 *  - &nbsp; &amp; 等实体转成对应字符
 *  - 压缩多余空行
 */
function htmlToPlainText(html: string): string {
  let text: string = html;
  // 1. 段落结束和换行标签 → 换行
  text = text.replace(/<\/p>/gi, '\n\n');
  text = text.replace(/<br\s*\/?>/gi, '\n');
  // 2. 去掉所有剩余 HTML 标签（包括 <!-- 注释 -->）
  text = text.replace(/<[^>]+>/g, '');
  // 3. HTML 实体转义
  text = text.replace(/&nbsp;/g, ' ');
  text = text.replace(/&amp;/g, '&');
  text = text.replace(/&lt;/g, '<');
  text = text.replace(/&gt;/g, '>');
  text = text.replace(/&quot;/g, '"');
  // 4. 压缩 3 个以上连续换行为 2 个（段落之间只留一个空行）
  text = text.replace(/\n{3,}/g, '\n\n');
  return text.trim();
}

@Entry
@Component
struct NewsDetail {
  // ===== 从列表页传过来的新闻 code =====
  @State code: string = '';

  // ===== 详情数据（请求接口后填充）=====
  @State title: string = '';
  @State content: string = '';   // 解析后的纯文本正文
  @State source: string = '';
  @State author: string = '';
  @State showTime: string = '';

  // ===== 加载状态 =====
  @State loading: boolean = true;
  @State errorMsg: string = '';

  aboutToAppear(): void {
    // 读取路由参数（列表页 pushUrl 时只传了 code）
    const params = router.getParams() as Record<string, string>;
    this.code = params['code'] ?? '';
    if (this.code.length > 0) {
      this.loadDetail();
    } else {
      this.errorMsg = '缺少新闻编号，无法加载详情';
      this.loading = false;
    }
  }

  // 请求详情接口，拿到完整正文
  loadDetail(): void {
    this.loading = true;
    this.errorMsg = '';
    const httpRequest = http.createHttp();
    httpRequest.request(NEWS_DETAIL_API + this.code, {
      method: http.RequestMethod.GET,
      header: { 'Content-Type': 'application/json' }
    })
      .then((response: http.HttpResponse) => {
        if (response.responseCode === 200) {
          const result = JSON.parse(response.result as string) as NewsDetailResponse;
          this.title = result.title ?? '';
          this.source = result.source ?? '';
          this.author = result.author ?? '';
          this.showTime = result.showtime ?? '';
          // body 是 HTML，转成纯文本再展示
          this.content = htmlToPlainText(result.body ?? '');
        } else {
          this.errorMsg = '请求失败，状态码：' + response.responseCode;
        }
      })
      .catch((err: BusinessError) => {
        this.errorMsg = '网络错误：' + err.message;
      })
      .finally(() => {
        this.loading = false;
        httpRequest.destroy();
      });
  }

  build() {
    Column() {
      // ---------- 顶部标题栏 ----------
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor('#333333')
          .onClick(() => {
            router.back();
          })
        Text('新闻详情')
          .fontSize(18)
          .fontWeight(700)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        // 右侧占位，让标题居中
        Text('').width(28)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      // ---------- 内容区（三种状态）----------
      if (this.loading) {
        // ① 加载中
        Column({ space: 12 }) {
          LoadingProgress()
            .width(40)
            .height(40)
            .color('#4f6ef2')
          Text('正在加载新闻详情...')
            .fontSize(14)
            .fontColor('#888888')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.errorMsg.length > 0) {
        // ② 加载失败（可重试）
        Column({ space: 16 }) {
          Text('加载失败')
            .fontSize(16)
            .fontColor('#666666')
          Text(this.errorMsg)
            .fontSize(13)
            .fontColor('#999999')
            .textAlign(TextAlign.Center)
          Button('重试')
            .width(120)
            .height(40)
            .fontSize(14)
            .backgroundColor('#4f6ef2')
            .onClick(() => {
              this.loadDetail();
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding({ left: 32, right: 32 })
      } else {
        // ③ 正文（可滚动）
        Scroll() {
          Column({ space: 16 }) {
            // 标题
            Text(this.title)
              .fontSize(22)
              .fontWeight(700)
              .width('100%')
              .fontColor('#1a1a1a')

            // 来源 / 作者 / 时间
            Row({ space: 10 }) {
              if (this.source.length > 0) {
                Text(this.source)
                  .fontSize(12)
                  .fontColor('#4f6ef2')
              }
              if (this.author.length > 0) {
                Text(this.author)
                  .fontSize(12)
                  .fontColor('#888888')
              }
              if (this.showTime.length > 0) {
                Text(this.showTime)
                  .fontSize(12)
                  .fontColor('#999999')
              }
            }
            .width('100%')

            // 分割线
            Divider()
              .color('#eeeeee')
              .strokeWidth(1)

            // 正文（纯文本，\n 自动换行）
            Text(this.content)
              .fontSize(16)
              .fontColor('#333333')
              .lineHeight(30)
              .width('100%')
          }
          .width('100%')
          .padding(16)
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor('#f5f6fa')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
