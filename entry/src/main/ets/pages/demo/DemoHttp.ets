/**
 * ============================================================
 * 主题⑨：接口调用（http 请求公共 API）
 * ============================================================
 * 网络请求五步走：
 *  1. import http —— 引入网络模块
 *  2. http.createHttp() —— 创建请求对象
 *  3. request(url, 配置) —— 发起请求，返回 Promise
 *  4. 用 .then 处理成功 / .catch 处理失败
 *  5. 用完 httpRequest.destroy() —— 销毁，释放资源
 *
 * 公共测试接口：JSONPlaceholder
 *   GET https://jsonplaceholder.typicode.com/todos
 *   返回一个待办事项数组，无需登录，随便用。
 *
 * 需要在 module.json5 里声明网络权限（本项目已加）：
 *   "requestPermissions": [{ "name": "ohos.permission.INTERNET" }]
 * ============================================================
 */

import { http } from '@kit.NetworkKit';          // 网络请求模块
import { BusinessError } from '@kit.BasicServicesKit'; // 错误类型

// 定义接口返回的数据结构（接口返回 JSON，我们用 interface 描述它的形状）
interface TodoItem {
  userId: number;
  id: number;
  title: string;
  completed: boolean; // 是否已完成
}

@Entry
@Component
struct DemoHttp {
  // loading：是否正在请求（用来显示「加载中」）
  @State loading: boolean = false;
  // todos：接口返回的数据（渲染到列表）
  @State todos: TodoItem[] = [];
  // errorMsg：失败时的错误信息
  @State errorMsg: string = '';

  // ---------- 请求封装 ----------
  fetchTodos(): void {
    this.loading = true;     // 开始请求：显示加载中
    this.errorMsg = '';

    // ① 创建请求对象
    const httpRequest = http.createHttp();

    // ② 发起 GET 请求（request 返回 Promise）
    httpRequest.request(
      'https://jsonplaceholder.typicode.com/todos', // 请求地址
      {
        method: http.RequestMethod.GET,   // 请求方式
        header: { 'Content-Type': 'application/json' },
        connectTimeout: 10000,            // 连接超时（毫秒）
        readTimeout: 10000                // 读取超时（毫秒）
      }
    )
      // ③ 成功回调
      .then((response: http.HttpResponse) => {
        if (response.responseCode === 200) {
          // response.result 是返回内容，先转 string 再 JSON.parse
          const raw = response.result as string;
          // 用 as 把解析结果断言成 TodoItem[]（ArkTS 不支持 any，用断言）
          const list = JSON.parse(raw) as TodoItem[];
          // 只取前 10 条，避免页面太长
          this.todos = list.slice(0, 10);
        } else {
          this.errorMsg = `请求失败，HTTP 状态码: ${response.responseCode}`;
        }
      })
      // ④ 失败回调
      .catch((err: BusinessError) => {
        this.errorMsg = `请求出错: ${err.message}`;
      })
      // ⑤ 不管成功失败都会执行：关掉加载、销毁请求对象
      .finally(() => {
        this.loading = false;
        httpRequest.destroy();
      });
  }

  // 生命周期：页面一出现就自动请求一次
  aboutToAppear(): void {
    this.fetchTodos();
  }

  build() {
    Column({ space: 12 }) {
      // 标题 + 重新请求按钮
      Row() {
        Text('接口调用（公共 API）')
          .fontSize(16)
          .fontWeight(700)
          .layoutWeight(1)
        Button('重新请求')
          .fontSize(12)
          .height(32)
          .onClick(() => {
            this.fetchTodos();
          })
      }
      .width('100%')

      // 加载中：显示转圈
      if (this.loading) {
        Column() {
          LoadingProgress() // 加载动画组件
            .width(40)
            .height(40)
            .color('#4f6ef2')
          Text('加载中…')
            .fontSize(13)
            .fontColor('#888888')
            .margin({ top: 8 })
        }
        .width('100%')
        .padding(40)
      } else if (this.errorMsg.length > 0) {
        // 失败：显示错误信息
        Column() {
          Text(this.errorMsg)
            .fontSize(14)
            .fontColor('#e63946')
          Text('检查网络，或换一个接口地址再试')
            .fontSize(12)
            .fontColor('#888888')
            .margin({ top: 6 })
        }
        .width('100%')
        .padding(24)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 成功：渲染数据列表
        List({ space: 8 }) {
          ForEach(this.todos, (item: TodoItem) => {
            ListItem() {
              Row({ space: 10 }) {
                // 左边：完成状态圆点（颜色区分，再配文字，不只靠颜色）
                Text(item.completed ? '✓' : '✗')
                  .fontSize(16)
                  .fontColor(item.completed ? '#2e9e44' : '#e63946')
                  .width(28)
                  .textAlign(TextAlign.Center)
                // 中间：标题
                Text(item.title)
                  .fontSize(14)
                  .layoutWeight(1)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                // 右边：完成状态文字
                Text(item.completed ? '已完成' : '未完成')
                  .fontSize(11)
                  .fontColor(item.completed ? '#2e9e44' : '#e63946')
              }
              .width('100%')
              .padding(12)
              .backgroundColor(Color.White)
              .borderRadius(10)
            }
          }, (item: TodoItem) => item.id.toString())
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#fafafa')
        .borderRadius(12)
      }

      Text('返回的是 JSON 数组，我们解析后存进 @State todos，再用 List + ForEach 渲染。')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#f5f6fa')
  }
}
