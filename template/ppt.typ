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
    logo: image("ppt/logo.png", width: 30pt),
  ),
)


// [my]
#let upbold = it => {
  $upright(bold(it))$
}

// [my.page]
#import "@preview/grayness:0.2.0": *

// #let data = read("img/ignoreme-19.jpg", encoding: none)

// #set page(background: transparent-image(data, alpha: 50%, width: 100%, height: 100%))


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
#show raw: it => box()[
  #set text(20pt, font: ("Cascadia Mono", "Sarasa Term SC Nerd"))
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

== 研究背景：机器人学进展

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

- 操作任务的动作 (Action) 分布往往是#red-t[多模态]的。 @chi2024diffusionpolicyvisuomotorpolicy
  - 基于几何分析和物理建模的传统方法虽然能适应多种物体，但难以建模不同角度和多种解抓取，且数据收集成本更高。

#figure(image("ppt/pusht.png", height: 40%))

// 该论文提出了一种融合多目标优化与在线插值的高自由度机器人运动生成方法，并结合低成本硬件设计了新型数据采集系统，整体结构清晰、工程实现完整，在实际部署方面具有实用价值。
// 但是该论文仍有改进空间:
// 创新性一般：所提出的优化方法多为已有方法的组合应用，如多目标优化、轨迹插值、卡尔曼滤波等，其组合虽有效，但缺乏理论上的突破。如第3.2节对RangedIK方法的引用未展示对现有方法的本质改进。
// 缺乏方法与现有工作的系统对比与消融实验：虽然提到了与KDL和MoveIt2的对比，但缺少对单一模块（如在线插值算法、碰撞惩罚函数等）贡献的定量评估。
// 策略模型细节不足：第4.3节介绍的策略接口（如Chunked Diffusion Policy）未提供足够的模型结构、训练设置与对比实验，难以判断其优越性。
// 文中存在模糊性描述：如第1.2节中提到“策略模型能在少量数据微调条件下迁移”，未明确该迁移实验的设置、基准与指标。

== 提纲

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

#grid(
  columns: (1.5fr, 1fr),
  gutter: 20pt,
  grid.cell[#work-preview-title[I. 跨具身形态的运动生成方法] （论文第三章） \ #v(0.3em) #text(15pt)[目标：构建优化问题和在线插值法，提高数据采集质量和效率]],
  grid.cell[#emp[创新点：]\ #text(15pt)[以理论*最快速度*执行；*高自由度利用*]]
)

#[
  #set text(gray)

  #line(length: 100%, stroke: blue + 2pt)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 20pt,
    grid.cell[#[II. 数据收集系统] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建简单快速，易于普及的高质量数据采集和管理系统]],
    grid.cell[#[创新点：]\ #text(15pt)[消除复杂的 SLAM 流程，\ 透明数据处理]]
  )

  #line(length: 100%, stroke: gray + 2pt)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 20pt,
    grid.cell[#[III. 策略学习框架] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建和训练 EE Pose + Action Chunking 扩散策略，同一套数据可以在不同机器人形态上进行训练]],
    grid.cell[#[创新点：]\ #text(15pt)[采用 EE Pose，点云嵌入和动作分块]]
  )
]

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
        grid.cell(box-img("ppt/lighthouse.png", 90%, 12pt)),
        grid.cell(box-img("figures/vive.jpg", 50%, 12pt)),
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

#limitation[不同于常见数据采集系统，本文定义了统一的 EE Pose 数据接口，使得末端坐标捕获#red-t[不依赖于特定硬件]。]

== 消除抖动信号

#pagebreak()

#figure(image("ppt/teleop2-2.png", height: 95%))

#place(
  top + left,
  dx: 20pt,
  dy: 168pt,
  rect(stroke: 3pt + red, width: 210pt, height: 110pt, radius: 5pt),
)

采集数据过程中人手的生理性抖动和传感器误差会负面影响数据质量。

#limitation[造成遥操作时机械臂末端的明显抖动，以及采集 in-the-wild 数据时的噪声。]

#figure(
  image("figures/vive-fft.jpg", width: 40%),
  caption: "手部抖动频谱",
  supplement: [图],
) <vive-fft>

#pagebreak()

#limitation[本文独立提出了一种#red-t[六自由度预测的卡尔曼滤波器]，相比于常见滤波方法，#red-t[具有低延迟和高平滑特性 @pei2019elementaryintroductionkalmanfiltering]，尤其是针对较高频率运动信号。]

定义状态 $x$：

