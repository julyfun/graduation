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
#let reference-block = it => {
  set text(blue)
  it
}

#let upbold = it => {
  $upright(bold(it))$
}

#show raw: set text(12pt)

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

为实现上述目标，本文首先设计了一套可自定义优化目标的机器人运动学逆解方案，并提出了一种满足急动度约束的在线插值算法（章节三），可将夹爪或灵巧手动作指令转换为平滑的机械臂关节空间轨迹。在此基础上，本文在移动设备上开发了可用于收集动作数据或用于任意机械臂遥操作的软件接口，演示了软硬件系统可用于执行大量不同种类的操作任务，并有效提升了数据收集的效率。最后，本文在不同的具身形态上验证了所收集数据和策略接口的有效性，并发现了 [todo] 数据多样性和数量对策略的影响（章节四）。

== 研究意义

本文的研究意义体现在以下几个方面：
- 当前部署在实机上的策略模型执行效果多依赖于机器人厂商提供的运动学生成和控制算法。本文提出的快速、高自由度的运动生成方法可提升数据收集和策略推理阶段机械臂的跟随精度和操作流畅度，从而便于高质量的数据的收集和策略在不同机械臂之间的任务性能比较。
- 本文设计和实现的移动设备演示框架能以较低的学习使用成本推广到用户群体中，其集成的在线视觉定位识别和数据筛查算法能在降低数据后处理阶段的复杂性，有望为大规模数据收集提供一种易于普及的解决方案。
- 本文通过收集大量数据并在视觉、动作表示上进行广泛分析，得出了数据集多样性相比数量对于策略泛化能力更为重要的结论，为后续策略模型优化和数据收集方向提供了参考。

== 本章小结

本章首先概述了机器人在运动控制、导航和确定性任务等领域的发展现状，指出当前工业机器人仍依赖大量手工编码，难以完成人类级别的灵巧操作任务。模仿学习和强化学习等方法的引入为策略训练提供了新的可能性，但高质量数据的稀缺、采集成本高昂以及机器人具身形态的多样性等问题，仍然制约着策略模型的泛化能力和实际应用。

针对这些挑战，本研究提出构建一个通用的演示数据收集系统，并探索高效的策略接口，以降低数据采集门槛并提升策略迁移能力。具体而言，本研究聚焦于三个核心方向：（1）设计基于优化的机器人运动生成方法，提升运动平滑性和安全性；（2）开发低门槛、易普及的演示接口，降低操作者的学习成本；（3）探索适应多模态动作的策略表示，增强模型在少量数据下的迁移能力。

本研究的贡献不仅在于提出了一套高效的遥操作与数据采集框架，还通过实验验证了数据多样性对策略性能的关键影响，为后续研究提供了重要参考。这些工作为机器人策略学习的高效数据收集、跨平台迁移及实际部署奠定了技术基础，对推动机器人灵巧操作的发展具有一定意义。

= 相关工作

== 多目标优化逆向运动学求解器
RangedIK提出了一种创新的逆向运动学（IK）求解框架，通过将传统IK问题转化为多目标优化任务，实现了末端执行器位姿精度与运动可行性的平衡。该框架的核心创新在于：(1) 采用基于 Native 编译的高效优化引擎，快速同步处理关节限位、自碰撞检测、环境避障等约束条件；(2) 提出"松弛变量"机制，当理想位姿不可达时自动寻找最近似可行解，避免传统IK算法常见的无解困境；(3) 扩展开发的CollisionIK模块进一步支持动态障碍物避障，使机械臂能在复杂环境中生成连续平滑的运动轨迹。该系统在Baxter、UR5等主流机械臂平台上均能保持较高的实时求解频率。然而，RangedIK仅关注机械臂而并未考虑到手腕冗余自由度和灵巧手的运动规划，同时也不支持将不均匀的控制指令转换为频率稳定的关节空间轨迹。

== 基于扩散Transformer的大规模基础模型

RDT-1B作为机器人操作扩散大模型（12亿参数），在46个数据集和数十万级轨迹的预训练基础上，通过ALOHA双手机器人的6000+专项数据微调，提升了机器人操作灵活性与泛化能力。其核心贡献在于：(1) 设计异构动作空间统一编码方法，支持从单臂到双手机器人的跨平台控制；(2) 实现多模态条件的精准对齐，在"倒水至1/3刻度"等未见指令上展现一定语义理解能力；(3) 达到300+动作/秒的实时推理速度，满足高速操作需求。特别值得关注的是，该模型仅需1-5次示范即可学习"擦拭"等新技能，且能处理训练中未出现的物体空间配置。该工作验证了大规模预训练模型在机器人操作中的潜力。

== 基于手持式采集的通用操作接口
UMI框架创新性地提出"手持夹爪+腕部相机"的轻量化数据采集方案，解决了传统示教方法在双手机器人动态操作任务中的数据获取难题。其技术突破包含三个关键设计：(1) 采用GoPro相机与平行夹爪集成的便携设备，支持野外环境下的高动态动作捕捉；(2) 提出相对轨迹动作表示方法，确保人类演示到机器人执行的零样本迁移；(3) 内置运动学约束验证模块，自动过滤不可行的示范数据。实验证明，仅通过改变训练数据，UMI即可支持双手机器人完成倒水、开盖等长周期精细操作。在咖啡杯操作任务中，训练后的扩散策略甚至能泛化至超出训练分布的场景（如将杯子放置于喷泉顶部）。这种"硬件无关"的策略学习范式，为复杂操作技能的快速部署提供了新思路。UMI 开源的硬件接口可用 3D 打印复现，但由于其依赖的 GoPro 相机、UR5e 机械臂等硬件价格昂贵，并缺乏在线数据筛选，导致数据收集工作仍需要雇佣受训练人员进行操作，而且数据筛查和后处理压力较大，难以规模化采集数据。

