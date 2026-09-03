/**
 * ============================================================
 * 鸿蒙 ArkUI 学习导航首页（Index）
 * ============================================================
 * 本页面是 App 启动后的入口页，用 List 列出所有学习主题，
 * 点击每一项不再跳路由，而是用 bindContentCover 全屏模态弹窗
 * 打开对应组件（原先的独立页面已改造为可复用组件）。
 *
 * 涉及语法点：
 *  1. @Entry / @Component：页面级组件装饰器
 *  2. List / ListItem：列表容器
 *  3. ForEach：循环渲染数组
 *  4. bindContentCover：全屏模态弹窗（弹窗的一种）
 *  5. @Builder：根据选中的 comp 动态渲染对应组件
 * ============================================================
 */

// 引入所有 demo 组件（原先是独立页面，现改造为可复用组件）
import { DemoBasic } from './DemoBasic';
import { DemoContainer } from './DemoContainer';
import { DemoState } from './DemoState';
import { DemoProp } from './DemoProp';
import { DemoLink } from './DemoLink';
import { DemoCallback } from './DemoCallback';
import { DemoProvideConsume } from './DemoProvideConsume';
import { DemoAppStorage } from './DemoAppStorage';
import { DemoHttp } from './DemoHttp';
import { Ecommerce } from './Ecommerce';
import { DemoObserved } from './DemoObserved';
import { DemoBuilder } from './DemoBuilder';
import { DemoStyle } from './DemoStyle';
import { DemoLifecycle } from './DemoLifecycle';
import { DemoRouterSend } from './DemoRouterSend';
import { DemoRouterReceive } from './DemoRouterReceive';
import { DemoAnimation } from './DemoAnimation';
import { DemoTabs } from './DemoTabs';
import { DemoEmitter } from './DemoEmitter';

// import { DemoDialog } from './DemoDialog';

// 导航数据模型：一条记录 = 一个学习主题
interface DemoItem {
  title: string; // 主题名
  desc: string; // 一句话说明
  comp: string; // 要打开的组件标识（不再是路由路径）
}

// 「发送端 ↔ 接收端」两个组件之间互相传递的参数
interface RouterFlowParams {
  name?: string; // 发送端传给接收端的姓名
  score?: number; // 发送端传给接收端的分数
  result?: string; // 接收端回传给发送端的结果
}

@Entry
@Component
struct Index {
  // 普通成员变量（非状态）：用于静态数据，不需要 UI 响应刷新
  private demos: DemoItem[] = [
    { title: '① 基础组件', desc: 'Text / Image / Button / TextInput 怎么用', comp: 'DemoBasic' },
    { title: '② 容器与列表', desc: 'Column / Row / Stack / List / Scroll 布局', comp: 'DemoContainer' },
    { title: '③ @State 状态', desc: '组件内响应式状态 + @Watch 监听', comp: 'DemoState' },
    { title: '④ @Prop 父传子', desc: '单向数据流：父变子跟着变', comp: 'DemoProp' },
    { title: '⑤ @Link 双向', desc: '父子双向同步，$ 传参', comp: 'DemoLink' },
    { title: '⑥ 子传父回调', desc: '子组件调用父组件传入的函数', comp: 'DemoCallback' },
    { title: '⑦ @Provide/@Consume', desc: '跨层级共享，不用逐层传参', comp: 'DemoProvideConsume' },
    { title: '⑧ AppStorage 共享', desc: '应用级全局状态（跨页面共享）', comp: 'DemoAppStorage' },
    { title: '⑨ 接口调用', desc: 'http 请求公共 API 渲染列表', comp: 'DemoHttp' },
    { title: '⑩ XXX', desc: '之前写的首页原型，已迁移保留', comp: 'Ecommerce' },
    // ---------- 进阶篇 ----------
    { title: '⑪ @Observed/@ObjectLink', desc: '对象/数组深度状态观察（进阶）', comp: 'DemoObserved' },
    { title: '⑫ @Builder UI 复用', desc: '自定义构建函数，一块 UI 多处用', comp: 'DemoBuilder' },
    { title: '⑬ @Styles/@Extend', desc: '通用样式与组件专属属性扩展', comp: 'DemoStyle' },
    { title: '⑭ 生命周期', desc: '组件 aboutToAppear / aboutToDisappear 回调', comp: 'DemoLifecycle' },
    { title: '⑮ 组件传参', desc: '发送端 → 接收端传参，再回传结果', comp: 'DemoRouterSend' },
    { title: '⑯ 动画', desc: 'animateTo / animation / transition', comp: 'DemoAnimation' },
    { title: '⑰ Tabs 底部导航', desc: '首页/发现/我的 多页签结构', comp: 'DemoTabs' },
    { title: '⑱ emitter 事件总线', desc: '跨组件/跨页面发布订阅通信', comp: 'DemoEmitter' },
    { title: '⑲ 自定义弹窗', desc: '@CustomDialog 自己造弹窗', comp: 'DemoDialog' }
  ];
  // ===== 弹窗相关状态 =====
  @State isShow: boolean = false; // 是否显示全屏模态弹窗
  @State currentComp: string = ''; // 当前弹窗里要显示的组件标识
  @State routerParams: RouterFlowParams = {}; // ⑮ 发送端/接收端之间传的参数

