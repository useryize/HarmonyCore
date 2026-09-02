/**
 * ============================================================
 * 鸿蒙 ArkUI 学习导航首页（Index）
 * ============================================================
 * 本页面是 App 启动后的入口页，用 List 列出所有学习主题，
 * 点击每一项通过 router.pushUrl 跳转到对应示例页面。
 *
 * 涉及语法点：
 *  1. @Entry / @Component：页面级组件装饰器
 *  2. List / ListItem：列表容器
 *  3. ForEach：循环渲染数组
 *  4. router.pushUrl：页面路由跳转
 * ============================================================
 */

import { router } from '@kit.ArkUI';

// 导航数据模型：一条记录 = 一个学习主题
interface DemoItem {
  title: string; // 主题名
  desc: string;  // 一句话说明
  url: string;   // 要跳转的页面路径（对应 main_pages.json 中注册的路径）
}

@Entry
@Component
struct Index {
  // 普通成员变量（非状态）：用于静态数据，不需要 UI 响应刷新
  private demos: DemoItem[] = [
    { title: '① 基础组件', desc: 'Text / Image / Button / TextInput 怎么用', url: 'pages/demo/DemoBasic' },
    { title: '② 容器与列表', desc: 'Column / Row / Stack / List / Scroll 布局', url: 'pages/demo/DemoContainer' },
    { title: '③ @State 状态', desc: '组件内响应式状态 + @Watch 监听', url: 'pages/demo/DemoState' },
    { title: '④ @Prop 父传子', desc: '单向数据流：父变子跟着变', url: 'pages/demo/DemoProp' },
    { title: '⑤ @Link 双向', desc: '父子双向同步，$ 传参', url: 'pages/demo/DemoLink' },
    { title: '⑥ 子传父回调', desc: '子组件调用父组件传入的函数', url: 'pages/demo/DemoCallback' },
    { title: '⑦ @Provide/@Consume', desc: '跨层级共享，不用逐层传参', url: 'pages/demo/DemoProvideConsume' },
    { title: '⑧ AppStorage 共享', desc: '应用级全局状态（跨页面共享）', url: 'pages/demo/DemoAppStorage' },
    { title: '⑨ 接口调用', desc: 'http 请求公共 API 渲染列表', url: 'pages/demo/DemoHttp' },
    { title: '⑩ 电商首页(原)', desc: '之前写的首页原型，已迁移保留', url: 'pages/Ecommerce' }
  ];

  build() {
    Column() {
      // 顶部标题区
      Column() {
        Text('鸿蒙 ArkUI 学习手册')
          .fontSize(22)
          .fontWeight(700)
        Text('每个主题一个独立页面 · 点进去看详细注解')
          .fontSize(13)
          .fontColor('#666666')
          .margin({ top: 6 })
      }
      .width('100%')
      .padding({ top: 24, bottom: 16 })

      // 列表：遍历 demos 数组生成每个主题入口
      List({ space: 10 }) {
        ForEach(this.demos, (item: DemoItem) => {
          ListItem() {
            Row() {
              // 左：主题名 + 说明
              Column({ space: 4 }) {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(600)
                Text(item.desc)
                  .fontSize(12)
                  .fontColor('#888888')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1) // 占满剩余宽度

              // 右：箭头
              Text('›')
                .fontSize(24)
                .fontColor('#cccccc')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .border({ width: 1, color: '#eeeeee' })
          }
          .onClick(() => {
            // 点击跳转对应页面
            router.pushUrl({ url: item.url });
          })
        }, (item: DemoItem) => item.url) // ForEach 的 key 生成函数
      }
      .width('100%')
      .layoutWeight(1) // 占满剩余高度
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
