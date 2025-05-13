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

// [my]
#let blued = it => {
  set text(blue)
  it
}

#let upbold = it => {
  $upright(bold(it))$
}

#show: mainmatter

= 绪论

== 引言

近年来，机器人在运动控制、导航、仓储物流和确定性装配任务等领域取得了突破性进展。现今落地的工业机器人通常依赖大量的手工编码，以执行简单、高度重复的任务。为了解决机器人仍无法执行*人类级别*灵巧任务的问题，研究者们提出了模仿学习 (Imitation Learning) 和强化学习 (Reinforcement Learning) 等方法来训练机器人操作策略 (Manipulation Policy)。目前已有许多工作能在任意抓取-放置（Pick-and-Place）等简单的灵巧任务上拥有出色的成功率@ze20243ddiffusionpolicygeneralizable， 其中基于视觉-语言-动作 (VLA） 基础模型的策略则在折叠任意衣物、冲泡咖啡等需要自适应能力的任务上取得了显著的进步。

然而，操作任务的策略训练仍然存在许多挑战，包括高质量数据的缺乏和数据收集的高难度。现有的机器人模仿学习方法通常依赖于大量的高质量人类演示 (Demonstration) 来训练操作策略，研究者们需要使用遥操作等方法来采集现实世界中的数据，这一过程通常使用主从臂架、示教器控制或 VR 头显等高成本设备来实现，不仅会消耗较多的劳动和时间成本，还会带来一定的安全风险，如在遥操作过程中发生碰撞、超出工作空间的情况。

机器人的不同具身形态也为策略训练带来了挑战。执行操作的机器人通常具有高自由度的机械臂和末端执行器，而不同具身形态导致了不同的自由度、运动学约束和动力学约束，也可能具有不同模态的传感器和执行器。这不仅导致收集数据任务依赖于特定机械臂软件平台，还会导致数据集和策略模型在不同具身形态之间的迁移困难。事实上，操作任务 (Manipulation Task) 的动作往往是多模态的，即对于同一观测，人类可以采取不同的动作来完成任务。直接采用基于回归的监督学习可能导致不稳定的训练，因此，训练策略时应当选取能够建模多模态动作分布的模型。

== 本文研究主要内容

为应对和上述挑战，本研究的核心目标是设计并构建一个通用的演示数据收集系统，并探索合适的策略接口，旨在允许操作者在任意环境中收集高质量的演示数据，[todo] 并探索数据质量和数量对策略的影响，通过策略训练验证系统的有效性。本文的主要研究内容包括：

- *设计通用的机器人运动生成方法：*设计并实现基于优化的机器人无碰撞运动方法和一种在线轨迹生成算法，旨在充分利用不同机械臂的自由度并降低对特定机械臂软件平台的依赖，提高机器人运动的流畅度和安全性，同时提升收集数据的效率和质量，为后续演示设备采集和策略部署奠定基础。
- *设计易于使用和普及的演示接口：*探索合适的物理接口来收集人类演示数据，比较并选定低成本、普及率高的硬件设备来收集充分的视觉-姿态等信息来满足策略学习的需求，并设计易于使用的用户接口，目标是大幅降低操作者的使用门槛和学习成本，探索大规模数据收集的可能性。
- *探索合适的策略模型接口：*比较和选取观测和动作空间的不同表示 (Representation)，使得策略模型能在少量数据微调 (Few-shot fine-tuning) 的条件下在不同具身形态上进行迁移，并验证上述设计的有效性。

为实现上述目标，本文首先设计了一套可自定义优化目标的机器人运动学逆解方案，并提出了一种满足急动度约束的在线插值算法（章节三），可将夹爪或灵巧手动作指令转换为平滑的机械臂关节空间轨迹。在此基础上，本文在移动设备上开发了可用于收集动作数据或用于任意机械臂遥操作的软件接口（章节四），演示了软硬件系统可用于执行大量不同种类的操作任务，并有效提升了数据收集的效率。最后，本文在不同的具身形态上验证了所收集数据和策略接口的有效性，并发现了 [todo] 数据多样性和数量对策略的影响（章节五）。

== 研究意义

本文的研究意义体现在以下几个方面：
- 当前部署在实机上的策略模型执行效果多依赖于机器人厂商提供的运动学生成和控制算法。本文提出的快速、高自由度的运动生成方法可提升数据收集和策略推理阶段机械臂的跟随精度和操作流畅度，从而便于高质量的数据的收集和策略在不同机械臂之间的任务性能比较。
- 本文设计和实现的移动设备演示框架能以较低的学习使用成本推广到用户群体中，其集成的在线视觉定位识别和数据筛查算法能在降低数据后处理阶段的复杂性，有望为大规模数据收集提供一种易于普及的解决方案。
- 本文通过收集大量数据并在视觉、动作表示上进行广泛分析，得出了演示数据多样性的重要性甚于数据量的结论，为后续策略模型优化和数据收集方向提供了参考。

== 本章小结

本章首先概述了机器人在运动控制、导航和确定性任务等领域的发展现状，指出当前工业机器人仍依赖大量手工编码，难以完成人类级别的灵巧操作任务。模仿学习和强化学习等方法的引入为策略训练提供了新的可能性，但高质量数据的稀缺、采集成本高昂以及机器人具身形态的多样性等问题，仍然制约着策略模型的泛化能力和实际应用。

针对这些挑战，本研究提出构建一个通用的演示数据收集系统，并探索高效的策略接口，以降低数据采集门槛并提升策略迁移能力。具体而言，本研究聚焦于三个核心方向：（1）设计基于优化的机器人运动生成方法，提升运动平滑性和安全性；（2）开发低门槛、易普及的演示接口，降低操作者的学习成本；（3）探索适应多模态动作的策略表示，增强模型在少量数据下的迁移能力。

本研究的贡献不仅在于提出了一套高效的遥操作与数据采集框架，还通过实验验证了数据多样性对策略性能的关键影响，为后续研究提供了重要参考。这些工作为机器人策略学习的高效数据收集、跨平台迁移及实际部署奠定了技术基础，对推动机器人灵巧操作的发展具有一定意义。

= 相关工作

== 多目标优化逆向运动学求解器
RelaxedIK提出了一种创新的逆向运动学（IK）求解框架，通过将传统IK问题转化为多目标优化任务，实现了末端执行器位姿精度与运动可行性的平衡。该框架的核心创新在于：(1) 采用基于 Native 编译的高效优化引擎，快速同步处理关节限位、自碰撞检测、环境避障等约束条件；(2) 提出"松弛变量"机制，当理想位姿不可达时自动寻找最近似可行解，避免传统IK算法常见的无解困境；(3) 扩展开发的CollisionIK模块进一步支持动态障碍物避障，使机械臂能在复杂环境中生成连续平滑的运动轨迹。该系统在Baxter、UR5等主流机械臂平台上均能保持较高的实时求解频率。然而，RelaxedIK仅关注机械臂而并未考虑到手腕冗余自由度和灵巧手的运动规划，同时也不支持将不均匀的控制指令转换为频率稳定的关节空间轨迹。

== 基于扩散Transformer的大规模基础模型

RDT-1B作为机器人操作扩散大模型（12亿参数），在46个数据集和数十万级轨迹的预训练基础上，通过ALOHA双手机器人的6000+专项数据微调，提升了机器人操作灵活性与泛化能力。其核心贡献在于：(1) 设计异构动作空间统一编码方法，支持从单臂到双手机器人的跨平台控制；(2) 实现多模态条件的精准对齐，在"倒水至1/3刻度"等未见指令上展现一定语义理解能力；(3) 达到300+动作/秒的实时推理速度，满足高速操作需求。特别值得关注的是，该模型仅需1-5次示范即可学习"擦拭"等新技能，且能处理训练中未出现的物体空间配置。该工作验证了大规模预训练模型在机器人操作中的潜力。

== 基于手持式采集的通用操作接口
UMI框架创新性地提出"手持夹爪+腕部相机"的轻量化数据采集方案，解决了传统示教方法在双手机器人动态操作任务中的数据获取难题。其技术突破包含三个关键设计：(1) 采用GoPro相机与平行夹爪集成的便携设备，支持野外环境下的高动态动作捕捉；(2) 提出相对轨迹动作表示方法，确保人类演示到机器人执行的零样本迁移；(3) 内置运动学约束验证模块，自动过滤不可行的示范数据。实验证明，仅通过改变训练数据，UMI即可支持双手机器人完成倒水、开盖等长周期精细操作。在咖啡杯操作任务中，训练后的扩散策略甚至能泛化至超出训练分布的场景（如将杯子放置于喷泉顶部）。这种"硬件无关"的策略学习范式，为复杂操作技能的快速部署提供了新思路。UMI 开源的硬件接口可用 3D 打印复现，但由于其依赖 GoPro 相机和缺乏在线数据筛选，导致数据收集工作仍需要雇佣受训练人员进行操作，难以规模扩展，且数据筛查和后处理压力较大。

== 本章小结

近年来，机器人操作策略学习在运动规划、多模态感知和技能迁移等方面取得了显著进展。本章围绕逆向运动学求解、视觉语言策略框架和通用数据采集接口三个关键方向，梳理了相关工作的技术突破与现存挑战。

在运动规划方面，RelaxedIK等优化求解器通过松弛约束和实时优化，显著提升了复杂环境下的轨迹生成能力，但针对灵巧手协同操作的高自由度的时序稳定运动生成仍缺乏有效解决方案。RDT、OpenVLA等视觉语言模型通过统一的多模态表示，展现了强大的跨任务泛化能力，验证了大规模数据预训练的可行性。UMI等轻量化采集方案为大规模数据获取提供了新范式，但如何平衡硬件普适性与动作精度仍待探索。

综合现有研究可见，当前机器人操作系统的核心矛盾在于：高泛化能力的策略模型依赖于高质量、多样化的数据，而数据采集效率与质量又受限于硬件适配性、运动规划可靠性等底层技术。这一矛盾在双臂-灵巧手协同操作等复杂任务中尤为突出。为此，本研究将从以下方向突破：首先，开发融合优化求解与在线插值的运动生成框架，解决高自由度系统的实时控制问题；其次，设计跨平台的标准化策略接口，弥合仿真与现实间的语义鸿沟；最终，通过可扩展的数据采集系统，构建支持多任务迁移的演示数据库。这些研究将为推动机器人从单一技能向通用操作能力演进提供关键技术支撑。

= 基于实时优化的轨迹生成

机器人操作策略的部署质量高度依赖于底层运动生成系统的实时性与可靠性。本章节针对高自由度机械臂与灵巧手协同操作场景，提出融合优化求解与在线插值的轨迹生成框架，旨在解决传统方法在复杂约束下的几个核心问题：（1）实时生成可行的机器人运动来满足多个运动目标，并偏好特定目标（2）满足高阶动力学约束的臂-手关节轨迹平滑性保障。这一运动生成方法的设计，为后续工作在不同机械臂和末端执行器上高效收集数据和和验证策略在不同具身形态的迁移提供了基础和便利。

== 手部姿态检测设备原理与选型

本研究虽然在后续阶段设计了新型演示数据收集系统，但在验证运动生成的效率和有效性时，采用了独立且多样的传感器设备来捕获人手根部或手指关节的高自由度姿态，体现了本系统的低耦合和高拓展性。

=== MediaPipe Hands 手部检测器

该检测器是一种基于 MediaPipe (用于构建跨平台机器学习解决方案) 的实时设备上的手部跟踪解决方案，该方案可以从单张的 RGB 图像中预测人体的手部骨架，并且可以用于 AR/VR 应用，且可以使用移动设备相机等通用图像采集设备，避免依赖深度传感器等昂贵设备。

#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(image("figures/hand1.jpg", width: 100%)),
    grid.cell(image("figures/hand2.jpg", width: 100%)),
    grid.cell(image("figures/hand3.jpg", width: 100%)),
    grid.cell(image("figures/hand4.jpg", width: 100%)),
  ),
  caption: "MediaPipe Hands 手部检测器识别不同手势的效果",
)