$
  x = [x, y, z, v_x, v_y, v_z, q_0, q_1, q_2, q_3, omega_x, omega_y, omega_z]^T
$

#pagebreak()

姿态转移矩阵为：

$
  F_"quat" = mat(
    1, (-omega_x Delta t) / 2, (-omega_y Delta t) / 2, (-omega_z Delta t) / 2, (-q_1 Delta t) / 2, (-q_2 Delta t) / 2, (-q_3 Delta t) / 2;
    (omega_x Delta t) / 2, 1, (omega_z Delta t) / 2, (-omega_y Delta t) / 2, (q_0 Delta t) / 2, (-q_3 Delta t) / 2, (q_2 Delta t) / 2;
    (omega_y Delta t) / 2, (-omega_z Delta t) / 2, 1, (omega_x Delta t) / 2, (q_3 Delta t) / 2, (q_0 Delta t) / 2, (-q_1 Delta t) / 2;
    (omega_z Delta t) / 2, (omega_y Delta t) / 2, (-omega_x Delta t) / 2, 1, (-q_2 Delta t) / 2, (q_1 Delta t) / 2, (q_0 Delta t) / 2;
    0, 0, 0, 0, 1, 0, 0;
    0, 0, 0, 0, 0, 1, 0;
    0, 0, 0, 0, 0, 0, 1;
  )
$

- *更新步骤：*计算卡尔曼增益 $K = P_k^- H^T (H P_k^- H^T + R)^(-1)$，其中 $R$ 为观测噪声矩阵，$H$ 为观测矩阵，有：

$
  H = mat(
    1, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0;
    0, 0, 1, 0, 0, 0;
  )
$

则最优估计值 $tilde(x)_k = x_k^- + K(z_k - H x_k^-)$，其中 $z_k$ 为观测向量。

后验误差协方差矩阵 $P_k = (I - K H) P_k^-$。根据实验数据，选取合适的 $Q, R$ 矩阵。

#pagebreak()

在频谱图中，目标轨迹之外的噪声得到了有效抑制。实践表明，该方法有效#red-t[保留了操作者的执行意图]。

#figure(
  image("figures/vive-fft-filter.jpg", width: 40%),
  caption: "手部抖动频谱",
  supplement: [图],
) <vive-fft-filter>

== 运动学逆解求解器

#figure(image("ppt/teleop2-2.png", height: 95%))

#place(
  top + left,
  dx: 325pt,
  dy: 3pt,
  rect(stroke: 3pt + red, width: 140pt, height: 140pt, radius: 5pt),
)


#grid(
  columns: (1fr, 0.1fr, 1fr),
  grid.cell[
    灵巧手在手腕有两个冗余自由度。人类在抓握物体时，自然而然会使用手腕运动调整抓握姿态，因此在机械臂执行任务时，有必要充分其冗余自由度，减少超幅度运动。

    #figure(
      image("ppt/shadow.png", width: 40%),
      caption: none,
      supplement: [图],
    )
  ],
  grid.cell[],
  grid.cell[
    不同机械臂也拥有不同自由度。
    #figure(
      grid(
        columns: (1fr, 0.5fr),
        gutter: 10pt,
        grid.cell(box-img("ppt/aubo-i5.png", 100%, 12pt)),
        grid.cell(box-img("ppt/flexiv.png", 100%, 12pt)),
      ),
      caption: none,
      supplement: [图],
    )
  ]
)

#limitation[本文提出的运动求解器可#red-t[轻松配置]以#red-t[充分利用]不同机械臂的运动学信息，实现#red-t[一套系统，多种形态]。]

#pagebreak()

=== 任务函数

#limitation[充分考虑多种臂-手配置形态后，本文新设计了一系列#red-t[可针对特定形态调整]的任务函数。]

$
  "任务空间误差" &: lr(||log("FK"(q, Omega)^or)||) \
  "关节空间偏移" &: sum_(i = 1)^(d) w_i lr(|| log("FK"((q_(t - 1), Omega)^(-1)"FK"(q_t, Omega))^or)||) \
  "关节角度偏移" &: sum_(i = 1)^(d) w_i (q_(t - 1) - q_t)^2 \
  // \min_{\Delta q} \|J\Delta q - \Delta x\|^2 + \lambda\|\Delta q\|^2 + \gamma\|\nabla U_{total}\|^2
  P(q) &= cases(
    k dot exp(-alpha dot ("SDF"(q) - d_"safe") / d_"safe") - k space "if" 0 <= "SDF"(q) < d_"safe",
    k dot exp(beta dot ("SDF"(q) - d_"safe") / d_"safe") - k space "if" "SDF"(q) < 0
  )
