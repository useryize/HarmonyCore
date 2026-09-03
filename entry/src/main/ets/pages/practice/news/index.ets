/**
 * ============================================================
 * 新闻列表页面（NewsList）
 * ============================================================
 * 数据来源：东方财富公共新闻接口（免费、无需 Key、支持 HTTPS）
 *   GET https://np-listapi.eastmoney.com/comm/web/getNewsByColumns
 *   参数说明：
 *     column=350   频道：国内要闻（340=要闻 / 350=国内 / 351=国际）
 *     page_size=20 一页条数
 *     fields=...   只取需要的字段（title/summary/showTime/mediaName/image）
 *
 * 和天气页一样，用 http 发请求，解析 JSON 后渲染成列表。
 * 需要在 module.json5 声明 INTERNET 权限（本项目已加）。
 * ============================================================
 */
import { http } from '@kit.NetworkKit';          // 网络请求模块
import { BusinessError } from '@kit.BasicServicesKit'; // 错误类型

// 新闻接口地址（想换频道只需改 column 的值）
const NEWS_API_URL: string =
  'https://np-listapi.eastmoney.com/comm/web/getNewsByColumns' +
  '?client=web&biz=web_news_col&column=350&order=1&needInteractData=0' +
  '&page_index=1&page_size=20&req_trace=news_list' +
  '&fields=code,title,summary,showTime,image,mediaName';

// 一条新闻的数据结构（只声明我们用到的字段）
// 注意：image / summary 是可选的——接口对无图新闻会省略 image 字段，
// 运行时可能为 undefined，渲染时必须做 undefined 守卫，否则 .length 会崩
interface NewsItem {
  code: string;        // 新闻唯一ID（详情页用它请求完整正文）
  title: string;       // 标题
  summary?: string;    // 摘要（可能省略）
  showTime: string;    // 发布时间（如 2026-09-03 10:12:50）
  mediaName: string;   // 来源媒体
  image?: string;      // 缩略图地址（无图新闻会省略该字段，运行时为 undefined）
}

// 接口返回的 JSON 结构（data 字段单独定义成具名 interface，
// ArkTS 不允许直接用对象字面量 { ... } 当类型声明）
interface NewsData {
  list: NewsItem[];
}

interface NewsResponse {
  code: string;
  data: NewsData;
}

@Entry
@Component
struct NewsList {
  @State news: NewsItem[] = [];   // 新闻列表（响应式，渲染到界面）
  @State loading: boolean = false; // 是否加载中
  @State errorMsg: string = '';    // 失败时的错误信息

  // ---------- 加载新闻 ----------
  loadNews(): void {
    this.loading = true;
    this.errorMsg = '';

    // ① 创建请求对象
    const httpRequest = http.createHttp();

    // ② 发起 GET 请求
    httpRequest.request(
      NEWS_API_URL,
      {
        method: http.RequestMethod.GET,
        connectTimeout: 10000, // 连接超时（毫秒）
        readTimeout: 10000       // 读取超时（毫秒）
      }
    )
      // ③ 成功回调
      .then((response: http.HttpResponse) => {
        if (response.responseCode === 200) {
          const data = JSON.parse(response.result as string) as NewsResponse;
          // 接口成功返回 code === '1'，list 里是新闻数组
          if (data.code === '1' && data.data) {
            this.news = data.data.list ?? []; // 没有数据时给空数组，避免报错
          } else {
            this.errorMsg = '新闻接口返回异常';
          }
        } else {
          this.errorMsg = `请求失败，HTTP 状态码: ${response.responseCode}`;
        }
      })
      // ④ 失败回调
      .catch((err: BusinessError) => {
        this.errorMsg = `新闻加载失败: ${err.message}`;
      })
      // ⑤ 不管成功失败：关掉加载、销毁请求对象
      .finally(() => {
        this.loading = false;
        httpRequest.destroy();
      });
  }

  // 页面一出现就自动加载一次
  aboutToAppear(): void {
    this.loadNews();
  }

  build() {
    Column() {
      // ---------- 顶部标题栏 ----------
      Row() {
        Text('新闻列表')
          .fontSize(18)
          .fontWeight(700)
        Blank()
        Button('刷新')
          .fontSize(12)
          .height(28)
          .onClick(() => {
            this.loadNews();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(Color.White)

      // ---------- 加载中 ----------
      if (this.loading) {
        Column() {
          LoadingProgress().width(32).height(32).color('#4f6ef2')
          Text('新闻加载中…')
            .fontSize(13)
            .fontColor('#888888')
            .margin({ top: 8 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.errorMsg.length > 0) {
        // ---------- 失败：显示错误 + 重试 ----------
        Column() {
          Text(this.errorMsg)
            .fontSize(13)
            .fontColor('#e63946')
            .textAlign(TextAlign.Center)
          Button('重试')
            .fontSize(12)
            .margin({ top: 12 })
            .onClick(() => {
              this.loadNews();
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding(24)
      } else if (this.news.length === 0) {
        // ---------- 空数据 ----------
        Text('暂无新闻')
          .fontSize(13)
          .fontColor('#888888')
          .layoutWeight(1)
          .margin({ top: 80 })
      } else {
        // ---------- 新闻列表 ----------
        List({ space: 10 }) {
          ForEach(this.news, (item: NewsItem, index: number) => {
            ListItem() {
              Row({ space: 12 }) {
                // 左：标题 + 来源/时间 + 摘要
                Column({ space: 6 }) {
                  Text(item.title)
                    .fontSize(15)
                    .fontWeight(600)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row({ space: 8 }) {
                    Text(item.mediaName)
                      .fontSize(11)
                      .fontColor('#4f6ef2')
                    Text(item.showTime)
                      .fontSize(11)
                      .fontColor('#999999')
                  }
                  // 有摘要才显示（summary 可能为 undefined，先守卫）
                  if (item.summary !== undefined && item.summary.length > 0) {
                    Text(item.summary)
                      .fontSize(12)
                      .fontColor('#666666')
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                // 右：缩略图（image 可能为 undefined，先守卫；没有图就不显示）
                if (item.image !== undefined && item.image.length > 0) {
                  Image(item.image)
                    .width(96)
                    .height(72)
                    .borderRadius(8)
                    .objectFit(ImageFit.Cover)
                    .backgroundColor('#f0f0f0')
                }
              }
              .width('100%')
              .padding(14)
              .backgroundColor(Color.White)
              .borderRadius(12)
              .border({ width: 1, color: '#eeeeee' })
              .onClick(() => {
                // 点击条目跳转到详情页，只传 code，详情页自己请求完整正文
                this.getUIContext().getRouter().pushUrl({
                  url: 'pages/NewsDetail',
                  params: { code: item.code }
                }).catch((err: BusinessError) => {
                  console.error('跳转详情页失败: ' + err.message);
                });
              })
            }
          }, (item: NewsItem, index: number) => `${index}_${item.title}`)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