== 本章小结

近年来，机器人操作策略学习在运动规划、多模态感知和技能迁移等方面取得了显著进展。本章围绕逆向运动学求解、视觉语言策略框架和通用数据采集接口三个关键方向，梳理了相关工作的技术突破与现存挑战。

在运动规划方面，RangedIK等优化求解器通过松弛约束和实时优化，显著提升了复杂环境下的轨迹生成能力，但针对灵巧手协同操作的高自由度的时序稳定运动生成仍缺乏有效解决方案。RDT、OpenVLA等视觉语言模型通过统一的多模态表示，展现了强大的跨任务泛化能力，验证了大规模数据预训练的可行性。UMI等轻量化采集方案为大规模数据获取提供了新范式，但如何平衡硬件普适性与动作精度仍待探索。

综合现有研究可见，当前机器人操作系统的核心矛盾在于：高泛化能力的策略模型依赖于高质量、多样化的数据，而数据采集效率与质量又受限于硬件适配性、运动规划可靠性等底层技术。这一矛盾在双臂-灵巧手协同操作等复杂任务中尤为突出。为此，本研究将从以下方向突破：首先，开发融合优化求解与在线插值的运动生成框架，解决高自由度系统的实时控制问题；其次，设计跨平台的标准化策略接口，弥合仿真与现实间的语义鸿沟；最终，通过可扩展的数据采集系统，构建支持多任务迁移的演示数据库。这些研究将为推动机器人从单一技能向通用操作能力演进提供关键技术支撑。

= 基于实时优化的轨迹生成

机器人操作策略的部署质量高度依赖于底层运动生成系统的实时性与可靠性。本章节针对高自由度机械臂与灵巧手协同操作场景，提出融合优化求解与在线插值的轨迹生成框架，旨在解决传统方法在复杂约束下的几个核心问题：（1）实时生成可行的机器人运动来满足多个运动目标，并偏好特定目标;（2）满足高阶动力学约束的臂-手关节轨迹平滑性保障。这一运动生成方法的设计，为后续工作在不同机械臂和末端执行器上高效收集数据和和验证策略在不同具身形态的迁移提供了基础和便利。

== 手部姿态检测设备原理与选型

本研究虽然在后续阶段设计了新型演示数据收集系统，但在验证运动生成的效率和有效性时，采用了独立且多样的传感器设备来捕获人手根部或手指关节的高自由度姿态，体现了本系统的低耦合和高拓展性。

=== MediaPipe Hands 手部检测器

该检测器是一种基于 MediaPipe @zhang2020mediapipehandsondevicerealtime (用于构建跨平台机器学习解决方案) 的实时设备上的手部跟踪解决方案，该方案可以从单张的 RGB 图像中预测人体的手部骨架，并且可以用于 AR/VR 应用，且可以使用移动设备相机等通用图像采集设备，避免依赖深度传感器等昂贵设备。

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
  supplement: [图],
)

尽管该方案可在标准硬件上实时运行，但其呈现出显著的延迟和有限的精度问题，手部骨架数据表现出明显抖动，不足以直接用作运动规划的目标点。此外，将图像坐标系中的手部关键点转换为运动规划所需的手根-相机相对位姿存在实质性挑战。若采用PnP等算法获取手根位姿，不仅会引入额外误差，且结果依赖于相机内参，限制了系统的拓展性。Zimmermann等@zimmermann2017learningestimate3dhand 提出的Hand3D方法能将人手RGB图像直接转换为手部姿态，但其精度仍存在局限，难以满足机械臂末端执行精确运动的需求。

=== HTC VIVE Tracker

HTC VIVE Tracker 采用 SteamVR 灯塔（Lighthouse）追踪技术，基于红外激光扫描与光电传感器阵列（24 个光敏二极管），通过计算激光扫过传感器的精确时间差，实现毫米级 6DoF（六自由度）定位。

- 覆盖角度：270° 视场角（FOV），确保大范围动作捕捉。
- 更新频率：90Hz，低延迟（< 11ms），适用于高速运动追踪。
- 惯性测量单元（IMU）：内置 9 轴传感器，修正光学追踪误差，提升姿态数据可靠性。
- 1/4"-20 UNC 三脚架螺纹接口，兼容 TrackStraps 绑带系统，支持快速固定于肢体或物体。

#figure(
  image("figures/vive.jpg", width: 34%),
  caption: "VIVE 追踪器，可佩戴于手腕",
  supplement: [图],
)

VIVE 追踪器作为一种高精度、低延迟的追踪设备，在第一阶段实验验证中，我们采用 VIVE 追踪器来获取仅含手根姿态的数据。

=== Quest3 VR 头显检测器

Quest 3 头显搭载多颗高分辨率红外摄像头，通过主动红外照明与立体视觉融合技术，实现手部轮廓与关节运动的实时捕捉。

- 基于视觉模型的手势识别算法：采用机器学习训练模型对手部图像进行特征提取与关键点定位，无需外部追踪器，即可实现手部与手指 26 自由度（DoF）高精度追踪。
- 低延迟图像处理单元：集成 Snapdragon XR2 Gen 2 处理器，支持高帧率图像采集与并行推理，确保手部追踪延迟低于 20ms，满足实时交互需求。
- 环境适应性强：系统支持在不同光照条件（自然光、室内灯光）下稳定运行，适配无标记、无手套的裸手追踪环境。