$

=== 损失函数

为了将任务函数归一化，本文在上述函数形式基础上结合负高斯函数、墙函数和多项式函数，以对特定任务表现出偏好 @wang2023rangedikoptimizationbasedrobotmotion，并在优化过程中提供稳定的梯度。

$
  "谷形函数": f_g (chi, g, c, a_2, m) = -e^(-(chi-g)^2 / 2c^2) + a_2 (chi-g)^m \
  "陷阱函数": f_r (chi, l, u, Omega) = (a_1 + a_2 chi^(l m)) (1 - e^(-chi^n / b^n)) - 1 \
  upbold(q)^* = limits("argmin")_q space sum w_j f_j (chi_j (upbold(q))) "s.t." space l_i <= q_i <= u_i
$

#limitation[本文选取的损失函数是对现有工作的重新思考，并根据设计的任务函数调整。具体而言，任务空间误差使用谷形损失函数，而关节空间和关节角度偏移使用陷阱函数。]

== Jerk-limited 在线插值法

#figure(image("ppt/teleop2-2.png", height: 95%))

#place(
  top + left,
  dx: 330pt,
  dy: 140pt,
  rect(stroke: 3pt + red, width: 170pt, height: 170pt, radius: 5pt),
)

#pagebreak()

本文分析了加速度和急动度对机械臂运动的影响：

- 二阶导数（加速度）是力/扭矩的直接来源。阶跃变化的加速度会引发振荡，影响末端执行器的定位精度，甚至导致电机承受超出设计极限的扭矩，引发机械损坏。
- 三阶导数（急动度，Jerk）是加速度变化率。若过高，会导致加速度和电机电流的突变，引发高频振动。

#limitation[“在线”即可在任意时刻修改运动目标而#red-t[不需要重新规划整个轨迹]，每个控制帧仅生成一个运动路点。相比现有的插值方法，该方法能在给定约束下#red-t[以理论最快速度]到达目标点，满足三阶导约束的同时为逆解结果提供简洁的后处理接口，贴合数据采集需求。]

#pagebreak()

给定目标角度 $d$，约束最大速度 $v_m$，最大加速度 $a_m$，最大急动度 $j_m$。运动过程可分为包含加速度增大、减小与保持的 7 个阶段，本文中我们不假定当前处于某一阶段，而是在计算过程中确定:

$
  j(tau) = cases(
    j_m space "if" 0 <= tau < t_1,
    0 space "if" t_1 <= tau < t_2,
    -j_m space "if" t_2 <= tau < t_3,
    0 space "if" t_3 <= tau < t_4,
    -j_m space "if" t_4 <= tau < t_5,
    0 space "if" t_5 <= tau < t_6,
    j_m space "if" t_6 <= tau <= t_7
  )
$

#pagebreak()

#grid(
  columns: (1fr, 0.1fr, 0.7fr),
  grid.cell[
    === 以 $a_m^2 >= v_m j_m$ 为例
    首先计算三个时间段的临界距离：

    $
      cases(
        d_1 = j_m / 3 (v_m / j_m)^(1.5),
        d_2 = v_m sqrt(v_m / j_m)
      )
    $

    - *子情况 1.1:* $d >= d_2$

    $
      (v_"sug", a_"sug") = (v_m, 0)
    $

  ],
  grid.cell[],
  grid.cell[
    #figure(
      image("figures/4.png", height: 90%),
      caption: "机械臂关节角时间-状态曲线",
      supplement: [图],
    )
  ]
)

#place(
  top + left,
  dx: 718pt,
  dy: 240pt,
  rect(stroke: 2pt + red, width: 12pt, height: 60pt, radius: 0pt),
)

#pagebreak()

#grid(
  columns: (1fr, 0.1fr, 0.7fr),
  grid.cell[
    - *子情况 1.2:* $d >= d_1$

    计算路径的时间积分得到目标点关于 $t$ 的表示：

    $
      p(t) = j_m / 3 (v_m / j_m)^(1.5) - v_m t + j_m sqrt(v_m / j_m) t^2 - j_m / 6 t^3
    $

    求解 $p(t) = d$（牛顿迭代法），然后计算目标速度和加速度：

    $
      cases(
        v_"sug" = -j_m / 2 t^2 + 2 j_m t sqrt(v_m / j_m) - 2 j_m v_m / j_m + v_m,
        a_"sug" = j_m sqrt(v_m / j_m) - j_m (t - sqrt(v_m / j_m))
      )
    $
  ],

  grid.cell[],
  grid.cell[
    #figure(
      image("figures/4.png", height: 90%),
      caption: "机械臂关节角时间-状态曲线",
      supplement: [图],
    )
  ]
)

