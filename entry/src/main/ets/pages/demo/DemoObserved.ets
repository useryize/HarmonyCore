/**
 * ============================================================
 * 进阶①：@Observed + @ObjectLink —— 对象级深度状态
 * ============================================================
 * 基础篇的 @Prop/@Link 适合简单类型。如果数据是「对象 / 对象数组」，
 * 想让子组件改对象里的某个字段也能触发 UI 刷新，就要用这一对：
 *
 *   @Observed    标记一个 class，让它变成「可被观察」的类
 *   @ObjectLink  子组件里接收父组件传过来的 @Observed 对象
 *
 * 关键区别：
 *   @Prop  复印一份（改不动父的）
 *   @Link  引用同一个简单变量
 *   @ObjectLink  引用同一个【对象】，改对象里的属性，父组件那边也跟着刷新
 *
 * 典型场景：列表里的每一项是一个对象，点某一项，只刷这一项。
 * ============================================================
 */

// ===== ① 用 @Observed 标记这个类，它的属性变化才会被观察到 =====
@Observed
class Fruit {
  name: string = '';       // 水果名
  count: number = 0;       // 数量
  constructor(name: string) {
    this.name = name;
  }
}

@Entry
@Component
struct DemoObserved {
  // 父组件用一个 @State 数组，里面装的是 @Observed 对象
  @State fruits: Fruit[] = [
    new Fruit('苹果'),
    new Fruit('香蕉'),
    new Fruit('西瓜')
  ];

  build() {
    Column({ space: 16 }) {
      Text('父组件（@State 存对象数组）')
        .fontSize(15)
        .fontWeight(700)

      // 渲染列表，每一项用 FruitChild 子组件展示
      List({ space: 8 }) {
        ForEach(this.fruits, (item: Fruit) => {
          ListItem() {
            // ===== 关键：把对象整个传给子组件的 @ObjectLink =====
            FruitChild({ fruit: item })
          }
        }, (item: Fruit) => item.name)
      }
      .width('100%')
      .layoutWeight(1)

      // 父组件也能直接改某个对象的属性（验证联动）
      Button('父组件给"苹果"+1')
        .onClick(() => {
          this.fruits[0].count = this.fruits[0].count + 1;
        })

      Text('点上面按钮，苹果的 count 变化，子组件界面会跟着刷新')
        .fontSize(12)
        .fontColor('#888888')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#f5f6fa')
  }
}

/** 子组件：@ObjectLink 接收 @Observed 对象 */
@Component
struct FruitChild {
  // ===== ② @ObjectLink：引用父组件传进来的同一个对象 =====
  // 不能给初始值；只能接 @Observed 类对象或对象数组里的元素
  @ObjectLink fruit: Fruit;

  build() {
    Row() {
      // 显示对象里的属性
      Column({ space: 4 }) {
        Text(this.fruit.name).fontSize(15).fontWeight(600)
        Text(`数量：${this.fruit.count}`)
          .fontSize(13)
          .fontColor('#4f6ef2')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Button('+1')
        .onClick(() => {
          // ===== ③ 直接改对象属性：因为引用的是同一个对象，
          // 父组件和 UI 都会刷新（这就是 @ObjectLink 的深度观察）=====
          this.fruit.count = this.fruit.count + 1;
        })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
}