尽管该方案可在标准硬件上实时运行，但其呈现出显著的延迟和有限的精度问题，手部骨架数据表现出明显抖动，不足以直接用作运动规划的目标点。此外，将图像坐标系中的手部关键点转换为运动规划所需的手根-相机相对位姿存在实质性挑战。若采用PnP等算法获取手根位姿，不仅会引入额外误差，且结果依赖于相机内参，限制了系统的拓展性。Zimmermann等人[1]提出的Hand3D方法能将人手RGB图像直接转换为手部姿态，但其精度仍存在局限，难以满足机械臂末端执行精确运动的需求。

=== HTC VIVE Tracker

HTC VIVE Tracker设备采用Lighthouse激光室内定位技术，以高频率、低延迟提供毫米级的位置信息和0.1°级的姿态信息。佩戴在手腕上，在0.3m范围内以约0.5Hz的频率来回移动。我们采样多组样本，并对其进行FFT计算，如下图所示。



=== 消除抖动信号算法原理

如图所示，0.5Hz处的峰值是固定周期目标运动引起的较大分量。可以看出，手部抖动信号没有固定周期，无法通过低通滤波器去除，因此我们使用卡尔曼滤波器来处理位置数据。

卡尔曼滤波可以通过融合观测信号和状态预测来估计干净的信号。在每个时间步骤，卡尔曼滤波器执行两个步骤：预测和更新。预测步骤使用状态转移方程来估计下一时刻的状态，而更新步骤使用观测数据来修正预测的状态。