#place(
  top + left,
  dx: 699pt,
  dy: 240pt,
  rect(stroke: 2pt + red, width: 21pt, height: 60pt, radius: 0pt),
)

#pagebreak()

#grid(
  columns: (1fr, 0.1fr, 0.7fr),
  grid.cell[
    - *子情况 1.3:* $d < d_1$

    $
      cases(
        t_"sug" = 6^(1 / 3) (d / j_m)^(1 / 3),
        v_"sug" = j_m / 2 t_"sug"^2,
        a_"sug" = j_m t_"sug"
      )
    $
  ],

  grid.cell[],
  grid.cell[
    #figure(
      image("figures/4.png", height: 90%),
      caption: "机械臂关节角时间-状态曲线",
      supplement: [图],
    )
  ]
)

#place(
  top + left,
  dx: 688pt,
  dy: 240pt,
  rect(stroke: 2pt + red, width: 12pt, height: 60pt, radius: 0pt),
)

#pagebreak()


得到 $v_"sug", a_"sug"$ 后，算法目标可简化为在一阶导和二阶导约束条件下计算最优二阶导。本文使用@interpolation-best-acceleration 算法计算结果后转换为最优急动度。

#import "@preview/algo:0.3.6": algo, i, d, comment, code

#figure(
  algo(
    title: [
      // note that title and parameters
      #set text(size: 15pt) // can be content
      #emph(smallcaps("Interpolation Best Acceleration"))
    ],
    parameters: ([$x_0, v_0, a_0, x_"tar", v_"tar", f, v_m, a_m$],),
    comment-prefix: [#sym.triangle.stroked.r ],
    comment-styles: (fill: rgb(100%, 0%, 0%)),
    indent-size: 15pt,
    indent-guides: 1pt + gray,
    row-gutter: 15pt,
    column-gutter: 5pt,
    inset: 8pt,
    stroke: 2pt + black,
    fill: none,
  )[
    let $d_h$ = $x_"tar" - (2 x_0 + v_0 \/ f + 0.5 a_0 \/ f^2) / 2.0$\
    $v_0 = v_0 - v_"tar"$\
    let $v_"max"$ = $max(v_"m" - v_"tar", 0.0)$\
    let $v_"min"$ = $min(-v_"m" - v_"tar", 0.0)$\
    let $v_"sug"$ = $max(min(sqrt(2 a_"m" d_h), v_max), -v_"min")$\
    return $max(min((v_"sug" - v_0) f, a_"m"), -a_"m")$
  ],
  supplement: [算法],
  caption: [最优插值加速度],
) <interpolation-best-acceleration>

#pagebreak()

#grid(
  columns: (0.5fr, 0.1fr, 1fr),
  grid.cell[
    右图单元测试表明，该方法能快速追随运动的目标。
  ],
  grid.cell[],
  grid.cell[


    #figure(
      image("figures/4-2.png", width: 78%),
      caption: "在线插值结果，红色曲线为目标轨迹 (1.1s 后与执行轨迹重合）",
      supplement: [图],
    ) <unit-test>
  ]
)

== 实验验证

#pagebreak()


#figure(image("ppt/teleop2-2.png", height: 95%))

#place(
  top + left,
  dx: 325pt,
  dy: 3pt,
  rect(stroke: 3pt + red, width: 176pt, height: 340pt, radius: 5pt),
)

#pagebreak()

我们将本文实现的模块与两种基线方案进行了对比：由 KDL 算法@kdl 和三次多项式插值实现的逆解和规划模块，以及使用 MoveIt2 和 TRAC-IK 实现的基线方法。

消融实验表明，本文方法在 `Kalman filter` 端引入了 $10 plus.minus 2$ms 的延迟，逆解部分，Moveit2 和本文优化器均相较 KDL 有 $20 ~ 30$ms 的延迟增加，但在插值端，本文与三次多项式插值的耗时接近，均小于 $1$ms，而 MoveIt2 耗时超过 $100$ms。

#pagebreak()

[todo]

#pagebreak()