#figure(
  image("figures/vr.jpg", width: 37%),
  caption: "Quest 3 头显和操作手柄",
  supplement: [图],
)

值得注意的是，VR 头显设备可为操作者提供沉浸式的数据采集体验 @opentv，在头戴显示器中，操作者可以直接观察到视觉模型识别到的手部关节姿态。尽管存在成本高、舒适度低和安全性问题（手部容易脱离头显摄像头视野，导致手部姿态数据漂移），但对于采集灵巧手数据的任务，Quest 3 较高精度的手部追踪能力仍具有一定优势。

=== 消除抖动信号算法原理

实践发现，采集数据过程中人手的生理性抖动可能对演示数据或遥操作数据采集质量产生一定影响，并会降低操作流畅度和数据采集效率。

#figure(
  image("figures/vive-fft.jpg", width: 70%),
  caption: "手部抖动频谱分析",
  supplement: [图],
) <vive-fft>

如图所示，小于 1Hz 处的峰值是固定周期目标运动引起的较大分量。可以看出，手部抖动信号没有固定周期，无法通过低通滤波器去除，对此，本文提出了一种可对末端姿态六个自由度均进行平滑的卡尔曼滤波器，且相较于低通滤波器的常量延迟，卡尔曼滤波器在平滑平移目标时可降低延迟@pei2019elementaryintroductionkalmanfiltering。

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

- *预测步骤：*令 $k$ 时刻的预测值为：

$
  x_k^- = F(tilde(x)_(k - 1))
$

其中 $tilde(x)_(k - 1)$ 为上一时刻的最优估计值，其中姿态转移矩阵为：

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

先验误差协方差矩阵 $P_k^- = F P_(k - 1) F^T + Q$，其中 $Q$ 为过程噪声矩阵。

- *更新步骤：*计算卡尔曼增益 $K = P_k^- H^T (H P_k^- H^T + R)^(-1)$，其中 $R$ 为观测噪声矩阵，$H$ 为观测矩阵，有：

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
    0.08, 0, 0, 0, 0, 0;
    0, 0.08, 0, 0, 0, 0;
    0, 0, 0.08, 0, 0, 0;
    0, 0, 0, 100, 0, 0;
    0, 0, 0, 0, 100, 0;
    0, 0, 0, 0, 0, 100;
  ) \
  R &= mat(
    45, 0, 0;
    0, 45, 0;
    0, 0, 45;
  )
$

由于观测-状态转移和预测均能表示为线性形式，本文直接采用与时差相关的转移矩阵来预测和更新手根姿态。在每次获得传感器手根的姿态数据后进行预测和更新，从而降低原始观测信号的噪声。经过卡尔曼滤波的姿态数据频谱如@img:vive-fft-filter 所示，在频谱图中，目标轨迹之外的噪声得到了有效抑制。实践表明，该方法有效保留了操作者的执行意图，并将手持追踪器静止和运动过程中的意外抖动限制到肉眼难以察觉的范围内。

#figure(
  image("figures/vive-fft-filter.jpg", width: 70%),
  caption: "卡尔曼滤波后的手部抖动频谱",
  supplement: [图],
) <vive-fft-filter>

== 运动学逆解求解器

大多数六轴工业机器人通过求解析解或逆运动学的雅可比方法来计算使机械臂末端达到给定位姿的关节配置。后者虽然具有一定的通用性，但应用于冗余度机械臂和欠驱动机械臂时，往往无法计算得最优配置。例如，在 UR10-Shadowhand 臂手系统上，装配于 UR10 机械臂的灵巧手在手腕有两个冗余自由度，而雅可比方法无法充分利用手腕信息，导致目标位姿数据仅需较小姿态偏转就可能导致机械臂六轴的大幅运动，给复杂任务数据收集工作带来困难。此外，当机械臂处于奇异位形时，上述方法可能失效，导致机械臂的不确定性运动。针对上述为，在本节中，我们为运动学优化问题提供一种表示，并概述我们使用的求解器优化结构。该求解器通过松弛关节限位约束与任务空间误差的加权平衡，建立包含多重要素的优化目标函数。

考虑一个 $n$ 自由度的机器人，其配置用 $upbold(q) in RR^n$ 表示。我们用 $chi (upbold(q))$ 表示满足某个运动学目标的任务。

=== 任务函数设计

任务函数: $chi (q) = sum_(j = 1)^(k) chi_j (q, Omega_j)$

任务空间误差指的是末端执行器在给定机械臂配置 $Omega$ 和关节配置下与目标位姿的差异，该误差逆运动学任务中的主要优化目标：

$
  "任务空间误差" &: lr(||log("FK"(q, Omega)^or)||) \
$

在自由度 $>= 6$ 的机械臂配置中，任务空间误差往往存在多个局部最优解，而我们对机械臂的关节运动存在一定偏好，例如在有手腕的臂-手系统中，我们希望优先使用手腕来完成末端执行器的旋转；在欠驱动机械臂中，任务空间误差可能不存在解。我们通过引入任务空间偏移和关节角度偏移损失项来惩罚大幅度运动，最小化能量消耗，并避免机械臂接近奇异位形。通过引入权重项，求解器可在一定程度上偏好灵活度更高的关节，并让确缺失自由度的末端执行器的位置精度高于姿态精度：