$
  x = [x, y, z, v_x, v_y, v_z, q_0, q_1, q_2, q_3, omega_x, omega_y, omega_z]^T
$

$
  x_k = x_(k - 1) + v_(x (k - 1)) Delta t \
  y_k = y_(k - 1) + v_(y (k - 1)) Delta t \
  z_k = z_(k - 1) + v_(z (k - 1)) Delta t \
  v_(x(k)) = v_(x (k - 1)) space.quad v_(y(k)) = v_(y (k - 1)) space.quad v_(z(k)) = v_(z (k - 1))
$

预测步骤：$k$ 时刻的预测值：

$
  x_k^- = F(tilde(x)_(k - 1))
$

其中 $tilde(x)_(k - 1)$ 为上一时刻的最优估计值，其中姿态转移矩阵为：

$
  F_"quat" = mat(
    1, (-Delta t * omega_x) / 2, (-Delta t * omega_y) / 2, (-Delta t * omega_z) / 2, (-Delta t * q_1) / 2, (-Delta t * q_2) / 2, (-Delta t * q_3) / 2;
    (Delta t * omega_x) / 2, 1, (Delta t * omega_z) / 2, (-Delta t * omega_y) / 2, (Delta t * q_0) / 2, (-Delta t * q_3) / 2, (Delta t * q_2) / 2;
    (Delta t * omega_y) / 2, (-Delta t * omega_z) / 2, 1, (Delta t * omega_x) / 2, (Delta t * q_3) / 2, (Delta t * q_0) / 2, (-Delta t * q_1) / 2;
    (Delta t * omega_z) / 2, (Delta t * omega_y) / 2, (-Delta t * omega_x) / 2, 1, (-Delta t * q_2) / 2, (Delta t * q_1) / 2, (Delta t * q_0) / 2;
    0, 0, 0, 0, 1, 0, 0;
    0, 0, 0, 0, 0, 1, 0;
    0, 0, 0, 0, 0, 0, 1;
  )