#figure(
  caption: none,
  supplement: [表],
)[
  #table(
    columns: (1.2fr, 1.2fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[][方法][执行延迟 (ms)][`画圆`得分][`画圆`时间 (s)][`抓取胶圈`时间 (s)][`折叠毛巾`时间 (s)],
    [#rotate(-90deg)[VIVE Tracker\ Aubo i5]],
    [_KDL-Tree_\ _MoveIt2_ \ _本文方法_],
    [(执行失败)\ $262 plus.minus 55$\ $bold(105 plus.minus 39)$],
    [/\ $bold(46.7)$\ 38.1],
    [/\ $15.2 plus.minus 4.5$ \ $bold(14.4 plus.minus 2.5)$],
    [/\ $9.8 plus.minus 2.9$ \ $bold(8.3 plus.minus 2.3)$],
    [/\ $18.8 plus.minus 6.5$ \ $bold(18.1 plus.minus 7.9)$],

    [#rotate(-90deg)[Quest 3\ UR10-\ ShadowHand]],
    [_KDL-Tree_\ _MoveIt2_ \ _本文方法_],
    [$bold(164 plus.minus 70)$\ $301 plus.minus 56$ \ $197 plus.minus 50$],
    [$4.1$ \ $7.4$ \ $bold(13.2)$],
    [$17.8 plus.minus 6.3$\ $18.0 plus.minus 6.4$\ $bold(15.4 plus.minus 6.7)$],
    [$10.64 plus.minus 2.0$ \ $11.7 plus.minus 3.0$\ $bold(7.9 plus.minus 2.1)$],
    [$17.3 plus.minus 5.6$ \ $23.1 plus.minus 4.4$\ $bold(13.7 plus.minus 7.1)$],
  )
] <experiment-result>

== 提纲

#[
  #set text(gray)
  #grid(
    columns: (1.5fr, 1fr),
    gutter: 20pt,
    grid.cell[#[I. 跨具身形态的运动生成方法] （论文第三章） \ #v(0.3em) #text(15pt)[目标：构建优化问题和在线插值法，提高数据采集质量和效率]],
    grid.cell[#[创新点：]\ #text(15pt)[以理论最快速度执行；高自由度利用]]
  )
]

#lin

#grid(
  columns: (1.5fr, 1fr),
  gutter: 20pt,
  grid.cell[#work-preview-title[II. 数据收集系统] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建简单快速，易于普及的高质量数据采集和管理系统]],
  grid.cell[#emp[创新点：]\ #text(15pt)[消除复杂的 SLAM 流程，\ *透明*数据处理]]
)

#lin

#[
  #set text(gray)
  #grid(
    columns: (1.5fr, 1fr),
    gutter: 20pt,
    grid.cell[#[III. 策略学习框架] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建和训练 EE Pose + Action Chunking 扩散策略，同一套数据可以在不同机器人形态上进行训练]],
    grid.cell[#[创新点：]\ #text(15pt)[采用 EE Pose，点云嵌入和动作分块]]
  )
]

== Data Scailing Laws in Imitation Learning

- 策略对新对象、新环境的泛化能力随着训练对象-环境对的数量表现出幂律关系：$log(Y) = alpha log(X) + log(beta)$ @lin2025datascalinglawsimitation


#figure(image("ppt/scailing2.png", height: 60%))

== 现有采集数据方法

#grid(
  columns: (1fr, 0.1fr, 1fr),
  grid.cell[
    === 遥操作
    使用特定设备，通过关节映射或运动学逆解的方式将人类操作员的动作映射到运行中的机器人上，可采集视觉和机械臂关节数据。

    #figure(box-img("ppt/data-teleop.png", 40%, 12pt))

    #limitation[局限性：成本、效率、舒适度]
  ],
  grid.cell[],
  grid.cell[
    === 手持夹爪采集数据
    通过在可 3D 打印的手持夹爪上安装多种传感器，即可在广泛环境 (in-the-wild) 中采集 6-DoF 末端姿态数据。

    #figure(box-img("ppt/data-umi.png", 40%, 12pt))


    #limitation[局限性：#red-t[需要复杂的 SLAM 流程，硬件耦合，成本，数据处理压力]]
  ]
)

== 现有研究：Fast-UMI gripper

#figure(image("ppt/fastumi.png", height: 95%))

== 新型数据采集系统

#figure(
  image("figures/collect.png", width: 100%),
  caption: "用户角度的数据采集流程",
  supplement: [图],
)

- 得益于本文开发的运动生成系统，我们的录制数据和遥操作数据可以在#red-t[不同机械臂上部署]，包括 Aubo-i5、UR10 和 Flexiv Rizon 4 等。
- 在策略部署和遥操作模式中，我们均采用本文第三章开发的运动生成库实现跨机械臂流畅控制，开源代码：https://github.com/julyfun/robotoy

== 硬件设计

#figure(image("ppt/iphone.png", height: 55%))

- *相机扩展件：*为#red-t[移动设备]设计的扩展框架，可安装多种手机型号。
- *鱼眼镜头：*旋拧 $210^degree$ 视场角的低成本鱼眼镜头，#red-t[提供足够的时空信息]@chi2024universalmanipulationinterfaceinthewild，取代 Diffusion Policy 和 ACT 等模型使用第一视角和第三视角平面相机的组合。

#pagebreak()

- #red-t[减少元件数量]
- 重量：650g
- 尺寸：$21 times 22 times 26$ cm
- 成本：3D 打印和组装件物料成本约 #red-t[40 元]，鱼眼镜头成本 60 到 90 元

#figure(
  image("figures/robot-gripper.png", height: 50%),
  caption: "可同时作为收集数据设备和推理时的传感器",
  supplement: [图],
)

