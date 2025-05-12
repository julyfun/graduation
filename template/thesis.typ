#import "../lib.typ": documentclass

#let (
  doctype,
  date,
  twoside,
  anonymous,
  info,
  doc,
  preface,
  mainmatter,
  appendix,
  cover,
  cover-en,
  declare,
  abstract,
  abstract-en,
  outline,
  bib,
  acknowledgement,
  achievement,
  summary-en,
) = documentclass(
  doctype: "bachelor", // 文档类型: "master" | "doctor" | "bachelor"
  date: datetime(year: 2025, month: 6, day: 1), // 日期，如果需要显示今天的日期，可以使用 datetime.today() 函数
  twoside: false, // 双面模式
  anonymous: false, // 盲审模式
  info: (
    student_id: "521260910018",
    name: "方俊杰",
    name_en: "Fang Junjie",
    degree: "学士",
    supervisor: "卢策吾",
    supervisor_en: "Prof. Lu Cewu",
    title: "基于优化的快速、高自由度的机器人运动生成方法",
    title_en: "FAST, HIGH-DEGREE-OF-FREEDOM ROBOTIC MOTION GENERATION METHOD BASED ON OPTIMIZATION",
    school: "巴黎卓越工程师学院",
    school_en: "SJTU Paris Elite Institute of Technology",
    major: "信息工程",
  ),
)

#show: doc

#cover()

#cover-en()

#declare(
  confidentialty-level: "internal", // 保密级别: "public" | "internal" | "secret" | "confidential"
  confidentialty-year: 2, // 保密年份数，请根据保密级别的要求填写
)

#show: preface

#abstract(
  keywords: (
    "学位论文",
    "论文格式",
    "规范化",
    "模板",
  ),
)[
  学位论文是研究生从事科研工作的成果的主要表现，集中表明了作者在研究工作中获得的新的发明、理论或见解，是研究生申请硕士或博士学位的重要依据，也是科研领域中的重要文献资料和社会的宝贵财富。

  为了提高研究生学位论文的质量，做到学位论文在内容和格式上的规范化与统一化，特制作本模板。
]

#abstract-en(keywords: ("dissertation", "dissertation format", "standardization", "template"))[
  As a primary means of demonstrating research findings for postgraduate students, dissertation is a systematic and standardized record of the new inventions, theories or insights obtained by the author in the research work. It can not only function as an important reference when students pursue further studies, but also contribute to scientific research and social development.

  This template is therefore made to improve the quality of postgraduates' dissertations and to further standardize it both in content and in format.
]

#outline()

#show: mainmatter

= 绪论

== 引言

近年来，机器人在运动控制、导航、仓储物流和确定性装配任务等领域取得了突破性进展。现今落地的工业机器人通常依赖大量的手工编码，以执行简单、高度重复的任务。为了解决机器人仍无法执行人类级别灵巧任务的问题，研究者们提出了模仿学习 (Imitation Learning) 和强化学习 (Reinforcement Learning) 等方法来训练机器人操作策略 (Manipulation Policy)。目前已有许多工作能在任意抓取-放置（Pick-and-Place）等简单的灵巧任务上拥有出色的成功率，其中基于视觉-语言-动作 (VLA） 基础模型的策略则在折叠任意衣物、冲泡咖啡等需要自适应能力的任务上取得了显著的进步。

然而，操作任务的策略训练仍然存在许多挑战，包括高质量数据的缺乏和数据收集的高难度。现有的机器人模仿学习方法通常依赖于大量的高质量数据来训练操作策略，研究者们需要使用遥操作等方法来采集现实世界中的数据，这一过程通常使用主从臂架、示教器控制或 VR 头显等高成本设备来实现，不仅会消耗较多的劳动和时间成本，还会带来一定的安全风险，如在遥操作过程中发生碰撞、超出工作空间的情况。



---

遥操作可有效收集数据，可用于机器人模仿学习和强化学习@opentv。现有的遥操作系统大多依赖于特定机械臂，或者无法充分利用不同机械臂的冗余自由度。本项目面向现代策略学习框架，设计通用遥操作接口，可大幅降低遥操作系统在不同硬件间迁移的成本，设计的算法可使机器人臂手运动更平滑，提升收集数据和视觉策略模型或视觉语言策略模型 (VLA)训练的效率.

现有的遥操作系统存在许多问题，主要包括延迟高、末端抖动大、易发生碰撞、难以扩展等。医学手术机器人等精细操作领域对机械臂末端执行器的末端抖动容忍度极低@Tremor，即生理性抖动也可能造成远程操作手术的失败；较高的延迟会导致远程操作者的操作反馈不及时，从而增加了操作者的操作难度和轨迹的连贯度；另外，大部分系统与一个特定的部署环境耦合，无法同时在虚拟环境和现实世界中运行，也难以进行传感器和机械臂硬件的迁移。

== 本文研究主要内容

为应对和上述挑战。

Robot Data Scailing Law

== 本文研究意义

本文......

== 本章小结

本文......

= 格式要求

== 论文正文



以上各部分独立为一部分，每部分应从新的一页开始，且纸质论文应装订在论文的右侧。

== 字数要求

=== 硕士论文要求

各学科和学院自定。

=== 博士论文要求

各学科和学院自定。

== 其他要求

=== 页面设置

页边距：上3.5厘米，下4厘米，左右均为2.5厘米，装订线靠左0.5厘米位置。

页眉：2.5厘米。页脚：3厘米。

无网格。

=== 字体

英文与数字字体要求为Times New Roman。如果英文与数字夹杂出现在黑体中文中，则将英文与数字采用Times New Roman字体再加粗。

== 本章小结

本章介绍了......

= 图表、公式格式

== 图表格式

#figure(
  [
    #figure(
      image(
        "figures/energy-distribution.png",
        width: 70%,
      ),
      gap: 0.3em,
      kind: "image",
      supplement: [图],
      caption: [内热源沿径向的分布], // 中文图例
    )<image> // 图的引用添加在此处
  ],
  gap: 1em,
  kind: "image-en",
  supplement: [Figure],
  caption: [Energy distribution along radial], // 英文图例，本科生模板直接删除即可
)
#v(1em)