$

先验误差协方差矩阵 $P_k^- = F P_(k - 1) F^T + Q$，其中 $Q$ 为过程噪声矩阵。

更新步骤:计算卡尔曼增益 $K = P_k^- H^T (H P_k^- H^T + R)^(-1)$，其中 $R$ 为观测噪声矩阵，$H$ 为观测矩阵，有：

$
  H = mat(
    1, 0, 0, 0, 0, 0;
    0, 1, 0, 0, 0, 0;
    0, 0, 1, 0, 0, 0;
  )
$

则最优估计值 $tilde(x)_k = x_k^- + K(z_k - H x_k^-)$，其中 $z_k$ 为观测向量。

后验误差协方差矩阵 $P_k = (I - K H) P_k^-$。根据实验数据，我们选取：

$
  Q &= mat(
    0.1, 0, 0, 0, 0, 0;
    0, 0.1, 0, 0, 0, 0;
    0, 0, 0.1, 0, 0, 0;
    0, 0, 0, 100, 0, 0;
    0, 0, 0, 0, 100, 0;
    0, 0, 0, 0, 0, 100;
  ) \
  R &= mat(
    50, 0, 0;
    0, 50, 0;
    0, 0, 50;
  )
$

由于观测-状态转移和预测均能表示为线性形式，此处没有采用扩展卡尔曼滤波器。在每次获得 VIVE Tracker 的位置数据后进行预测和更新，从而降低原始观测信号的噪声。经过卡尔曼滤波的位置数据频谱如 [todo] 所示：