== ARKit 集成

为了解决 ORB-SLAM3 等 SLAM 方案复杂的标定校正流程，文本结合 ARKit 的多传感器定位技术，直接获取持续的#red-t[图像、点云和末端执行器姿态]数据流。

- 嵌入视觉处理模块，#red-t[利用移动设备算力]识别手持设备和桌面上的基准标记
- 使用 PnP 算法估计桌面到相机的位姿变换
- 位置精度：5mm #h(1em) 姿态精度：0.3°

#figure(
  image("ppt/arkit.png", height: 40%),
  caption: none,
  supplement: [图],
)

== 在线数据筛选

#slide[

  === 逆解模块

  - 植入了基于优化法的逆解模块
  - 在非法运动状态下立即给出#red-t[视觉和语音提示，提升数据采集质量]
  - 算力代价仅为每帧内小于 $20$ 次低秩矩阵运算，其对性能的影响可忽略不计

  #figure(
    grid(
      columns: (1fr, 1fr),
      rows: auto,
      grid.cell(box-img("ppt/urdf2.png", 73%, 10pt)),
      grid.cell(box-img("ppt/urdf1.png", 80%, 10pt)),
    ),
    caption: none,
    supplement: [图],
  ) <calib>
][

  === 标定模块

  - 嵌入标定流程，使用鱼眼镜头模型建模整个相机

  $
    theta_d = theta (1 + k_1 theta^2 + k_2 theta^4 + k_3 theta^6 + k_4 theta^8)
  $

  我们去畸变测试来验证鱼眼镜头建模的有效性:

  #figure(
    grid(
      columns: (1fr, 1fr),
      rows: auto,
      gutter: 3pt,
      grid.cell(box-img("figures/calib0.png", 80%, 10pt)),
      grid.cell(box-img("figures/calib1.png", 80%, 10pt)),
    ),
    caption: none,
    supplement: [图],
  ) <calib>
]

== 遥操作模块

为了便利 Few-shot 迁移，我们设计的遥操作模块通过快速标定和传输末端位姿数据流。

- 降低设备成本
- 提升操作舒适度

#figure(
  caption: "遥操作模式示例",
  supplement: [图],
)[
  #box(
    image("figures/ui-teleop.png", height: 50%),
    radius: 12pt,
    stroke: rgb("#252525") + 1.2pt,
    clip: true,
  )
]

== 提纲

#[
  #set text(gray)
  #grid(
    columns: (1.5fr, 1fr),
    gutter: 20pt,
    grid.cell[[I. 跨具身形态的运动生成方法] （论文第三章） \ #v(0.3em) #text(15pt)[目标：构建优化问题和在线插值法，提高数据采集质量和效率]],
    grid.cell[#[创新点：]\ #text(15pt)[以理论最快速度执行；高自由度利用]]
  )

  #line(length: 100%, stroke: blue + 2pt)

  #grid(
    columns: (1.5fr, 1fr),
    gutter: 20pt,
    grid.cell[[II. 数据收集系统] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建简单快速，易于普及的高质量数据采集和管理系统]],
    grid.cell[#[创新点：]\ #text(15pt)[消除复杂的 SLAM 流程，\ 透明数据处理]]
  )

]