$
  "关节空间偏移" &: sum_(i = 1)^(d) w_i lr(|| log("FK"((q_(t - 1), Omega)^(-1)"FK"(q_t, Omega))^or)||) \
  "关节角度偏移" &: sum_(i = 1)^(d) w_i (q_(t - 1) - q_t)^2 \
  // \min_{\Delta q} \|J\Delta q - \Delta x\|^2 + \lambda\|\Delta q\|^2 + \gamma\|\nabla U_{total}\|^2
$

最后，我们引入碰撞势场来避免机械臂与环境发生碰撞。该势场通过有向距离场（Signed Distance Field, SDF）表示，该场对于空间中每一个点，计算到离该点最近的 3D 物体表面的距离，在物体表面外为正值，否之为负值。惩罚函数中 $d_"safe"$ 表示安全距离阈值，$k, alpha, beta$ 可调节惩罚项的强度和衰减速率。在安全距离内随着距离的减小，代价会快速上升：

$
  P(q) = cases(
    0 space "if" "SDF"(q) >= d_"safe",
    k dot exp(-alpha dot ("SDF"(q) - d_"safe") / d_"safe") - k space "if" 0 <= "SDF"(q) < d_"safe",
    k dot exp(beta dot ("SDF"(q) - d_"safe") / d_"safe") - k space "if" "SDF"(q) < 0
  )
$

=== 损失函数设计

RangedIK @wang2023rangedikoptimizationbasedrobotmotion 等工作提出了使用基本的损失函数等组合设计特定目标函数，可在不同类型的任务上表现出更明显的偏好和特性。想要结合以上多个任务，需要将任务函数归一化到均匀范围，例如使用负高斯函数和墙函数。为了，弱化优化过程对初始猜测的敏感程度，可在上述函数形式基础上引入多项式函数，以在解空间中提供稳定的梯度。

- 谷形函数（Groove Function）由负高斯函数和多项式函数组合而成，围绕目标具有狭窄的“凹槽”，在优化过程中表现为偏好精准解。我们使用该函数来优化任务空间误差。

// [ f_g(\chi; g, \Omega) = -e^{-(\chi-g)^2/2c^2} + a_2 (\chi-g)^m ]
$
  f_g (chi, g, c, a_2, m) = -e^(-(chi-g)^2 / 2c^2) + a_2 (chi-g)^m
$

- 陷阱函数（Trap Function）由多项式函数和墙函数组合而成，在优化过程中表现为允许一定范围的解。我们使用该函数来优化关节变化。

// [ f_r(\chi, l, u, \Omega) = (a_1 + a_2 \chi^{lm}) \left( 1 - e^{-\chi^n / b^n} \right) - 1 ]
$
  f_r (chi, l, u, Omega) = (a_1 + a_2 chi^(l m)) (1 - e^(-chi^n / b^n)) - 1
$

#figure(
  grid(
    columns: (1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(image("figures/groove.png", width: 100%)),
    grid.cell(image("figures/swamp.png", width: 100%)),
  ),
  caption: "谷形函数和陷阱函数图像",
  supplement: [图],
) <groove-swamp>

我们使用可视化（例如@img:groove-swamp）估算了参数，并根据机器人行为进行了微调。最终优化目标可表述为如下形式，其中 $J$ 为任务目标总数，$w_j$ 为第 $j$ 个任务目标的权重，$l_i$ 和 $u_i$ 分别为第 $i$ 个关节限位。

$
  upbold(q)^* = limits("argmin")_q space sum_(j = 1)^(J) w_j f_j (chi_j (upbold(q))) "s.t." space l_i <= q_i <= u_i
$

值得一提的是，该优化形式同样适用于灵巧手手指末端姿态的跟随，尤其是传感器的手指自由度与执行器的手指自由度不一致时。本文在实践中使用任务空间误差来优化大拇指姿态，其他手指关节则使用关节角度映射的方式来操作物体。


== 在线插值轨迹生成

上述求解器通过引入关节角度偏移损失项，可有效避免关节角度的大幅度变化，但仍无法保证机械臂运动满足速度、加速度和急动度约束。本文分析了这些约束对机械臂运动的影响：

- 二阶导数（加速度）是力/扭矩的直接来源（牛顿第二定律）。阶跃变化的加速度会引发振荡，影响末端执行器的定位精度，甚至导致电机承受超出设计极限的扭矩，引发机械损坏。
- 三阶导数（急动度，Jerk）是加速度变化率。若过高，会导致加速度和电机电流的突变，引发高频振动。

电机控制固件通常通过 PID 或 LQR 等控制器来限制加速度，但本研究在部分条件下仍然遇到了加速度或急动度超限，从而导致机械臂谐振或触发自碰撞保护机制的问题：

- 控制低成本机械臂（如 Aubo 5i，Koch 等型号机械臂）或机械臂末端执行器惯量较大的情况。
- 需要通过 TCP 透传等底层控制方式降低执行延迟的情况。

为确保机械臂在空间中的运行轨迹正确恰当，多项式插值（Polynomial Interopolation）在工业中的应用十分常见，常用的几种多项式插值法有：线性法、拉格朗日插值法和牛顿插值法。现有方法通常指定少量的参考量，如轨迹上的极值点、起点和终点并给定期望到达时间，无法满足实时操作（如遥操作和策略部署）中高频率修改目标点和“尽快执行”的要求。对此，本文提出了一种能以任意不均匀频率修改轨迹目标点，并在满足同时速度、加速度和急动度约束条件下产生稳定频率轨迹的在线插值算法。

