#import "@preview/touying:0.6.1": *
#import themes.stargazer: *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.4" as fletcher: node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.3.2": *
#import cosmos.clouds: *

#import "../lib.typ": documentclass

#show: show-theorion

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  // align: horizon,
  // config-common(handout: true),
  config-common(frozen-counters: (theorem-counter,)), // freeze theorem counter for animation
  config-info(
    title: [基于优化的快速、高自由度的机器人运动生成方法],
    subtitle: [],
    author: [*答辩人: 方俊杰*],
    date: datetime.today(),
    institution: [#[#set text(18pt); 指导老师：卢策吾]\ \ 上海交通大学巴黎卓越工程师学院],
    logo: emoji.school,
  ),
)


// [my]
// [my.config]
#let tea = false
#let tbl = it => {
  if tea {
    it
  }
}

// [my.heading]
// #show heading.where(level: 1): set heading(numbering: numbly("{1}.", default: "1.1"))
#set heading(numbering: none)
#show heading.where(level: 1): set text(30pt)

// [my.code]
#show raw.where(lang: "cpp"): it => {
  set text(12pt)
  it
}
#show raw.where(block: false): it => box(
  fill: rgb(248, 248, 248),
  outset: 4pt,
  radius: 3pt,
  stroke: 0.5pt + gray,
  it,
)
#show raw.where(block: true): it => box(
  fill: rgb(248, 248, 248),
  outset: 8pt,
  radius: 3pt,
  stroke: 0.5pt + gray,
  it,
)
#show raw: it => box()[
  #set text(font: ("Cascadia Mono", "Sarasa Term SC Nerd"))
  #it
]

// [my.text]
#set text(20pt)
#set text(font: "HarmonyOS Sans SC")

#set list(indent: 0.8em)
#show link: underline

// [my.util]
#let limitation = it => {
  set text(16pt, gray)
  it
} 

#let red-t = it => {
  set text(fill: red)
  it
}

#let work-preview-title = it => {
  set text(fill: blue, weight: 700)
  it
}


#let emp = it => {
  strong(text(fill: red)[#it])
}

#let alert(body, fill: yellow) = {
  // set text(fill: white)
  rect(
    fill: fill,
    inset: 8pt,
    radius: 4pt,
    [*注意:\ #body*],
  )
}

#let hint(body, fill: blue) = {
  rect(
    fill: fill,
    inset: 8pt,
    radius: 4pt,
    [*#body*],
  )
}

#let lin = line(length: 100%, stroke: blue + 2pt)
#let im(p, h: auto) = {
  if p == 0 {
    figure(image("img/image.png", height: h))
  } else if p == 1 {
    figure(image("img/image copy.png", height: h))
  } else {
    figure(image("img/image copy " + str(p) + ".png", height: h))
  }
}

#let box-img(img, width, radius) = {
  box(
    image(img, width: width),
    radius: radius,
    clip: true,
  )
}
// [my.end]

#title-slide()

== Outline <touying:hidden>

- 你好

- 

- 

= 研究背景

== 机器人学进展

#show: magic.bibliography-as-footnote.with(bibliography("ref.yaml", title: none))

- 机器人在导航、物流、确定性装配任务等领域取得了巨大进展。

#figure(
  grid(
    columns: (170pt, 170pt),
    gutter: 10pt,
    grid.cell(box-img("ppt/arm.png", 100%, 12pt)),
    grid.cell(box-img("ppt/sweep.png", 100%, 12pt)),
    grid.cell(box-img("ppt/g1.png", 100%, 12pt)),
    grid.cell(box-img("ppt/repo.png", 100%, 12pt)),
  ),
  caption: none,
  supplement: [图],
)

== 机器人学进展

- 然而，在工业领域落地的操作 (Manipulation) 机器人通常依赖大量的手工编吗，在灵巧任务的表现上不佳。研究者们提出了基于模仿学习和强化学习的方法训练机器人操作策略 (Manipulation Policies)。

#figure(
  grid(
    columns: (160pt, 160pt),
    gutter: 10pt,
    grid.cell(box-img("ppt/dex1.png", 100%, 12pt)),
    grid.cell(box-img("ppt/dex2.png", 100%, 12pt)),
    grid.cell(box-img("ppt/dex3.png", 100%, 12pt)),
    grid.cell(box-img("ppt/dex4.png", 100%, 12pt)),
  ),
  caption: none,
  supplement: [图],
)

== 策略训练的挑战：数据