#lin
#grid(
  columns: (1.5fr, 1fr),
  gutter: 20pt,
  grid.cell[#work-preview-title[III. 策略学习框架] （论文第四章） \ #v(0.3em) #text(15pt)[目标：构建和训练 EE Pose + Action Chunking 扩散策略，同一套数据可以在不同机器人形态上进行训练]],
  grid.cell[#emp[创新点：]\ #text(15pt)[采用 EE Pose，点云嵌入和*动作分块*]]
)

== 策略学习框架

#figure(
  image("figures/policy.png", height: 92%),
  caption: "改进的扩散策略（Chunked Diffusion Policy）强化了观察表示，并引入动作分块和平滑策略，以建模演示数据中的非马尔可夫行为。",
  supplement: [图],
) <policy>

#place(
  top + left,
  dx: 85pt,
  dy: 33pt,
  rect(stroke: 3pt + red, width: 200pt, height: 75pt, radius: 5pt),
)

== 数据类型

#figure(
  image("ppt/umi-rel.png", height: 50%),
  caption: [相对和绝对轨迹 @chi2024universalmanipulationinterfaceinthewild],
  supplement: [图],
)

- *绝对关节轨迹 (Absolute Joint Trajectory) *指机械臂各个关节的角度读数序列。
- *相对执行器轨迹 (Relative End-effector Trajactory)* 指末端执行器相对于任务起始时间点的 $"SE"(3)$ 姿态序列。在任务起始时，数据收集设备提供的参考姿态为 $R_0, T_0$，而 $t$ 时刻的姿态为 $R_t, T_t$，则相对姿态定义为:

$
  T_"rel" &= T_t - T_0 \
  R_"rel" &= R_t R_0^T
$

我们改进的扩散策略在训练和推理阶段均采用 EE Pose 作为策略模型观察的一部分，#red-t[消除了夹持器在数据格式定义上的困难和对全局参考系的依赖]。

== 点云嵌入表示

#figure(
  image("figures/policy.png", height: 93%),
  caption: none,
  supplement: [图],
)

#place(
  top + left,
  dx: 85pt,
  dy: 123pt,
  rect(stroke: 3pt + red, width: 204pt, height: 120pt, radius: 5pt),
)

#pagebreak()

- 扩散策略在叠毛巾等对深度估计误差敏感的任务中表现不佳

#figure(
  box-img("ppt/shoes.png", 25%, 12pt),
  caption: "部分任务需要高精度的深度估计",
  supplement: [图],
)

=== 新设计的可选模块

- 通过 3 层 MLP 编码最近 $n$ 帧点云数据
- 将 EE Pose、点云和当前时间步编码后拼接送入 Diffusion 的卷积块
// 交叉注意力
- 图像经过 Resnet18 得到的特征向量作为 Cross Attention 的查询向量

== 动作分块

- 扩散策略的执行轨迹表现为断续执行
- 将 Diffusion policy 学习目标优化为动作序列而不是单步动作
- 采用时序合并 (Temporal Ensemble) 方法，将多个动作块的结果进行加权平均

$
  upbold(a)_"esb" = (sum_(i=1)^n exp(-m (n - i)) upbold(a)_i) / (sum_(i=1)^n exp(-m (n - i)))
$

#figure(
  image("figures/action-chunking2.png", height: 40%),
  caption: "动作分块和时序合并示例。动作的累加权重随时间指数衰减，最近一次预测动作拥有最小权重。",
  supplement: [图],
)

== 实验设计 - 采集效率

- 用户可以在 30 秒内拼装完成并开始收集演示数据
- 对于简单任务，如放置任务（Pick and place），用户录制轨迹数据的间隔平均仅为 10 秒，且仅在手机上就可完成所需操作，对比先前方案：
  - 基于 VR 的遥操作（≈ 30 秒 / 轨迹）
  - 基于示教器遥控的遥操作（≈ 110秒 / 轨迹）

#v(7em)

[todo]

== 实验设计 - 策略模型验证

- 为验证我们的数据收集策略和改进模型的有效性，我们在不同机器人和环境中执行了`摆放插头等物体`、`折叠毛巾`和`安放鞋子`任务。

#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(image("figures/videoframe1.png", width: 100%)),
    grid.cell(image("figures/videoframe2.png", width: 100%)),
    grid.cell(image("figures/videoframe3.png", width: 100%)),
    grid.cell(image("figures/videoframe4.png", width: 100%)),
  ),
  caption: "摆放插头任务示意图",
  supplement: [图],
)

== 真机实验结果

[todo: 视频]

#pagebreak()