给定当前机械臂任一关节的当前路点（Waypoint），我们的目标是在最短时间内以零速度和零加速度到达目标角度 $d$，其中最大速度 $v_m$，最大加速度 $a_m$，最大急动度 $j_m$ 为机械臂固有参数。若目标速度不为 $0$，可将算法中的初始速度减去目标速度来简化问题。这一过程可分为包含加速度增大、减小与保持的 7 个阶段，本文中我们不假定当前处于某一阶段，而是在计算过程中确定:

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

#figure(
  image("figures/4.png", width: 100%),
  caption: "机械臂关节角时间-状态曲线",
  supplement: [图],
) <jerk-profile>

//
// [ j(\tau) = \begin{cases}
// J_1, & 0 \leq t < t_1 \
// 0, & t_1 \leq t < t_2 \
// -J_3, & t_2 \leq t < t_3 \
// 0, & t_3 \leq t < t_4 \
// -J_5, & t_4 \leq t < t_5 \
// 0, & t_5 \leq t < t_6 \
// J_7, & t_6 \leq t \leq t_7
// \end{cases} ]

考虑上述过程的逆向过程，即以零速度和零加速度为初始状态，以初始路点和速度为目标，计算关节轨迹。首先考虑前四个时间阶段的机械臂运动状态：

*情况 1:* $a_m^2 >= v_m j_m$

该情况下，还没有尚未达到最大加速度时就必须开始减速，因此实际上 $t_2 = 0$，我们首先计算三个时间段的临界距离：

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

- *子情况 1.3:* $d < d_1$

$
  cases(
    t_"sug" = 6^(1 / 3) (d / j_m)^(1 / 3),
    v_"sug" = j_m / 2 t_"sug"^2,
    a_"sug" = j_m t_"sug"
  )
$

情况 2: $a_m^2 < v_m j_m$

定义时间分段:

$
  t_1 = a_m / j_m, quad t_2 = v_m / a_m, quad t_3 = a_m / j_m + v_m / a_m
$

计算临界距离：

$
  cases(
    d_1 = a_m^3 / (6 j_m^2),
    d_2 = a_m^3 / (6 j_m^2) - (a_m v_m) / (2 j_m) + v_m^2 / (2 a_m),
    d_3 = (v_m (a_m^2 + j_m v_m)) / (2 a_m j_m)
  )
$

- *子情况 2.1:* $d >= d_3$

$
  (v_"sug", a_"sug") = (v_m, 0)
$

- *子情况 2.2:* $d >= d_2$

计算路径时间积分：

$
  p(t) = (a_m^6 + j_m^3 v_m^3) / (6 a_m^3 j_m^2) - (a_m^4 + j_m^2 v_m^2) / (2 a_m^2 j_m) t + (a_m^2 + j_m v_m) / (2 a_m) t^2 - j_m / 6 t^3
$

同样用牛顿迭代法求解 $p(t) = d$，得到目标速度和加速度：

$
  cases(
    v_"sug" = -a_m^2 / (2 j_m) + a_m t - j_m / 2 t^2 + (j_m v_m) / a_m t - (j_m v_m^2) / (2 a_m^2),
    a_"sug" = a_m - j_m (t - v_m / a_m)
  )
$

- *子情况 2.3:* $d >= d_1$

$
  cases(
    t_"sug" = (3 a_m^2 + sqrt(3 a_m (-a_m^3 + 24 d j_m^2))) / (6 a_m j_m),
    v_"sug" = -a_m^2 / (2 j_m) + a_m t_"sug",
    a_"sug" = a_m
  )
$

- *子情况 2.4:* $d < d_1$

$
  cases(
    t_"sug" = root(3, (6d) / j_m),
    v_"sug" = j_m / 2 t_"sug"^2,
    a_"sug" = j_m t_"sug"
  )
$

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

单元测试表明，即使追随目标在灵活运动（模拟遥操作或策略部署时目标指令频繁变化的情况），且初始路点和速度均距离目标较远，该算法仍能快速收敛到目标，并与目标保持几乎重合运动。

#figure(
  image("figures/4-2.png", width: 100%),
  caption: "在线插值结果，红色曲线为目标轨迹 (1.1s 后与执行轨迹重合）",
  supplement: [图],
) <unit-test>

== 实验设计

本节针对上述提到的传感器通用接口、基于多目标优化的运动学逆解和在线插值轨迹生成模块进行了实机实验。实验所使用的参数可在本研究的开源实现中找到。我们将本文实现的模块与两种基线方案进行了对比：由 KDL 算法@kdl 和三次多项式插值实现的逆解和规划模块，以及使用 Moveit2 和 TRAC-IK 实现的基线方法。

=== 实现细节

本文实现了包含基于优化的逆运动求解器和在线插值轨迹生成模块的运动生成系统，在给定多个目标（例如末端执行器姿势匹配，平滑的关节运动和避免自碰撞）的情况下，产生可行的运动轨迹。本文尝试验证，通过将关节空间偏移等目标纳入优化目标，规划模块将产生更准确、流畅和可行的动作。另一种广泛使用的逆运动求解器 TRAC-IK 使用多种子值在初始关节空间周围搜索，我们将种子值设置为上一次搜索得到的关节角度。我们的原型实现使用 BFGS 优化方法进行多目标优化，并将算法接口暴露给传感器和机械臂执行模块，对于 UR10-ShadowHand 配置，我们的算法模块同时应用于机械臂和灵巧手的关节路点，并且是唯一可以利用手腕的 2 个冗余自由度的轨迹生成算法。所有评估均在 AMD Ryzen5 7500F 4.1 GHz CPU 和 32 GB RAM 的 Ubuntu 22.04 LTS 系统上运行。