- 缺乏高质量的数据 @embodimentcollaboration2025openxembodimentroboticlearning

  #limitation[局限性：#red-t[收集数据耗费大量的劳动力]]

#figure(
  grid(
    columns: (260pt, 260pt),
    gutter: 60pt,
    grid.cell(box-img("ppt/vr.png", 100%, 12pt)),
    grid.cell(box-img("ppt/wear.png", 80%, 12pt)),
  ),
  caption: "VR 设备和穿戴式设备可以帮助收集数据，但效率较低、成本偏高，且需要经过复杂的训练",
  supplement: [图],
)

#pagebreak()

- 不同形态的机器人导致了不同的自由度以及#red-t[异构]的数据。 @embodimentcollaboration2025openxembodimentroboticlearning

[todo 数据收集流程]

- 操作任务的动作 (Action) 分布往往是#red-t[多模态]的。 @chi2024diffusionpolicyvisuomotorpolicy

[todo 多模态 pusht 展示]

// 该论文提出了一种融合多目标优化与在线插值的高自由度机器人运动生成方法，并结合低成本硬件设计了新型数据采集系统，整体结构清晰、工程实现完整，在实际部署方面具有实用价值。
// 但是该论文仍有改进空间:
// 创新性一般：所提出的优化方法多为已有方法的组合应用，如多目标优化、轨迹插值、卡尔曼滤波等，其组合虽有效，但缺乏理论上的突破。如第3.2节对RangedIK方法的引用未展示对现有方法的本质改进。
// 缺乏方法与现有工作的系统对比与消融实验：虽然提到了与KDL和MoveIt2的对比，但缺少对单一模块（如在线插值算法、碰撞惩罚函数等）贡献的定量评估。
// 策略模型细节不足：第4.3节介绍的策略接口（如Chunked Diffusion Policy）未提供足够的模型结构、训练设置与对比实验，难以判断其优越性。
// 文中存在模糊性描述：如第1.2节中提到“策略模型能在少量数据微调条件下迁移”，未明确该迁移实验的设置、基准与指标。

== 研究工作预览

#grid(
  columns: (1.5fr, 1fr),
  gutter: 20pt,
  grid.cell[#work-preview-title[I. 跨具身形态的运动生成方法] （论文第三章） \ #v(0.3em) #text(15pt)[目标：构建优化问题和在线插值法，提高数据采集质量和效率]],
  grid.cell[#emp[创新点：]\ #text(15pt)[以理论*最快速度*执行；*高自由度利用*]]
)

#lin

#grid(
  columns: (1.5fr, 1fr),
  gutter: 20pt,
  grid.cell[#work-preview-title[II. 数据收集系统] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建简单快速，易于普及的高质量数据采集和管理系统]],
  grid.cell[#emp[创新点：]\ #text(15pt)[消除复杂的 SLAM 流程，\ *透明*数据处理]]
)

#lin

#grid(
  columns: (1.5fr, 1fr),
  gutter: 20pt,
  grid.cell[#work-preview-title[III. 策略学习框架] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建和训练 EE Pose + Action Chunking 扩散策略，同一套数据可以在不同机器人形态上进行训练]],
  grid.cell[#emp[创新点：]\ #text(15pt)[采用 EE Pose，点云嵌入和*动作分块*]]
)

== 提纲

[todo]

== 运动生成系统架构

#figure(image("ppt/teleop2-2.png", height: 95%))

#place(
  top + left,
  dx: 25pt,
  dy: 43pt,
  rect(stroke: 3pt + red, width: 200pt, height: 100pt, radius: 5pt),
)

== 手部姿态检测设备原理与选型

#grid(
  columns: (1fr, 0.1fr, 1fr),
  grid.cell[
=== HTC VIVE Tracker 

- 手根姿态信息：90Hz
- 低延迟：< 11ms
- 可手持或绑定于手臂
- #limitation[局限性：成本高，信息单一]

#figure(
  grid(
    columns: (1fr, 1fr),
    grid.cell(box-img("ppt/lighthouse.png", 100%, 12pt)),
    grid.cell(box-img("figures/vive.jpg", 60%, 12pt)),
  ),
  caption: none,
  supplement: [图],
)
  ],
  grid.cell[],
  grid.cell[
=== Quest3 VR 头显

- 手根 + 手指姿态信息：60Hz
- 26 自由度
- 沉浸式的数据采集体验 @opentv
- #limitation[局限性：较高延迟，成本和舒适度问题]

#figure(image("figures/vr.jpg", width: 40%))
  ]
)