== 运动学逆解求解器

在本节中，我们为运动学优化问题提供了一种表示，并概述了我们使用的优化结构。考虑一个 $n$ 自由度的机器人，其配置用 $upbold(q) in RR^n$ 表示。

针对 [todo] 本文构建了一个基于二次规划的实时IK求解器，旨在实现高自由度机械臂的运动学逆解。该求解器通过松弛关节限位约束与任务空间误差的加权平衡，建立包含以下要素的优化目标函数：

=== 损失函数设计

$
  upbold(q) = limits("argmin")_q space F(chi (upbold(q))) "s.t." space l_i <= q_i <= u_i
$

损失函数: $f(q) = sum_(i = 1)^(k) w_i f_i (q, Omega_i)$

$
  "任务空间误差" &: lr(||log("FK"(q, Omega)^or)||) \
  "任务空间偏移" &: sum_(i = 1)^(d) w_i lr(|| log("FK"((q_(t - 1), Omega)^(-1)"FK"(q_t, Omega))^or)||) \
  "关节角度偏移" &: sum_(i = 1)^(d) w_i (q_(t - 1) - q_t)^2 \
  // \min_{\Delta q} \|J\Delta q - \Delta x\|^2 + \lambda\|\Delta q\|^2 + \gamma\|\nabla U_{total}\|^2
  "碰撞势场" &: min_(Delta q) J Delta q - Delta x^2 + lambda Delta q^2 + gamma nabla U_("total")^2
$

=== 松弛变量的选取

RelexedIK @wang2023rangedikoptimizationbasedrobotmotion 等工作提出了引入松弛变量

优化问题建模层
构建基于二次规划的实时IK求解器，通过松弛关节限位约束与任务空间误差的加权平衡，建立包含以下要素的优化目标函数：

任务空间跟踪精度：末端执行器位姿误差的L2范数最小化

运动平滑性约束：关节角速度/加速度的连续性惩罚项

碰撞规避条件：基于Signed Distance Field（SDF）的环境距离场约束
该层创新性地将灵巧手指令映射为机械臂腕部姿态的辅助优化目标，实现双臂-灵巧手系统的协同运动规划。

== 在线插值算法

- 稳定控制频率要求
- 满足急动度约束

== 实验设计

== 结果分析

本研究课题聚焦

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

= 数据收集系统

= 策略训练和部署

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