#figure(
  image("figures/teleop2.png", width: 100%),
  caption: "实验系统架构",
  supplement: [图],
) <experiment-platform>

=== 评价指标

我们设计了 3 个操作任务，通过遥操作方法来评价轨迹生成模块的性能: `画圆`、`抓取胶圈`、`折叠毛巾`。在画圆中，机器人末端执行器上固定了画笔，并需要在固定的 A4 大小笔记本上画一个半径 8 厘米的圆圈。这项任务需要非常精确的执行轨迹，尤其在高度方向上，错误的轨迹可能让笔尖远离绘制平面，或者破坏纸张，任务成功的标准是绘制轨迹首尾相接且没有间断。在抓取胶圈中，机器人需要将一个胶圈从桌面上拿起，并放置到另一边，保持胶圈其中一面朝上。折叠毛巾任务则要求机器人将桌面上已经折叠过两次、方向随机摆放的毛巾折叠第三次。所有任务的参考图像如@img:task-example 所示：

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(image("figures/task0.jpg", width: 100%)),
    grid.cell(image("figures/task1.jpg", width: 100%)),
    grid.cell(image("figures/task2.jpg", width: 100%)),
  ),
  caption: "操作任务示例",
  supplement: [图],
) <task-example>

其中，我们设定任务的得分标准为:

$
  "得分" = "成功率" times 100 dot min("目标半径" / "平均半径", space "平均半径" / "目标半径")
$