#figure(
  caption: [实验结果],
  supplement: [表],
)[

  #table(
    columns: (1.2fr, 1.5fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[执行器][方法][摆放插头\ （成功率%）][摆放插头\ （时间/s）][折叠毛巾\ （成功率%）][折叠毛巾\ （时间/s）],

    [#rotate(-90deg)[Koch1.1\ OV7725 $170^degree$ #h(1em) FOV]],
    [Diffusion Policy\ CDP（本文方法）],
    [$90.0$ \ $bold(93.3)$],
    [$13.1$ \ $bold(7.1)$],
    [$43.3$ \ $bold(66.7)$],
    [$26.8$ \ $bold(10.4)$],
  )
] <res2>

#v(1em)

#figure(
  grid(
    columns: (1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(image("figures/bench1.png", width: 100%)),
    grid.cell(image("figures/bench2.png", width: 100%)),
  ),
  caption: [任务成功率对比。CDP 通过引入动作分块，对视觉信息较复杂的任务提供了更好的观测表示。平滑的执行也使得机械臂完成任务更加稳定，减少了错误累积导致的抓取定位失败。],
  supplement: [图],
)

== 仿真实验结果

- 为了验证改进模块中深度信息编码模块的有效性，我们在 SAPIEN 仿真环境中使用 D435 相机获取点云数据，将其合并到策略模型的观察中。

#figure(
  caption: [实验结果],
  supplement: [表],
)[
  #table(
    columns: (1.2fr, 1.5fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[执行器][方法][摆放杯子\ （成功率%）][摆放杯子\ （时间/s）][安放鞋子\ （得分）][安放鞋子\ （时间/s）],
    [#rotate(-90deg)[Aloha\ Agilex 1\ D435]],
    [3D Diffusion Policy\ CDP（本文方法）],
    [$bold(96)$ \ $94$],
    [$bold(10.4)$ \ $11.5$],
    [$40$ \ $bold(59)$],
    [$23.0$ \ $bold(21.3)$],
  )
] <res2>

#pagebreak()

[todo: 视频]

#pagebreak()


#figure(
  grid(
    columns: (1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(image("figures/bench3.png", width: 100%)),
    grid.cell(image("figures/bench4.png", width: 100%)),
  ),
  caption: [我们的点云编码器使模型能够快速学习任务信息，同时保留了 RGB 视觉信息编码，虽然推理时间更长（$~15$ms / step），但在应对处理鞋盒等不规则物体时，能够提供更稳健的环境信息表示。],
  supplement: [图],
)

== 数据多样性的影响

- 数据集包含约 $1 / 5$ 的失败-复原轨迹数据
- 我们提取了数据集的子集继续进行了若干简单实验
  - 1）通过在数据集中随机采样 $25% ~ 80%$，保持数据多样性的同时减小数据量。
  - 2）仅删除包含失败情况的数据（仅 $20%$），或删除特定姿态范围内的数据，如所有鞋子初始朝右放置的数据。
- 我们发现，仅 $20%$ 的数据多样性缺失即可能导致模型性能显著下降，其影响多倍于数据量减少的影响，如包含 40 条无失败数据的模型训练结果仅与包含 20 条随机数据的模型操作得分接近

== 总结与展望

=== 主要工作

- 实现了一种包含多目标优化与在线插值的运动生成方法
- 开发了一套基于移动设备的低成本、高效率数据采集系统
- 提出了改进的Chunked Diffusion Policy策略模型，引入动作分块、时序合并与可选的点云嵌入表示

=== 未来展望

- 未来研究将致力于设计统一的运动生成API接口，实现中间适配层的自动化配置
- 便携数据收集系统目前仍对用户手机机型有一定限制
- 探索在大规模视觉-语言模型（VLM）基础上微调，使模型能够理解任务语义并生成相应的机器人控制动作
- 基于本研究开发的低成本采集系统，构建一个大规模的机器人操作预训练数据集，涵盖多种机器人平台、多样化任务和环境

== 致谢

#figure(
  grid(
    columns: (140pt, 240pt),
    rows: auto,
    grid.cell(box-img("ppt/lu.png", 73%, 5pt)),
    grid.cell(box-img("ppt/yuanzhi.png", 83%, 5pt)),
  ),
  caption: none,
  supplement: [图],
)

#align(center)[
  #strong[感谢卢策吾老师和元知研究院的学长们对我的培养和支持，\ 感谢老师们对我毕设论文的耐心评阅和宝贵意见！\ 感谢交大和 SPEIT 的培养！]
]