// 图的引用请以 img 开头
如 @img:image 所示，......

// 表的引用请以 tbl 开头
我们来看 @tbl:table，

// 因为涉及续表，所以表的实现比较复杂且不易抽象成函数
#let xubiao = state("xubiao")
#figure(
  figure(
    table(
      // 每列比例
      columns: (25%, 25%, 25%, 25%),
      table.header(
        table.cell(
          // 列数
          colspan: 4,
          {
            context if xubiao.get() {
              align(left)[*续@tbl:table*] // 请一定要在末尾给表添加标签(如<table>)，并在此处修改引用
            } else {
              v(-0.6em)
              xubiao.update(true)
            }
          },
        ),
        table.hline(),
        // 表头部分
        [感应频率 #linebreak() (kHz)],
        [感应发生器功率 #linebreak() (%×80kW)],
        [工件移动速度 #linebreak() (mm/min)],
        [感应圈与零件间隙 #linebreak() (mm)],
        table.hline(stroke: 0.5pt),
      ),
      // 表格内容
      ..for i in range(15) {
        ([250], [88], [5900], [1.65])
      },
      table.hline(),
    ),
    kind: "table-en",
    supplement: [Table],
    caption: [XXXXXXX], // 英文表例，本科生模板直接删除
  ),
  gap: 1em,
  kind: "table",
  supplement: [表],
  caption: [高频感应加热的基本参数], // 中文表例
)<table> // 表的引用添加在此处

== 公式格式

// 公式的引用请以 eqt 开头
我要引用 @eqt:equation。

$ 1 / mu nabla^2 Alpha - j omega sigma Alpha - nabla(1 / mu) times (nabla times Alpha) + J_0 = 0 $<equation>

== 本章小结

本章介绍了……

= 全文总结

== 主要结论

本文主要……

== 研究展望

更深入的研究……

// 参考文献
#bib(
  bibfunc: bibliography.with("ref.yaml"),
  full: false,
)// full: false 表示只显示已引用的文献，不显示未引用的文献；true 表示显示所有文献

#show: appendix

// 请根据文档类型，自行选择 if-else 中的内容

#if doctype == "bachelor" [
  = 符号与标记

] else [
  = 实验环境

  == 硬件配置

  ......

  == 软件工具

  ......
]

#if doctype == "bachelor" [
  #achievement(
    papers: (
      "Chen H, Chan C T. Acoustic cloaking in three dimensions using acoustic metamaterials[J]. Applied Physics Letters, 2007, 91:183518.",
      "Chen H, Wu B I, Zhang B, et al. Electromagnetic Wave Interactions with a Metamaterial Cloak[J]. Physical Review Letters, 2007, 99(6):63903.",
    ),
    patents: ("第一发明人, 永动机[P], 专利申请号202510149890.0.",),
  )

  #acknowledgement[
    致谢主要感谢导师和对论文工作有直接贡献和帮助的人士和单位。致谢言语应谦虚诚恳，实事求是。
  ]
] else [
  #acknowledgement[
    致谢主要感谢导师和对论文工作有直接贡献和帮助的人士和单位。致谢言语应谦虚诚恳，实事求是。
  ]

  #achievement(
    papers: (
      "Chen H, Chan C T. Acoustic cloaking in three dimensions using acoustic metamaterials[J]. Applied Physics Letters, 2007, 91:183518.",
      "Chen H, Wu B I, Zhang B, et al. Electromagnetic Wave Interactions with a Metamaterial Cloak[J]. Physical Review Letters, 2007, 99(6):63903.",
    ),
    patents: ("第一发明人, 永动机[P], 专利申请号202510149890.0.",),
  )
]

#summary-en[
  HCCI (Homogenous Charge Compression Ignition)combustion has advantages in terms of efficiency and reduced emission. HCCI combustion can not only ensure both the high economic and dynamic quality of the engine, but also efficiently reduce the NOx and smoke emission. Moreover, one of the remarkable characteristics of HCCI combustion is that the ignition and combustion process are controlled by the chemical kinetics, so the HCCI ignition time can vary significantly with the changes of engine configuration parameters and operating conditions......
]