#figure(
  caption: [实验结果],
  supplement: [表],
)[
  #show table.cell: set text(9pt)
  #show raw: set text(9pt)

  #table(
    columns: (1.2fr, 1.2fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[][方法][执行延迟 (ms)][`画圆`得分][`画圆`时间 (s)][`抓取胶圈`时间 (s)][`折叠毛巾`时间 (s)],
    [#rotate(-90deg)[VIVE Tracker\ Aubo i5]],
    [_KDL-Tree_\ _Moveit2_ \ _本文方法_],
    [(执行失败)\ $262 plus.minus 55$\ $bold(105 plus.minus 39)$],
    [/\ *46.7*\ 38.1],
    [/\ $15.2 plus.minus 4.5$ \ $bold(14.4 plus.minus 2.5)$],
    [/\ $9.8 plus.minus 2.9$ \ $bold(8.3 plus.minus 2.3)$],
    [/\ $18.8 plus.minus 6.5$ \ $bold(18.1 plus.minus 7.9)$],

    [#rotate(-90deg)[Quest 3\ UR10-\ ShadowHand]],
    [_KDL-Tree_\ _Moveit2_ \ _本文方法_],
    [$bold(164 plus.minus 70)$\ $301 plus.minus 56$ \ $197 plus.minus 50$],
    [$4.1$ \ $7.4$ \ $bold(13.2)$],
    [$17.8 plus.minus 6.3$\ $18.0 plus.minus 6.4$\ $bold(15.4 plus.minus 6.7)$],
    [$10.64 plus.minus 2.0$ \ $11.7 plus.minus 3.0$\ $bold(7.9 plus.minus 2.1)$],
    [$17.3 plus.minus 5.6$ \ $23.1 plus.minus 4.4$\ $bold(13.7 plus.minus 7.1)$],
  )
] <experiment-result>

=== 结果分析

如@tbl:experiment-result 所示，两种传感器-机械臂配置据能从本文提出的运动生成方法中收益。与 KDL-Tree 和多项式插值相比，我们的方法产生了更准确、更光滑的机器人运动，在通过底层透传的低延迟方式控制机器人运动的 Aubo i5 机械臂上，不满足加速度限制的轨迹由于机械臂严重谐振而执行失败，尽管基于多目标优化的逆解方法比 KDL-Tree 运动学逆解消耗了更多时间 ($tilde 50$ms)。与 Moveit2 TRAC-IK 方案相比，我们的方法大幅降低了离线轨迹规划所需时间，通过设计多个优化目标和充分利用手腕关节，明显减小了机械臂到达目标位置所需的运动幅度，尤其是在折叠毛巾等需要更多手部动作的灵巧任务时，提供了更低的体感延迟，从而提高了执行任务的效率和成功率。在后续策略部署时，我们同样采用了本章节设计的运动生成方法，并取得了良好的效果。

= 数据收集系统

当前，深度学习在自然语言处理（NLP）和计算机视觉（CV）领域的快速发展很大程度上得益于对数据、模型规模和计算资源的系统性扩展研究，这些研究揭示了明确的*尺度定律*（Scaling Laws）@kaplan2020scalinglawsneurallanguage，并推动了模型泛化能力的提升。然而，机器人技术领域尚未建立类似的扩展规律，特别是在机器人操作 (Manipulation) 任务中，由于缺乏在真实世界中的高质量数据@bahl2022humantorobotimitationwild @chi2024universalmanipulationinterfaceinthewild，策略的泛化能力仍然有限，难以适应真实世界中复杂多变的环境和物体。

一种常见的收集机器人模仿学习数据的方式是通过遥操作 (Teleoperation)，即使用特定设备，通过关节映射或运动学逆解的方式将人类操作员的动作映射到运行中的机器人上，并采集机器人视角的视觉、触觉和关节角度等数据。这一过程中，操作员必须守候在机械臂操作台附近，且仅能通过视觉反馈来调整机器人的动作，因此仍然需要大量的人力来收集数据。对此，有研究人员提出了通用操作接口 (Universal Manipulation Interface, UMI)@chi2024universalmanipulationinterfaceinthewild，通过在可 3D 打印的手持夹爪上安装多种传感器，即可在广泛环境 (in-the-wild) 中采集 6-DoF 末端姿态数据。UMI 凭借其直观的操作方式、便携的硬件设计和较低的组装成本成为一些开源模型@liu2025rdt1bdiffusionfoundationmodel 的选择，但它仍存在一些局限性：

- 与特定硬件耦合。用户必须采购 WeissWSG-50夹持器和 GoPro 相机等设备才能实施 UMI，导致了较高的成本，限制了拥有不同机器人配置的用户使用以及策略在不同具身形态间的迁移。
- ORB-SLAM3 等开源 SLAM 方案虽然可以估计末端夹爪的位姿，但标定校准工作复杂且耗时，且依赖于手持硬件的参数配置，这增加了劳动力成本。
- 由于缺乏采集过程中的预警和操作提示（包括视觉锚点丢失），采集数据质量依赖于操作人员的熟练度，给数据后处理阶段带来了较大的筛查压力。

为了解决 UMI 的限制，本研究围绕两个目标设计开发了一个新系统流程：

- *目标1：*通过软件驱动方式，提升数据收集效率和即插即用能力。我们的研究人员改进了 UMI 的硬件配置，使之同时支持安装包括移动设备在内各种相机，并开发了可插入的柔性指尖扩展件，使得手持设备收集的数据可直接应用于机器人。在此基础上，我们是设计了用户友好的操作接口，仅需在*操作者自己的移动设备应用程序*中即可完成收集数据全流程，无须使用线缆或其他计算设备。
- *目标2：*构建稳健的数据收集生态系统，提升大规模数据采集的可能性。我们在数据采集流程中集成了运动学和视觉算法模块，简化了数据处理，大幅降低了操作者使用成本和数据后处理压力。通过支持末端姿态、执行器状态和关节轨迹等数据，我们的数据集系统致力于支持多样的模仿学习模型或基础模型 (Foundation Model)，包括 Diffusion Policy@chi2024diffusionpolicyvisuomotorpolicy，Action Chunking with Transformers@zhao2023learningfinegrainedbimanualmanipulation 和 $pi_0$ @black2024pi0visionlanguageactionflowmodel。

== 原型设计

=== 硬件框架

手持设备采集的演示数据不含关节信息，从而与机械臂的具体形态解耦。然而，这也给模仿学习带来了困难，例如，缺乏足够的视觉上下文信息，动作指令的模糊性，系统内的延迟差异和不充分的策略表示@chi2024universalmanipulationinterfaceinthewild。我们的原型设计 [todo]

- *指尖扩展件：* [todo]
- *相机扩展件：* [todo] 可安装的 iPhone 包括 6s 到最新的型号。
- *鱼眼镜头：*我们研究人员开发的相机扩展件可以安装轻松安装具有 $210^degree$ 视场角的低成本鱼眼镜头，鱼眼镜头在保证视觉中心分辨率的同时在外围视野中压缩信息，并保持了视觉特征的空间连续性。实验表明，单个鱼眼镜头即可为策略提供足够的时空信息，因而可以取代 Diffusion Policy 和 ACT 等模型使用第一视角和第三视角平面相机的组合。

*总体设计：*[todo] 我们改进的夹持设备重，尺寸为，其中 3D 打印材料的成本为，鱼眼镜头的成本则为 。

=== 软件框架

==== 前端界面

我们为不同功能模式设计了统一的视觉语言，降低操作者的学习门槛。

#figure(
  image("figures/ui.png", width: 75%),
  caption: "用户接口设计",
  supplement: [图],
)

[todo]

- 数据管理

[todo]

==== ARKit 集成和视觉处理

ARKit 是苹果自 iOS 11 开始引入的增强现实技术框架。该框架融合加速度计、陀螺仪、LiDAR等传感数据，借助视觉惯性里程计 Visual–Inertial Odometry (VIO) 和平面检测 (Plane Detection) 等功能，可精确估计设备所在位置以及设备朝向，无需连接传感器等外设，也不需要提前了解所处环境。本文设计的软件框架结合 ARKit 的多传感器定位技术，直接获取持续的图像流和末端执行器姿态流，后者可转换为工具中心点 (TCP) 姿态，用于表示人类演示轨迹。与 UMI 相比，我们的设计通过消除复杂的 SLAM 流程，显著简化了数据处理和采集步骤。此外，本文在 ARKit 数据流中嵌入了视觉处理模块，可利用移动设备算力识别手持设备和桌面上的基准标记，并归一化为连续夹爪动作数据。桌面基准标记是为双臂数据收集设计的，这一部分使用 PnP 算法估计桌面到相机的位姿变换。在性能测试中，A14 芯片（发布于 2020年）在开启全部视觉功能的设置下，仍能以较低的 CPU 占用率（$<40%$）和内存占用（$<=650$ MB）稳定录制 30 帧演示数据。

==== 逆解模块

现有的夹持设备通常由经过训练的专业人员录制人类演示数据。事实上，目前的主流机械臂仍无法于人类手臂的灵巧性相比，因此未经训练的人员在使用加持设备操作时，极易超过机械比关节的速度、加速度和工作空间等限制。我们希望设计的采集系统应允许操作者凭借直觉即可执行多样化的任务，考虑到这一目标，我们在应用程序中植入了基于优化法的逆解模块。该模块在用户操作夹持器的同时，通过机器人运动学文件（URDF 文件）和运动学逆解算法实时解算虚拟机械臂的关节角度，并在目标空间不合法或超出运动学限制时给出视觉和语音提示，指导用户改进数据采集方式。考虑到不同任务可能需要不同的机械臂配置，用户仅需点击切换机器人的描述文件，即可切换到指定任务配置。由于我们使用原生语言编写和交叉编译方案，算力代价仅为每帧内小于 $20$ 次低秩矩阵运算，其对性能的影响可忽略不计。

==== 标定模块

由于本研究在移动设备相机（普通针孔模型）之前加装鱼眼镜头，无法使用厂商提供的镜头内参，因此需要对联合镜头的相机内参进行标定。此处，我们使用单个鱼眼相机模型来建模安装有联合镜头的相机：

//    \theta_d = \theta (1 + k_1 \theta^2 + k_2 \theta^4 + k_3 \theta^6 + k_4 \theta^8)

$
  theta_d = theta (1 + k_1 theta^2 + k_2 theta^4 + k_3 theta^6 + k_4 theta^8)
$

其中，$theta$ 是从相机光轴到入射光线的角度，$theta_d$ 是畸变后的角度。对于相机坐标系下的 3D 点 $(X, Y, Z)$，最终的像素坐标为：

$
  upbold(p)_d = theta_d / sqrt(X^2 + Y^2) dot (X, Y)
$

再经过内参矩阵 $K$ 转换到像素坐标：

$
  upbold(u) = K upbold(p)_d
$

我们去畸变测试（如图 [todo]）来验证鱼眼镜头建模的有效性。标定模块同样拥有用户友好的接口设计，用户可通过拍摄若干张标定板图像来计算相机内参和畸变系数，对于同一相机-鱼眼镜头组合，用户只需标定一次。

==== 遥操作模块

基于大规模数据进行预训练的基础模型在迁移到不同机械臂配置时，通常仍然需要少量示例（Few-shot）微调@liu2025rdt1bdiffusionfoundationmodel。为了便利这一迁移过程，我们设计的遥操作模块通过快速标定和传输末端位姿数据流，允许用户手持移动设备运动来直接控制机械臂-夹爪组合，相比 VIVE Tracker 和 Quest 3 等设备，我们的方案明显降低了设备成本，并提升了操作舒适度。

== 数据采集流程

与依赖复杂 SLAM 算法的原始 UMI 系统不同，我们使用集成 ARKit 的跟踪功能获取观察 (Observation) 和动作 (Action) 数据流。

- *图像数据、夹爪动作：*安装联合镜头的相机以 $1920 times 1440$ 分辨率和 30帧每秒捕捉鱼眼图像，提供广泛的视觉信息。原始图像数据拥有较高的分辨率，考虑到数据存储和传输的效率，以及策略模型图像编码器实际使用的输入尺寸，我们的应用程序首先将图像缩放至 $640 times 480$ 分辨率，并使用 MPEG-4 编码格式存储。用户可调节设置以选择录制图像格式，最高可选择 $1920 times 1440$ 分辨率和 60 帧每秒的帧率。在送入视频编码器前，应用程序会使用相机标定参数，识别和计算得到图像中基准标记的三维坐标，并标准化到 $0$-$1$ 范围内，从而得到与图像同步的夹爪动作信息。
- *深度图数据：*iPhone 12 Pro 以上机型拥有 LiDAR 传感器，其位于后置摄像头附近，ARKit 可通过该传感器提供 $256 times 192 space "@" space 30 "fps"$ 的深度图数据。我们使用 16bit 位深的 PNG 格式存储深度图数据，这是考虑到原始数据分辨率较低，而视频编码格式尽管压缩率较高，但1）其采用的帧间预测（Inter-frame Prediction）不符合自然深度图像的运动规律，如遮挡或新物体出现导致的深度突变；2）有损压缩会丢弃高频信息，如物体边缘的深度跳变被平滑。实践中，使用 PNG 视频存储相比视频编码格式会使单条数据集体积增加约 $60%$，仍在可接受范围内。
- *姿态数据、时间戳*：ARKit融合来自AVFoundation的视频图像信息与来自CoreMotion的设备运动传感数据，再借助于CoreML计算机图像处理与机器学习技术，可实时估计相机的 6-DoF 姿态信息，并以稳定频率更新。由于上述数据来自同一 ARKit 数据帧，因此实现了天然的数据流同步，无需专门测量传感器延迟或在后处理阶段同部数据。

最终，数据收集的步骤如下：

#figure(
  image("figures/collect.png", width: 100%),
  caption: "用户角度的数据采集流程",
  supplement: [图],
)

== 策略模型设计

=== 数据类型概述

绝对关节轨迹指机械臂各个关节的角度读数序列。Diffusion Policy 和 ACT 

== 实验设计

=== 性能测试

=== 结果分析

= 全文总结

== 主要结论

本文主要……

== 研究展望

更深入的研究……

== 公式格式

// 公式的引用请以 eqt 开头
我要引用 @eqt:equation。

$ 1 / mu nabla^2 Alpha - j omega sigma Alpha - nabla(1 / mu) times (nabla times Alpha) + J_0 = 0 $<equation>

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
