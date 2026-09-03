/**
 * ============================================================
 * 主题③：@State 组件内状态（最核心的概念）
 * ============================================================
 * 什么是状态？
 *   界面上的数据（数字、文字、数组…）会变，变了界面要跟着变。
 *   用 @State 标记的变量就是「状态」——它一变，用到它的 UI 自动刷新。
 *
 * 三步理解 @State：
 *   1. 声明：@State 变量名: 类型 = 初始值;
 *   2. 修改：this.变量名 = 新值;  （修改状态）
 *   3. 刷新：UI 上引用它的地方自动重绘（不需要手动 setState）
 *
 * 本页还演示 @Watch：监听某个状态的变化。
 * ============================================================
 */

@Component
export struct DemoState {
  // ---------- ① 基础用法：数字计数器 ----------
  // @State 标记后，count 就是响应式状态，初始值为 0
  @State count: number = 0;

  // ---------- ② 数组状态 ----------
  @State fruits: string[] = ['苹果', '香蕉', '西瓜'];

  // ---------- ③ @Watch 监听 ----------
  // @Watch('方法名') 表示：count 每次变化后，自动调用 onCountChange
  @Watch('onCountChange') @State watchCount: number = 0;
  // 上面是 @Watch + @State 叠写。也可以拆开写：
  // @State watchCount: number = 0;   （不推荐但合法）

  // @Watch 回调方法：参数是变化的属性名（这里是 'watchCount'）
  onCountChange(propName: string): void {
    console.info(`watchCount 变化了，属性名=${propName}, 新值=${this.watchCount}`);
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {

        // ---------- ① 计数器 ----------
        Text('一、@State 数字：点击按钮修改状态')
          .fontSize(14)
          .fontWeight(700)
        Row({ space: 16 }) {
          // 显示状态：count 一变，这里的文字自动更新
          Text(`${this.count}`)
            .fontSize(40)
            .fontWeight(700)
            .fontColor('#4f6ef2')
            .width(80)
            .textAlign(TextAlign.Center)

          Column({ space: 8 }) {
            Button('+1')
              .onClick(() => {
                this.count = this.count + 1; // 修改状态 -> UI 自动刷新
              })
            Button('-1')
              .onClick(() => {
                this.count = this.count - 1;
              })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(12)

        // ---------- ② 数组状态 ----------
        Text('二、@State 数组：增删元素')
          .fontSize(14)
          .fontWeight(700)
        Column({ space: 8 }) {
          // ForEach 渲染 fruits 数组
          ForEach(this.fruits, (item: string, index: number) => {
            Row() {
              Text(item).fontSize(15).layoutWeight(1)
              Button('删除')
                .fontSize(12)
                .height(28)
                .backgroundColor('#e63946')
                .onClick(() => {
                  // splice(位置, 个数)：删除 index 位置的 1 个元素
                  this.fruits.splice(index, 1);
                })
            }
            .width('100%')
            .padding(10)
            .backgroundColor('#fafafa')
            .borderRadius(8)
          }, (item: string, index: number) => item + index)

          Button('添加一个水果')
            .backgroundColor('#4f6ef2')
            .onClick(() => {
              // push：往数组末尾加一个元素
              this.fruits.push(`水果${this.fruits.length + 1}`);
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(12)

        // ---------- ③ @Watch ----------
        Text('三、@Watch 监听状态变化（看 log）')
          .fontSize(14)
          .fontWeight(700)
        Row({ space: 16 }) {
          Text(`watchCount = ${this.watchCount}`).fontSize(20).fontWeight(600)
          Button('改变 watchCount')
            .onClick(() => {
              // 修改后会自动触发 onCountChange（在日志里查看）
              this.watchCount = this.watchCount + 1;
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(16)
        .backgroundColor(Color.White)
        .borderRadius(12)

        Text('⚠ 记忆口诀：@State 只管「自己这个组件内部」，别的组件拿不到。想跨组件共享 → 看后面的 @Prop / @Link / AppStorage。')
          .fontSize(12)
          .fontColor('#888888')
      }
      .width('100%')
      .padding(16)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