  // 关闭弹窗（弹窗右上角的关闭按钮 / 各组件内的“返回”都会调用它）
  closePopup(): void {
    this.isShow = false;
  }

  // ===== 根据选中的 comp 动态渲染对应组件 =====
  // 原来的“页面”现在都是普通组件，直接嵌到弹窗里展示
  @Builder
  renderDemo() {
    if (this.currentComp === 'DemoBasic') {
      DemoBasic({
        onClose: () => {
          this.closePopup();
        }
      })
    } else if (this.currentComp === 'DemoContainer') {
      DemoContainer()
    } else if (this.currentComp === 'DemoState') {
      DemoState()
    } else if (this.currentComp === 'DemoProp') {
      DemoProp()
    } else if (this.currentComp === 'DemoLink') {
      DemoLink()
    } else if (this.currentComp === 'DemoCallback') {
      DemoCallback()
    } else if (this.currentComp === 'DemoProvideConsume') {
      DemoProvideConsume()
    } else if (this.currentComp === 'DemoAppStorage') {
      DemoAppStorage()
    } else if (this.currentComp === 'DemoHttp') {
      DemoHttp()
    } else if (this.currentComp === 'Ecommerce') {
      Ecommerce()
    } else if (this.currentComp === 'DemoObserved') {
      DemoObserved()
    } else if (this.currentComp === 'DemoBuilder') {
      DemoBuilder()
    } else if (this.currentComp === 'DemoStyle') {
      DemoStyle()
    } else if (this.currentComp === 'DemoLifecycle') {
      DemoLifecycle()
    } else if (this.currentComp === 'DemoRouterSend') {
      // 发送端：显示接收端回传的 result
      DemoRouterSend({
        backMsg: this.routerParams.result ?? '',
        // 点“传参给接收端”时：父组件存好参数，并把弹窗内容切到接收端
        onNavigateReceive: (name: string, score: number) => {
          this.routerParams = { name: name, score: score };
          this.currentComp = 'DemoRouterReceive';
        },
        onClose: () => {
          this.closePopup();
        }
      })
    } else if (this.currentComp === 'DemoRouterReceive') {
      // 接收端：接收父组件传来的 name/score
      DemoRouterReceive({
        name: this.routerParams.name ?? '',
        score: this.routerParams.score ?? 0,
        // 点“返回并回传结果”时：父组件把 result 交给发送端，并切回发送端
        onNavigateBack: (result: string) => {
          this.routerParams = { result: result };
          this.currentComp = 'DemoRouterSend';
        },
        onClose: () => {
          this.closePopup();
        }
      })
    } else if (this.currentComp === 'DemoAnimation') {
      DemoAnimation()
    } else if (this.currentComp === 'DemoTabs') {
      DemoTabs()
    } else if (this.currentComp === 'DemoEmitter') {
      DemoEmitter()
    } else if (this.currentComp === 'DemoDialog') {
      // DemoDialog()
    }
  }

  // ===== 弹窗内容：组件占满全屏 + 右上角一个关闭按钮 =====
  @Builder
  DemoPopup() {
    Stack({ alignContent: Alignment.TopEnd }) {
      // 内容区：铺满整个弹窗
      Column() {
        this.renderDemo()
      }
      .width('100%')
      .height('100%')

      // 右上角关闭按钮（放在内容之上）
      Text('✕')
        .width(36)
        .height(36)
        .fontSize(16)
        .fontColor(Color.White)
        .backgroundColor('rgba(0, 0, 0, 0.35)')
        .borderRadius(18)
        .margin({ top: 35, right: 40 })
        .onClick(() => {
          this.closePopup();
        })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 30 })
  }

  build() {
    Column() {
      // 顶部标题区
      Column() {
        Text('鸿蒙 ArkUI 学习手册')
          .fontSize(22)
          .fontWeight(700)
        Text('每个主题一个弹窗 · 点击用全屏模态弹窗打开组件')
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
            // 不再跳路由：记录要打开的组件，然后用弹窗打开
            this.currentComp = item.comp;
            this.isShow = true;
          })
        }, (item: DemoItem) => item.comp) // ForEach 的 key 生成函数
      }
      .width('100%')
      .layoutWeight(1) // 占满剩余高度
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
    // ===== 全屏模态弹窗：isShow 为 true 时打开，内容为 DemoPopup =====
    // $$ 双向绑定：系统返回/下滑关闭时，isShow 也会自动变回 false
    .bindContentCover(
      $$this.isShow,
      this.DemoPopup(),
      {
        backgroundColor: '#f5f6fa',
        modalTransition: ModalTransition.DEFAULT
      }
    )
  }
}
