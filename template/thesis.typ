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
    "数据采集",
    "扩散策略",
    "多模态动作",
    "运动生成",
  ),
)[
  针对当前机器人操作（Manipulation）领域中大规模高质量数据采集困难的痛点，我们实现了一种结合多目标优化与在线插值的运动生成算法，实验表明，该算法使得各种机械臂在数据收集和推理阶段的运动更灵活和流畅，尤其对于高自由度机械臂。第二阶段，我们开发了一套基于移动设备的低成本、高效率数据采集系统，通过集成AR定位、鱼眼相机和扩展件设计，实现了毫米级精度的执行器姿态录制以及显著的采集提速。为验证采集数据的有效性，我们改进的Chunked Diffusion Policy策略模型提升了观测的表示能力和策略执行的平滑程度。研究结果表明，这套新的数据收集系统能够降低机器人操作数据采集的门槛，为规模化数据采集和预训练策略提供了可行路径。
]

#abstract-en(keywords: ("Data collection", "Diffusion Policy", "Multimodal actions", "Motion generation"))[
  We developed a low-cost, high-efficiency data collection system based on mobile devices. We first designed a motion generation algorithm combining multi-objective optimization with online interpolation. Experiments demonstrate that this algorithm enables more flexible and smoother motion for various robotic arms during both data collection and inference. In the second stage, by integrating AR positioning, fisheye cameras, and an improved gripper design, our system achieves millimeter-level accuracy in end-effector pose capture while significantly accelerating data collection. The proposed Chunked Diffusion Policy model improves the modeling capability for multimodal actions. The results show that our hardware-software integrated system significantly reduces the barriers and costs of robot manipulation data collection, providing a feasible technical pathway toward advancing robotic dexterity to human-like levels.
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

#let box-img(img, width, radius) = {
  box(
    image(img, width: width),
    radius: radius,
    clip: true,
  )
}

#show raw: set text(12pt, font: "Heiti SC")
#show figure.caption: set text(10pt)

#show figure.where(kind: table): set figure.caption(position: top)

#show: mainmatter

= 绪论

== 引言

近年来，机器人在运动控制、导航、仓储物流和确定性装配任务等领域取得了突破性进展。现今落地的工业机器人通常依赖大量的手工编码，以执行简单、高度重复的任务。为了解决机器人仍无法执行*人类级别*灵巧任务的问题，研究者们提出了模仿学习和强化学习等方法来训练机器人操作策略 (Manipulation Policy)。目前已有许多工作能在任意抓取-放置（Pick-and-Place）等简单的灵巧任务上拥有出色的成功率@ze20243ddiffusionpolicygeneralizable， 其中基于视觉-语言-动作 (VLA） 基础模型的策略则在折叠任意衣物、冲泡咖啡等需要自适应能力的任务上取得了显著的进步。

然而，操作任务的策略训练仍然存在许多挑战，包括高质量数据的缺乏和数据收集的高难度。现有的机器人模仿学习方法通常依赖于大量的高质量人类演示 (Demonstration) @levine2016learninghandeyecoordinationrobotic @cabi2020scalingdatadrivenroboticsreward @wang2023mimicplaylonghorizonimitationlearning @zhang2018deepimitationlearningcomplex 来训练操作策略，研究者们需要使用遥操作等方法来采集现实世界中的数据@bahl2022humantorobotimitationwild @zhaxizhuoma2025alignbotaligningvlmpoweredcustomized，这一过程通常使用主从臂架、示教器控制或 VR 头显等高成本设备来实现，不仅会消耗较多的劳动和时间成本，还会带来一定的安全风险，如在遥操作过程中发生碰撞、超出工作空间的情况。

机器人的不同具身形态也为策略训练带来了挑战。执行操作的机器人通常具有高自由度的机械臂和末端执行器，而不同具身形态导致了不同的自由度、运动学约束和动力学约束，也可能具有不同模态的传感器和执行器。这不仅导致收集数据任务依赖于特定机械臂软件平台，还会导致数据集和策略模型在不同具身形态之间的迁移困难@embodimentcollaboration2025openxembodimentroboticlearning @octomodelteam2024octoopensourcegeneralistrobot。事实上，操作任务 (Manipulation Task) 的动作往往是多模态的@chi2024diffusionpolicyvisuomotorpolicy，即对于同一观测，人类可以采取不同的动作来完成任务。直接采用基于回归的监督学习可能导致不稳定的训练，因此，训练策略时应当选取能够建模多模态动作分布的模型。

== 本文研究主要内容

为应对上述挑战，本研究的核心目标是设计并构建一个通用的演示数据收集系统，并探索合适的策略接口，旨在允许操作者在任意环境中收集高质量的演示数据，并探索数据质量和数量对策略的影响，通过策略训练验证系统的有效性。本文的主要研究内容包括：

- *设计通用的机器人运动生成方法：*设计并实现基于优化的机器人无碰撞运动方法和一种在线轨迹生成算法，旨在充分利用不同机械臂的自由度并降低对特定机械臂软件平台的依赖，提高机器人运动的流畅度和安全性，同时提升收集数据的效率和质量，为后续演示设备采集和策略部署奠定基础。
- *设计易于使用和普及的演示接口：*探索合适的物理接口来收集人类演示数据，比较并选定低成本、普及率高的硬件设备来收集充分的视觉-姿态等信息来满足策略学习的需求，并设计易于使用的用户接口，目标是大幅降低操作者的使用门槛和学习成本，探索大规模数据收集的可能性。
- *探索合适的策略模型接口：*比较和选取观测和动作空间的不同表示 (Representation)，使得策略模型能在少量数据微调 (Few-shot fine-tuning) 的条件下在不同具身形态上进行迁移，并验证上述设计的有效性。

为实现上述目标，本文首先设计了一套可自定义优化目标的机器人运动学逆解方案，并提出了一种满足急动度约束的在线插值算法（章节三），可将夹爪或灵巧手动作指令转换为平滑的机械臂关节空间轨迹。在此基础上，本文在移动设备上开发了可用于收集动作数据或用于任意机械臂遥操作的软件接口，演示了软硬件系统可用于执行大量不同种类的操作任务，并有效提升了数据收集的效率。最后，本文在不同的具身形态上验证了所收集数据和策略接口的有效性，以及探索数据多样性和数量对策略的影响（章节四）。

== 研究意义

本文的研究意义体现在以下几个方面：
- 当前部署在实机上的策略模型执行效果多依赖于机器人厂商提供的运动生成和控制算法。本文提出的快速、高自由度的运动生成方法可提升数据收集和策略推理阶段机械臂的跟随精度和操作流畅度，从而便于高质量的数据的收集和策略在不同机械臂之间的性能比较。
- 本文设计和实现的移动设备演示框架能以较低的学习使用成本推广到用户群体中，其集成的在线视觉定位识别和数据筛查算法能够降低数据后处理阶段的复杂性，有望为大规模数据收集提供一种易于普及的解决方案。
- 本文通过收集大量数据并在视觉、动作表示上进行广泛分析，验证了数据集多样性相比数量对于策略泛化能力更为重要的结论，为后续策略模型优化和数据收集方向提供了参考。

= 相关工作

在构建大规模数据集领域，国际和国内学者已经开展了大量相关研究。这些研究包括跨具身形态的动作生成、多模态动作表示和策略迁移等方面。尽管该领域存在大量研究，但仍存在一些挑战和不足需要解决。

== 多目标优化逆向运动学求解器

RangedIK 提出了一种创新的逆向运动学（IK）求解框架@wang2023rangedikoptimizationbasedrobotmotion，通过将传统的 IK 问题转化为加权多目标优化任务，实现了末端执行器位姿精度与整体运动可行性的平衡。该框架在以下方面具有显著创新：（1）统一地将关节限位、自碰撞检测、环境避障等多种运动学与动力学约束条件整合进优化目标函数中，提升了解的物理可行性与安全性；（2）引入“松弛变量”机制（slack variables），使得在理想位姿不可达或冲突时，能够自动寻找距离目标最近的可行解，避免了传统逆解法常见的不可解问题；（3）通过扩展开发的 CollisionIK 模块，支持动态障碍物避障与环境实时更新，使机械臂在复杂动态场景下亦能生成连续、平滑且无碰撞的运动轨迹。得益于优化框架的高效性，RangedIK 系统可在 Baxter、UR5 等主流机械臂平台上保持较高的实时求解频率，满足在线规划需求。

然而，RangedIK 主要面向传统机械臂的关节空间运动规划，尚未充分考虑冗余自由度较多的末端执行器系统（如带有手腕冗余的高自由度机械臂或具备复杂手指运动的灵巧手）在任务空间中的联合运动控制问题。同时，该框架仍以离散目标位姿为主，缺乏将不均匀任务指令（如连续路径跟踪、速度限制、动态任务优先级调整）自然转化为频率平滑、动态一致的关节空间轨迹的能力，限制了其在部分实时控制应用中的广泛适用性。

== 基于扩散Transformer的大规模基础模型

受到近期在单手操作方向扩散模型探索的启发，该研究团队提出了 RDT-1B 作为面向双手操作场景的机器人扩散基础模型 @liu2025rdt1bdiffusionfoundationmodel。该模型在覆盖 46 个数据集、累计数十万条操作轨迹的大规模预训练数据上进行训练，并通过 ALOHA 双手机器人采集的专项微调数据进一步优化了其在双手协调操作任务中的适应性和泛化能力。RDT-1B 在以下方面做出了一些改进：（1）提出了一种统一的物理可解释动作空间编码方法，能够在保留不同机器人平台运动学特性的同时，实现从单臂到双手平台的跨平台迁移与共享控制策略；（2）结合多模态条件建模能力，实现了视觉、语言与动作的有效对齐，在部分未见语言指令下展现出初步的语义理解与任务执行能力；（3）采用高效推理框架，模型在实际部署中可达 300 余动作/秒的实时执行速度，基本满足高动态复杂操作任务对控制频率的需求。值得一提的是，得益于预训练过程中积累的通用物理知识，RDT-1B 在学习新任务时可通过 1-5 次有限示范快速适配，展现出一定的低样本学习能力。

== 基于手持式采集的通用操作接口

UMI 框架提出了一种“手持夹爪 + 腕部相机”的轻量化数据采集方案 @chi2024universalmanipulationinterfaceinthewild，旨在缓解传统机器人数据采集方法在单臂与双臂操作任务中效率低、硬件成本高的问题。该系统采用便携式、传感化的夹爪装置，集成了 GoPro 相机和平行夹爪，可在自然环境中记录高动态、人类自然操作轨迹，支持更丰富、更真实的双手协作与动态任务演示。其设计亮点包括：（1）通过便携设备与人体自然动作对齐，支持在非实验室环境下采集高质量演示数据；（2）提出相对轨迹动作表示（relative-trajectory action representation），减少机器人与人类在坐标系与关节结构上的差异带来的迁移障碍；（3）配套的运动学约束验证模块可在后处理阶段过滤不可执行的示范，从而提升数据质量与下游策略的可部署性。此外，UMI 的策略接口在推理阶段引入了延迟匹配机制，使得训练出的策略更接近实际机器人控制流程，具备一定的硬件无关性，能够迁移到多种平台执行。

UMI 框架提出了一个有前景的中间方案，介于传统远程操作（teleoperation）与纯人类视频模仿之间，为采集可迁移的真实操作数据提供了新思路。然而，该框架在实际落地过程中仍面临一些挑战。其硬件虽然部分开源，可通过 3D 打印方式复现，但仍依赖于高成本的组件（如 GoPro 相机与 UR5e 机械臂），对一般实验室或大规模部署而言门槛较高。此外，由于缺乏实时的数据筛选与标签机制，UMI 的采集过程往往需要训练有素的操作员手动执行演示，示范数据的后处理（如筛除冲突轨迹、标定操作意图）负担较重，难以实现高效率、自动化的数据规模化采集。这些问题限制了其在长期、广泛数据构建中的可扩展性。

== FastUMI

FastUMI 框架一定程度上重构了通用操作接口（UMI）的软硬件接口，旨在提供一种替代的 SLAM 方案和实验机械臂的迁移。FastUMI 避免依赖专用机器人组件，同时通过商用追踪模块替代复杂的视觉-惯性里程计（VIO）实现，既降低了系统复杂度又保持了观测视角的一致性。技术亮点包括：（1）机械-传感分离架构支持快速适配不同操作平台，通过标准化接口确保数据采集的硬件无关性；（2）集成化的数据生态链覆盖从采集验证到策略训练的完整流程，兼容多种模仿学习算法；（3）配套开源真实操作数据集（涵盖22类日常任务），为数据驱动的策略研究提供了多样化基准。

但 FastUMI 的实际应用仍存在若干局限性。硬件方面，虽然摒弃了对专用机械臂的依赖，但高精度夹爪与多模态传感器的配置仍导致边际成本居高不下，难以实现真正低门槛的普及化部署。数据质量层面仍依赖后处理阶段的人工干预，这限制了超长周期任务数据的采集效率。

== 本章小结

现有的数据采集框架在提升机器人操作数据采集效率和灵活性方面取得了显著进展。UMI通过手持夹爪与腕部相机的组合，实现了便携的演示数据采集，支持多种操作任务和环境，但其硬件成本较高、依赖特定设备，且数据后处理负担较重。FastUMI进一步降低了对专用机械臂的依赖，优化了软硬件接口，但高精度传感器配置和人工后处理仍限制了其大规模普及。总体来看，现有框架在硬件通用性、数据质量保障、自动化处理和低成本部署等方面仍存在不足，难以完全满足大规模、低门槛、高多样性数据采集的需求。


= 基于实时优化的轨迹生成

机器人操作策略的部署质量高度依赖于底层运动生成系统的实时性与可靠性。本章节针对高自由度机械臂与灵巧手协同操作场景，提出融合优化求解与在线插值的轨迹生成框架，旨在解决传统方法在复杂约束下的几个核心问题：（1）实时生成可行的机器人运动来满足多个运动目标，并偏好特定目标;（2）满足高阶动力学约束的臂-手关节轨迹平滑性保障。这一运动生成方法的设计，为后续工作在不同机械臂和末端执行器上高效收集数据和验证策略在不同具身形态的迁移提供了基础和便利。

== 手部姿态检测设备原理与选型

本研究虽然在后续阶段设计了新型演示数据收集系统，但在验证运动生成的效率和有效性时，采用了独立且多样的传感器设备来捕获人手根部或手指关节的高自由度姿态，体现了本系统的低耦合和高拓展性。

=== MediaPipe Hands 手部检测器

该检测器是一种基于 MediaPipe @zhang2020mediapipehandsondevicerealtime 模型的实时设备上的手部跟踪解决方案，可从单张 RGB 图像中预测人体的手部骨架，且可以使用移动设备相机等通用图像采集设备，部署方便，避免依赖深度传感器等昂贵设备。

#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(box-img("figures/hand1.png", 100%, 12pt)),
    grid.cell(box-img("figures/hand2.png", 100%, 12pt)),
    grid.cell(box-img("figures/hand3.png", 100%, 12pt)),
    grid.cell(box-img("figures/hand4.png", 100%, 12pt)),
  ),
  caption: "MediaPipe Hands 手部检测器识别不同手势的效果",
  supplement: [图],
)

尽管该方案可在标准硬件上实时运行，但其呈现出显著的延迟和有限的精度问题，手部骨架数据表现出明显抖动，不足以直接用作运动规划的目标点。此外，将图像坐标系中的手部关键点转换为运动规划所需的手根-相机相对位姿也存在挑战。若采用PnP等算法获取手根位姿，不仅会引入额外误差，且结果依赖于相机内参，限制了系统的拓展性。Zimmermann等@zimmermann2017learningestimate3dhand 提出的Hand3D方法能将人手RGB图像直接转换为手部姿态，但其精度仍存在局限，难以满足机械臂末端执行精确运动的需求。

=== HTC VIVE Tracker

HTC VIVE Tracker 采用 SteamVR 灯塔（Lighthouse）追踪技术，基于红外激光扫描与光电传感器阵列（24 个光敏二极管），通过计算激光扫过传感器的精确时间差，实现毫米级 6DoF（六自由度）定位。

- 覆盖角度：270° 视场角（FOV），确保大范围动作捕捉。
- 更新频率：90Hz，低延迟（< 11ms），适用于高速运动追踪。
- 惯性测量单元（IMU）：内置 9 轴传感器，修正光学追踪误差，提升姿态数据可靠性。
- 1/4"-20 UNC 三脚架螺纹接口，兼容 TrackStraps 绑带系统，支持快速固定于肢体或物体。

#figure(
  image("figures/vive.jpg", width: 28%),
  caption: "VIVE 追踪器，可佩戴于手腕",
  supplement: [图],
)

VIVE 追踪器作为一种高精度、低延迟的追踪设备，在第一阶段实验验证中，我们采用 VIVE 追踪器来获取仅含手根姿态的数据。

=== Quest3 VR 头显检测器

Quest 3 头显搭载多颗高分辨率红外摄像头，通过主动红外照明与立体视觉融合技术，实现手部轮廓与关节运动的实时捕捉。

- 采用机器学习训练模型对手部图像进行特征提取与关键点定位，使之无需外部追踪器，即可实现手部与手指 26 自由度（DoF）高精度追踪。
- 内置 Snapdragon XR2 Gen 2 处理器，支持高帧率图像采集与并行推理，保证手部追踪延迟在较低水平。

#figure(
  image("figures/vr.jpg", width: 37%),
  caption: "Quest 3 头显和操作手柄",
  supplement: [图],
)

值得注意的是，VR 头显设备可为操作者提供沉浸式的数据采集体验 @opentv，在头戴显示器中，操作者可以直接观察到视觉模型识别到的手部关节姿态。尽管存在成本高、舒适度低和安全性问题（手部容易脱离头显摄像头视野，导致手部姿态数据漂移），但对于采集灵巧手数据的任务，Quest 3 较高精度的手部追踪能力仍具有一定优势。

=== 消除抖动信号算法原理

实践发现，采集数据过程中人手的生理性抖动可能对演示数据或遥操作数据采集质量产生一定影响，并会降低操作流畅度和数据采集效率。

// [abs]
#pagebreak()

#figure(
  image("figures/vive-fft.jpg", width: 70%),
  caption: "手部抖动频谱分析",
  supplement: [图],
) <vive-fft>

如图所示，小于 1Hz 处的峰值是固定周期目标运动引起的较大分量。可以看出，手部抖动信号没有固定周期，无法通过低通滤波器去除，对此，本文提出了一种可对末端姿态六个自由度均进行平滑的卡尔曼滤波器，且相较于低通滤波器的常量延迟，卡尔曼滤波器在平滑平移目标时可降低延迟@pei2019elementaryintroductionkalmanfiltering。

卡尔曼滤波可以通过融合观测信号和状态预测来估计干净的信号。在每个时间步中，卡尔曼滤波器执行两个步骤：预测和更新。预测步骤基于上一时刻状态和其方差的最优估计值来估计当前运动状态，更新步骤则使用当前时刻的观测结果来修正上述估计值。我们定义状态 $x$ 和其转移方式为：

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

大多数六轴工业机器人通过求解析解或逆运动学的雅可比方法来计算使机械臂末端达到给定位姿的关节配置。后者虽然具有一定的通用性，但应用于冗余度机械臂和欠驱动机械臂时，往往无法计算得最优配置。例如，在 UR10-Shadowhand 臂手系统上，装配于 UR10 机械臂的灵巧手在手腕有两个冗余自由度，而雅可比方法无法充分利用手腕信息，导致目标位姿数据仅需较小姿态偏转就可能导致机械臂六轴的大幅运动，给复杂任务数据收集工作带来困难。此外，当机械臂处于奇异位形时，上述方法可能失效，导致机械臂的不确定性运动。针对上述问题，在本节中，我们为运动学优化问题提供一种表示，并概述我们使用的求解器优化结构。该求解器通过松弛关节限位约束与任务空间误差的加权平衡，建立包含多重要素的优化目标函数。

考虑一个 $n$ 自由度的机器人，其配置用 $upbold(q) in RR^n$ 表示。我们用 $chi (upbold(q))$ 表示满足某个运动学目标的任务。

=== 任务函数设计

任务函数: $chi (q) = sum_(j = 1)^(k) chi_j (q, Omega_j)$

任务空间误差指的是末端执行器在给定机械臂配置 $Omega$ 和关节配置下与目标位姿的差异，该误差是逆运动学任务中的主要优化目标：

$
  "任务空间误差" &: lr(||log("FK"(q, Omega)^or)||) \
$

在自由度 $>= 6$ 的机械臂配置中，任务空间误差往往存在多个局部最优解，而我们对机械臂的关节运动存在一定偏好，例如在有手腕的臂-手系统中，我们希望优先使用手腕来完成末端执行器的旋转；在欠驱动机械臂中，任务空间误差可能不存在解。我们通过引入任务空间偏移和关节角度偏移损失项来惩罚大幅度运动，最小化能量消耗，并避免机械臂接近奇异位形。通过引入权重项，求解器可在一定程度上偏好灵活度更高的关节，并让缺失自由度的末端执行器的位置精度高于姿态精度：

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

RangedIK @wang2023rangedikoptimizationbasedrobotmotion 等工作提出了使用基本的损失函数等组合设计特定目标函数，可在不同类型的任务上表现出更明显的偏好和特性。想要结合以上多个任务，需要将任务函数归一化到均匀范围，例如使用负高斯函数和墙函数。为了弱化优化过程对初始猜测的敏感程度，可在上述函数形式基础上引入多项式函数，以在解空间中提供稳定的梯度。

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

- 二阶导数（加速度）是力/扭矩的直接来源。阶跃变化的加速度会引发振荡，影响末端执行器的定位精度，甚至导致电机承受超出设计极限的扭矩，引发机械损坏。
- 三阶导数（急动度，Jerk）是加速度变化率。若过高，会导致加速度和电机电流的突变，引发高频振动。

电机控制固件通常通过 PID 或 LQR 等控制器来限制加速度，但本研究在部分条件下仍然遇到了加速度或急动度超限，从而导致机械臂谐振或触发自碰撞保护机制的问题，包括：

- 控制低成本机械臂（如 Aubo 5i，Koch 等型号机械臂）或机械臂末端执行器惯量较大的情况。
- 需要通过 TCP 透传等底层控制方式降低执行延迟的情况。

为确保机械臂在空间中的运行轨迹正确恰当，插值法（Interopolation）在工业中的应用十分常见，现有方法包括线性插值、圆弧插值和多项式插值，通常指定少量的参考量，如轨迹上的极值点、起点和终点并给定期望到达时间，无法满足实时操作（如遥操作和策略部署）中高频率修改目标点和*尽快执行*的要求。对此，本文提出了一种能以任意不均匀频率修改轨迹目标点，并在满足同时速度、加速度和急动度约束条件下产生稳定频率轨迹的在线插值算法。

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

// [abs]
#pagebreak()

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
  supplement: [图],
  caption: [最优插值加速度],
) <interpolation-best-acceleration>

单元测试表明，即使追随目标在灵活运动（模拟遥操作或策略部署时目标指令频繁变化的情况），且初始路点和速度均距离目标较远，该算法仍能快速收敛到目标，并与目标保持几乎重合运动。

#figure(
  image("figures/4-2.png", width: 100%),
  caption: "在线插值结果，红色曲线为目标轨迹 (1.1s 后与执行轨迹重合）",
  supplement: [图],
) <unit-test>

== 实验设计

本节针对上述提到的传感器通用接口、基于多目标优化的运动学逆解和在线插值轨迹生成模块进行了实机实验。实验所使用的参数可在本研究的开源实现中找到。我们将本文实现的模块与两种基线方案进行了对比：由 KDL 算法@kdl 和三次多项式插值实现的逆解和规划模块，以及使用 MoveIt2 和 TRAC-IK 实现的基线方法。

=== 实现细节

本文实现了包含基于优化的逆运动求解器和在线插值轨迹生成模块的运动生成系统，在给定多个目标（例如末端执行器姿势匹配，平滑的关节运动和避免自碰撞）的情况下，产生可行的运动轨迹。本文尝试验证，通过将关节空间偏移等目标纳入优化目标，规划模块将产生更准确、流畅和可行的动作。另一种广泛使用的逆运动求解器 TRAC-IK 使用多种子值在初始关节空间周围搜索，我们将种子值设置为上一次搜索得到的关节角度。我们的原型实现使用 BFGS 优化方法进行多目标优化，并将算法接口暴露给传感器和机械臂执行模块，对于 UR10-ShadowHand 配置，我们的算法模块同时应用于机械臂和灵巧手的关节路点，并且是唯一可以利用手腕的 2 个冗余自由度的轨迹生成算法。所有评估均在 AMD Ryzen5 7500F 4.1 GHz CPU 和 32 GB RAM 的 Ubuntu 22.04 LTS 系统上运行。

// [abs]
#pagebreak()

#figure(
  image("figures/teleop2.png", width: 100%),
  caption: "实验系统架构",
  supplement: [图],
) <experiment-platform>

=== 评价指标

我们设计了 3 个操作任务，通过遥操作方法来评价轨迹生成模块的性能: `画圆`、`抓取胶圈`、`折叠毛巾`。在画圆中，机器人末端执行器上固定了画笔，并需要在固定的 A4 大小笔记本上画一个半径 8 厘米的圆圈。这项任务需要非常精确的执行轨迹，尤其在高度方向上，错误的轨迹可能让笔尖远离绘制平面，或者破坏纸张，任务成功的标准是绘制轨迹首尾相接且没有间断。在抓取胶圈中，机器人需要将一个胶圈从桌面上拿起，并放置到另一边，保持胶圈其中一面朝上。折叠毛巾任务则要求机器人将桌面上已经折叠过两次、方向随机摆放的毛巾折叠第三次。所有任务的参考图像如@img:task-example 所示：

// [abs]
#pagebreak()

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

其中，我们设定`画圆`任务的得分标准为:

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
    [_KDL-Tree_\ _MoveIt2_ \ _本文方法_],
    [(执行失败)\ $262 plus.minus 55$\ $bold(105 plus.minus 39)$],
    [/\ *46.7*\ 38.1],
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

=== 结果分析

如@tbl:experiment-result 所示，两种传感器-机械臂配置据能从本文提出的运动生成方法中收益。与 KDL-Tree 和多项式插值相比，我们的方法产生了更准确、更光滑的机器人运动，在通过底层透传的低延迟方式控制机器人运动的 Aubo i5 机械臂上，不满足加速度限制的轨迹由于机械臂严重谐振而执行失败，尽管基于多目标优化的逆解方法比 KDL-Tree 运动学逆解消耗了更多时间 ($tilde 50$ms)。与 MoveIt2 TRAC-IK 方案相比，我们的方法大幅降低了离线轨迹规划所需时间，通过设计多个优化目标和充分利用手腕关节，明显减小了机械臂到达目标位置所需的运动幅度，尤其是在折叠毛巾等需要更多手部动作的灵巧任务时，提供了更低的体感延迟，从而提高了执行任务的效率和成功率。在后续策略部署时，我们同样采用了本章节设计的运动生成方法，并取得了良好的效果。

= 数据采集系统和策略验证

当前，深度学习计算机视觉和自然语言处理领域的快速发展很大程度上得益于对数据、模型规模和计算资源的系统性扩展研究，这些研究揭示了明确的*尺度定律*（Scaling Laws）@kaplan2020scalinglawsneurallanguage，并推动了模型泛化能力的提升。然而，机器人技术领域尚未建立类似的扩展规律，特别是在机器人操作 (Manipulation) 任务中，由于缺乏在真实世界中的高质量数据@bahl2022humantorobotimitationwild @chi2024universalmanipulationinterfaceinthewild，策略的泛化能力仍然有限，难以适应真实世界中复杂多变的环境和物体。

一种常见的收集机器人模仿学习数据的方式是通过遥操作 (Teleoperation)，即使用特定设备，通过关节映射或运动学逆解的方式将人类操作员的动作映射到运行中的机器人上，并采集机器人视角的视觉、触觉和关节角度等数据。这一过程中，操作员必须守候在机械臂操作台附近，且仅能通过视觉反馈来调整机器人的动作，因此仍然需要大量的人力来收集数据。对此，有研究人员提出了通用操作接口 (Universal Manipulation Interface, UMI)@chi2024universalmanipulationinterfaceinthewild，通过在可 3D 打印的手持夹爪上安装多种传感器，即可在广泛环境 (in-the-wild) 中采集 6-DoF 末端姿态数据。UMI 凭借其直观的操作方式、便携的硬件设计和较低的组装成本成为一些开源模型@liu2025rdt1bdiffusionfoundationmodel 的选择，但它仍存在一些局限性：

- 与特定硬件耦合。用户必须采购 WeissWSG-50夹持器和 GoPro 相机等设备才能实施 UMI，导致了较高的成本，限制了拥有不同机器人配置的用户使用以及策略在不同具身形态间的迁移。
- ORB-SLAM3 等开源 SLAM 方案虽然可以估计末端夹爪的位姿，但标定校准工作复杂且耗时，且依赖于手持硬件的参数配置，这增加了劳动力成本。
- 由于缺乏采集过程中的预警和操作提示（包括视觉锚点丢失），采集数据质量依赖于操作人员的熟练度，给数据后处理阶段带来了较大的筛查压力。

为了解决 UMI 的限制，本研究围绕两个目标设计开发了一个新系统流程：

- *目标1：*通过软件驱动方式，提升数据收集效率和即插即用能力。我们的研究人员改进了 UMI 的硬件配置，使之同时支持安装包括移动设备在内各种相机，并开发了可插入的柔性指尖扩展件，使得手持设备收集的数据可直接应用于机器人。在此基础上，我们设计了用户友好的操作接口，仅需在*操作者自己的移动设备应用程序*中即可完成收集数据全流程，无须使用线缆或其他计算设备。
- *目标2：*构建稳健的数据收集生态系统，提升大规模数据采集的可能性。我们在数据采集流程中集成了运动学和视觉算法模块，简化了数据处理，大幅降低了操作者使用成本和数据后处理压力。通过支持末端姿态、执行器状态和关节轨迹等数据，我们的数据集系统致力于支持多样的模仿学习模型或基础模型@brohan2023rt1roboticstransformerrealworld @brohan2023rt2visionlanguageactionmodelstransfer (Foundation Model)，包括 Diffusion Policy@chi2024diffusionpolicyvisuomotorpolicy，Action Chunking with Transformers@zhao2023learningfinegrainedbimanualmanipulation 和 $pi_0$ @black2024pi0visionlanguageactionflowmodel。

== 原型设计

=== 硬件框架

手持设备采集的演示数据不含关节信息，从而与机械臂的具体形态解耦。然而，这也给模仿学习带来了困难，例如，缺乏足够的视觉上下文信息，动作指令的模糊性，系统内的延迟差异和不充分的策略表示@chi2024universalmanipulationinterfaceinthewild。我们的研究人员通过仔细设计轻量化的新型硬件形态来应对这一挑战：
- *相机扩展件：*为移动设备设计的扩展框架，可通过插拔和旋钮轻松地将手机安装在原始 UMI 夹持器上。其拥有多种尺寸，可安装的 iPhone 包括 6S 到最新的型号。采集完毕后，用户可以快速拆卸该扩展件。

// [abs]
#pagebreak()

#figure(
  image("figures/camera-extension.png", width: 67%),
  caption: "相机扩展件（绿色 3D 打印原型）",
  supplement: [图],
)

- *鱼眼镜头：*我们研究人员开发的相机扩展件通过旋拧即可装卸具有 $210^degree$ 视场角的低成本鱼眼镜头，鱼眼镜头在保证视觉中心分辨率的同时在外围视野中压缩信息，并保持了视觉特征的空间连续性。实验表明，单个鱼眼镜头即可为策略提供足够的时空信息，因而可以取代 Diffusion Policy 和 ACT 等模型使用第一视角和第三视角平面相机的组合。

#figure(
  image("figures/extension-fisheye.png", width: 35%),
  caption: "鱼眼镜头可安装在主摄处",
  supplement: [图],
)

*总体设计：*总体而言，我们改进的夹持设备减少了元件数量，考虑到 iOS 设备的拥有率，具有海量的潜在用户。安装完成后，夹爪重约 650g，完整尺寸约为 $21 times 22 times 26$ cm，其中 3D 打印和组装件物料的成本仅为约 40 元，鱼眼镜头则根据不同型号，其成本在 60 到 90 元之间。除了收集数据与训练，该夹爪也可安装在任意机械臂末端作为推理时的执行器。

#v(1em)

#figure(
  image("figures/robot-gripper.png", width: 70%),
  caption: "夹爪-相机配置使得推理时的观测量与手持时保持相似",
  supplement: [图],
)

=== 软件框架

==== 前端界面

我们为不同功能模式设计了统一的视觉语言，以降低操作者的学习门槛。

#v(0.5em)

#figure(
  image("figures/ui.png", width: 70%),
  caption: "用户接口原型设计",
  supplement: [图],
)

#v(0.5em)

例如，连接夹爪与 iPhone 后，在应用程序的*数据采集*模式仅需点击右下角录制按键即可开始录制，录制期间位姿、视觉数据将在线处理，再次点击将结束录制并立即存储为数据集规范格式。具体算法流程于后文中介绍。

#v(1em)

#figure(
  caption: "In-the-wild 数据采集模式示例",
  supplement: [图],
)[
  #box(
    image("figures/ui-record.png", width: 70%),
    radius: 12pt,
    clip: true,
  )
]

#v(0.5em)

==== ARKit 集成和视觉处理

ARKit 是苹果自 iOS 11 开始引入的增强现实技术框架。该框架融合加速度计、陀螺仪、LiDAR等传感数据，借助视觉惯性里程计 Visual–Inertial Odometry (VIO) 和平面检测 (Plane Detection) 等功能，可精确估计设备所在位置以及设备朝向，无需连接传感器等外设，也不需要提前了解所处环境。本文设计的软件框架结合 ARKit 的多传感器定位技术，直接获取持续的图像流和末端执行器姿态流。与 UMI 相比，我们的设计通过消除复杂的 SLAM 流程，显著简化了数据处理和采集步骤。此外，本文在 ARKit 数据流中嵌入了视觉处理模块，可利用移动设备算力识别手持设备和桌面上的基准标记，并归一化为连续夹爪动作数据。桌面基准标记是为双臂数据收集设计的，这一部分使用 PnP 算法估计桌面到相机的位姿变换。在性能测试中，A14 芯片（发布于 2020年）在开启全部视觉功能的设置下，仍能以较低的 CPU 占用率（$<40%$）和内存占用（$<=650$ MB）稳定录制 30 帧演示数据。

==== 逆解模块

现有的夹持设备通常由经过训练的专业人员录制人类演示数据。事实上，目前的主流机械臂仍无法与人类手臂的灵巧性相比，因此未经训练的人员在使用加持设备操作时，极易超过机械臂关节的速度、加速度和工作空间等限制。我们希望设计的采集系统应允许操作者凭借直觉即可执行多样化的任务，考虑到这一目标，我们在应用程序中植入了基于优化法的逆解模块。该模块在用户操作夹持器的同时，通过机器人运动学文件（URDF 文件）和运动学逆解算法实时解算虚拟机械臂的关节角度，并在目标空间不合法或超出运动学限制时给出视觉和语音提示，指导用户改进数据采集方式。考虑到不同任务可能需要不同的机械臂配置，用户仅需点击切换机器人的描述文件，即可切换到指定任务配置。由于我们使用原生语言编写和交叉编译方案，算力代价仅为每帧内小于 $20$ 次低秩矩阵运算，其对性能的影响可忽略不计。

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

我们通过去畸变测试来验证鱼眼镜头建模的有效性，如@img:calib。标定模块同样拥有用户友好的接口设计，用户可通过拍摄若干张标定板图像来计算相机内参和畸变系数，对于同一相机-鱼眼镜头组合，用户只需标定一次。

#v(1em)
#figure(
  grid(
    columns: (1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(box-img("figures/calib0.png", 80%, 10pt)),
    grid.cell(box-img("figures/calib1.png", 80%, 10pt)),
  ),
  caption: [使用标定参数去畸变前后的图像对比。右图为去畸变后的结果，棋盘格标定板的直线得到了恢复，图像中央部分的高频细节得到了保留。],
  supplement: [图],
) <calib>
#v(1em)

==== 遥操作模块

基于大规模数据进行预训练的基础模型在迁移到不同机械臂配置时，通常仍然需要少量示例（Few-shot）微调@liu2025rdt1bdiffusionfoundationmodel @majumdar2024searchartificialvisualcortex。为了便利这一迁移过程，我们设计的遥操作模块通过快速标定和传输末端位姿数据流，允许用户手持移动设备运动来直接控制机械臂-夹爪组合，相比 VIVE Tracker 和 Quest 3 等设备，我们的方案明显降低了设备成本，并提升了操作舒适度。

#v(1em)

#figure(
  caption: "遥操作模式示例",
  supplement: [图],
)[
  #box(
    image("figures/ui-teleop.png", width: 70%),
    radius: 12pt,
    stroke: rgb("#252525") + 1.2pt,
    clip: true,
  )
]

#v(0.5em)

==== 数据管理

数据的在线处理和存储对用户而言是透明的，用户无需知道处理流程的细节。为了将来自大量用户的演示数据整合到大型数据集中，我们的研究人员开发了中心化数据服务器，用户可在右上角的上传队列中一键将新录制的数据包上传到中心服务器，大幅减轻了操作者和训练人员的数据管理负担。

#v(1em)

#figure(
  caption: "数据管理器示例",
  supplement: [图],
)[
  #box(
    image("figures/ui-upload.png", width: 70%),
    radius: 12pt,
    stroke: rgb("#252525") + 0.8pt,
    clip: true,
  )
]
#v(0.5em)

== 数据采集流程

与依赖复杂 SLAM 算法的原始 UMI 系统不同，我们使用集成 ARKit 的跟踪功能获取观察 (Observation) 和动作 (Action) 数据流，无需事先采集视频来建立场景地图。

- *图像数据、夹爪动作：*安装联合镜头的相机以 $1920 times 1440$ 分辨率和 30帧每秒捕捉鱼眼图像，提供广泛的视觉信息。原始图像数据拥有较高的分辨率，考虑到数据存储和传输的效率，以及策略模型图像编码器实际使用的输入尺寸，我们的应用程序首先将图像缩放至 $640 times 480$ 分辨率，并使用 MPEG-4 编码格式存储。用户可调节设置以选择录制图像格式，最高可选择 $1920 times 1440$ 分辨率和 60 帧每秒的帧率。在送入视频编码器前，应用程序会使用相机标定参数，识别和计算得到图像中基准标记的三维坐标，并标准化到 $0$-$1$ 范围内，从而得到与图像同步的夹爪动作信息。
- *深度图数据：*iPhone 12 Pro 以上机型拥有 LiDAR 传感器，其位于后置摄像头附近，ARKit 可通过该传感器提供 $256 times 192 space "@" space 30 "fps"$ 的深度图数据。我们使用 16bit 位深的 PNG 格式存储深度图数据，这是考虑到原始数据分辨率较低，而视频编码格式尽管压缩率较高，但1）其采用的帧间预测（Inter-frame Prediction）不符合自然深度图像的运动规律，如遮挡或新物体出现导致的深度突变；2）有损压缩会丢弃高频信息，如物体边缘的深度跳变被平滑。实践中，使用 PNG 视频存储相比视频编码格式会使单条数据集体积增加约 $60%$，仍在可接受范围内。
- *姿态数据、时间戳*：ARKit使用了苹果开发多重运动传感和图像处理库，可实时估计相机的 6-DoF 姿态信息，并以稳定频率更新。由于上述数据来自同一 ARKit 数据帧，因此实现了天然的数据流同步，无需专门测量传感器延迟或在后处理阶段同步数据。

最终，数据收集的步骤如下：

#figure(
  image("figures/collect.png", width: 100%),
  caption: "用户角度的数据采集流程",
  supplement: [图],
)

== 策略模型设计

=== 数据类型概述

#figure(
  image("figures/policy.png", width: 105%),
  caption: "改进的扩散策略（Chunked Diffusion Policy）强化了观察表示，并引入动作分块和平滑策略，以建模演示数据中的非马尔可夫行为。",
  supplement: [图],
) <policy>
#v(1em)

*绝对关节轨迹 (Absolute Joint Trajectory) *指机械臂各个关节的角度读数序列。Diffusion Policy 和 ACT 的原始实现中使用绝对关节轨迹作为策略模型的输入。这种数据类型受限于特定的机械臂，但在预训练模型迁移时，可帮助策略模型快速适应新的机械臂配置。

使用手持加持设备录制的任务数据不包含机械臂关节角度信息，此时可以使用逆解模块将其转换为绝对关节轨迹。必要时，可通过遥操作收集特定机器人的关节轨迹数据。

*相对执行器轨迹 (Relative End-effector Trajactory)* 指末端执行器相对于任务起始时间点的 $"SE"(3)$ 姿态序列。在任务起始时，数据收集设备提供的参考姿态为 $R_0, T_0$，而 $t$ 时刻的姿态为 $R_t, T_t$，则相对姿态定义为:

$
  T_"rel" &= T_t - T_0 \
  R_"rel" &= R_t R_0^T
$

我们改进的扩散策略在训练和推理阶段均采用 EE Pose 作为策略模型观察的一部分。而扩散模块的隐变量和噪声的维度则与 EE Pose 的维度一致，如@img:policy 所示，这一设计消除了夹持器在数据格式定义上的困难和对全局参考系的依赖，增强了基座位置不确定情况下的泛化能力。

=== 点云嵌入表示

模仿学习的泛化能力以大量的示例数据为前提。有研究者发现，扩散策略在需要高精度估计深度的任务中（例如叠毛巾等对深度估计误差敏感的任务）表现不佳。有一些现存的工作@ze20243ddiffusionpolicygeneralizable @ke20243ddiffuseractorpolicy 提出使用深度传感器来增强模型的感知能力，减少所需示例数据的数量和增强模型的泛化能力，其实验结果表明，稀疏点云提供了丰富的空间信息，即使独立于 RGB 图像信息作为策略模型的观测，也能取得较好的实验效果。因此本文可选性的引入了将稀疏点云编码为紧凑向量表示的模块，作为去噪步骤的全局条件之一。

=== 动作分块和平滑

在最初的训练和推理实验中，我们发现扩散策略的执行轨迹表现为断续执行，即夹持器每隔若干帧动作会停滞一小段时间。这是由于扩散策略在预测动作时，每次会收集最近几帧的观测数据，预测结果仅包含一帧或少数几帧的目标姿态，并会等待执行器将输出姿态序列执行完毕再进行预测。单步预测的模式会导致策略的错误会随着时间累计，明显降低了任务执行的速度和成功率。

Action Chunking with Transformers @zhao2023learningfinegrainedbimanualmanipulation 提出了动作分块思想，通过学习动作序列而不是单步动作，缩小累计误差；为了避免在执行和观察间进行离散切换，ACT 还提出在每个时间步中查询策略，使得不同的动作块彼此重叠。动作分块还可以帮助建模人类示范中的*非马尔可夫行为*，例如演示数据集中可能存在的中途暂停，再继续执行等复杂因素。

我们在策略中同样使用动作分块策略，使得同一时间步内可以获取先前多个时间点的预测动作。随后，我们采用时序合并 (Temporal Ensemble) 方法，将多个动作块的结果进行加权平均，从而得到平滑的动作序列。具体而言，对于 $n$ 个最近预测动作，我们执行以下动作，其中 $m$ 决定了合并新动作的速度：

$
  upbold(a)_"esb" = (sum_(i=1)^n exp(-m (n - i)) upbold(a)_i) / (sum_(i=1)^n exp(-m (n - i)))
$

#v(0.5cm)

#figure(
  image("figures/action-chunking2.png", width: 50%),
  caption: "动作分块和时序合并示例。动作的累加权重随时间指数衰减，最近一次预测动作拥有最小权重。",
  supplement: [图],
)

== 实验设计

我们围绕本研究提出的采集生态系统，设计了多个实验，致力于回答以下问题：

- *数据可靠性*：通过这套低成本系统采集的演示数据是否具有足够的精度、稳健性和采集成功率？
- *规模化采集可能性*：应用程序能否在广泛使用的 iPhone 设备上稳定、高性能地运行？该系统是否能提升人类演示数据的收集效率？
- *策略有效性和泛化能力*：能否通过改进的扩散策略模型在真实世界和仿真环境的机器人操作任务中，使用上述数据集取得良好表现？

=== 数据可靠性验证

为了验证数据的准确性，我们使用实装不同型号 iPhone 的夹持器执行复杂的任务，记录并分析位姿、识别结果等数据序列。由于我们在设备镜头前额外加装鱼眼镜头，ARKit 的跟踪功能可能存在较大压力，而在实际操作时，我们发现未经热身训练的操作者可能会误遮挡相机和 LiDAR 传感器视野。这些问题可能导致系统定位漂移，产生无效的数据。因此我们的实验中涵盖了部分传感器失效的情况，从而指明如何避免这些意外。

#figure(
  image("figures/relocation.png", width: 45%),
  caption: "重定位验证",
  supplement: [图],
)

验证定位精度的重要指标之一是重定位精度，即在执行任务时，夹持器从任意位置返回起始位置的位姿偏移。我们将夹持器设备固定于 Flexiv RIZON 4 机械臂末端，并对比软件收集的位姿读数和机械臂正解得到的高精度结果，通过我们研究人员开发的相机扩展件，相机可以轻松固定在机械臂夹持器上。实验中的两台 iPhone 设备系统均为 iOS 17.6。

实验结果如@tbl:pro 和@tbl:mini 所示。

// [abs]
#pagebreak()

#figure(
  caption: [iPhone 12 Pro 在不同配置下的重定位精度，数值越小精度越高。锚点丢失会导致定位出现跳变，影响数据质量],
  supplement: [表],
)[
  #show table.cell: set text(9pt)
  #show raw: set text(9pt)

  #table(
    columns: (1.2fr, 1.2fr, 1fr, 1fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[设备][位置精度 (mm)][姿态精度 (deg)][锚点丢失率],
    [iPhone 12 Pro, LiDAR, 鱼眼镜头, IMU], [$4.5 plus.minus 2.4$], [$0.7 plus.minus 0.3$], [2.0%],
    [iPhone 12 Pro, LiDAR, *遮挡镜头*, IMU], [$5.4 plus.minus 4.1$], [$0.7 plus.minus 0.6$], [0%],
    [iPhone 12 Pro, *遮挡 LiDAR*, 鱼眼镜头, IMU], [$126.5 plus.minus 82.7$], [$0.9 plus.minus 0.4$], [15.3%],
  )
] <pro>

#figure(
  caption: [iPhone 12 Mini 在不同配置下的重定位精度],
  supplement: [表],
)[
  #show table.cell: set text(9pt)
  #show raw: set text(9pt)

  #table(
    columns: (1.2fr, 1.2fr, 1fr, 1fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[设备][位置精度 (mm)][姿态精度 (deg)][锚点丢失率],
    [iPhone 12 Mini, 后置镜头, IMU], [$3.1 plus.minus 0.8$], [$0.6 plus.minus 0.3$], [0%],
    [iPhone 12 Pro, *遮挡镜头*, IMU], [$31.0 plus.minus 10.5$], [$0.5 plus.minus 0.3$], [0%],
    [iPhone 12 Pro, *鱼眼镜头*, IMU], [$42.8 plus.minus 22.0$], [$0.4 plus.minus 0.1$], [0%],
  )
] <mini>

对于定位精度，我们得出以下结论：1）在使用 LiDAR 传感器的机型上，即使加装*鱼眼镜头*或*完全遮挡镜头*，定位精度也能保持在 5mm 级别。2）由于 ARKit 直接使用 IMU 估计 $"SO"(3)$ 姿态，视觉传感器的状态不会影响姿态精度。3）该系统同时使用后置镜头、LiDAR 和 IMU 来估计位姿，加装鱼眼镜头导致使视觉特征点偏移以及重投影误差模型失效等问题，此时该系统会退化为使用 LiDAR 和 IMU 定位，保持较好的定位精度；但在没有 LiDAR 的机型上，鱼眼镜头可能导致定位漂移。

// [abs]
#pagebreak()

#figure(
  caption: [iPhone 12 两种机型性能测试],
  supplement: [表],
)[
  #show table.cell: set text(9pt)
  #show raw: set text(9pt)

  #table(
    columns: (1fr, 1.2fr, 1.2fr, 0.8fr, 1.2fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[设备][任务][CPU 占用率（6核）][内存占用][单条数据磁盘占用],
    [iPhone 12 Pro],
    [仅启用定位\ 全功能录制 30s 数据],
    [$88% tilde 96%$\ $167% tilde 200%$],
    [443MB\ 630MB],
    [/\ 38.5MB],

    [iPhone 12 Mini],
    [仅启用定位\ 全功能录制 30s 数据],
    [$60% tilde 78%$\ $112% tilde 121%$],
    [360MB\ 522MB],
    [/\ 39.7MB],
  )
] <profile>

在两台设备上运行的应用程序均能以合理的资源使用率运行全部功能，其中 iPhone 12 Pro 因需要处理 LiDAR 数据，资源占用率更高。 综合上述情况，在现有设计之下，我们推荐使用 iPhone 12 Pro 及以上含 LiDAR 传感器的机型作为稳健、有效的超广角（FOV $approx 210^degree$）数据采集设备。ARKit 支持的最早机型包括 iPhone 6S，此类机型可直接使用后置相机（FOV $approx 78^degree$）作为视觉传感器。

=== 采集效率

使用我们的扩展件设计，用户可以在 30 秒内拼装完成并开始收集演示数据或遥操作数据。对于简单任务，如放置任务（Pick and place），用户录制轨迹数据的间隔平均仅为 10 秒，连续录制期间只需要点击按钮和移动夹持器两种操作，其速度远快于基于 VR 的遥操作（$approx 30$ 秒 / 轨迹）和基于示教器遥控的遥操作（$approx 110$ 秒 / 轨迹）。我们改进的移动端遥操作也提升了收集绝对关节轨迹数据的效率，平均 15 秒 / 轨迹。对于`叠放物块`等复杂任务，本系统收集高质量数据的速度也比遥操作方式快 4 倍以上。在采集验证策略的数据集时我们的实验人员仅花费不到 20 分钟就录制了 50 条有效的 Pick-and-place 轨迹数据。

=== 策略模型验证

为验证我们的数据收集策略和改进模型的有效性，我们将上述系统应用于不同操作任务以评估这一系统是否有助于强化机器人策略的泛化能力。我们的实验包括`摆放插头或杯子`、`折叠毛巾`和`安放鞋子`。在`摆放插头`任务中，机器人需要将贴有图标的充电插头放入一个白色圆圈中，但每次重置环境时我们会随机改变插头和圆圈的位置。`折叠毛巾`的任务与第三章的实验相同，即将两次折叠的毛巾再次对折。在`安放鞋子`任务中，两只鞋子将被随机放在初始位置，鞋盒则固定在桌面特定位置，任务目标是将鞋子朝左放入鞋盒中。第一只成功摆放的鞋子可获得 30 分，第二只成功摆放的鞋子可获得 70 分。对于每个任务，我们使用录制系统收集了两种环境下的数据，包括有特定字符标记的黑色桌面和有反光性的机械臂工作台，环境布置如@env 所示。每种环境包含 50 条录制的相对末端姿态数据和 20 条遥操作数据。对于不支持末端姿态数据的基线模型，我们使用逆解将相对末端姿态数据转换为关节数据。为评估策略能否在少量样本中学习，我们逐渐增加样本数据和环境并评估训练的策略。录制数据过程中，我们通过切换任务环境和调整操作物的初始位姿来丰富数据的多样性（例如，直立或旋转插头来让机械臂必须调整夹爪的朝向才能完成任务）。尽管实验任务配置尚较为简单，实验结果仍然验证了我们高效采集数据的有效性以及数据多样性对策略执行任务能力的影响。本节的训练和推理均在 Intel Core i9-14900K 3.2GHz, 64GB RAM 和单张 RTX 4090 GPU 的 Ubuntu 22.04 LTS 系统上进行。

#figure(
  grid(
    columns: (1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(box-img("figures/workspace1.png", 80%, 12pt)),
    grid.cell(box-img("figures/workspace2.png", 80%, 12pt)),
  ),
  caption: [任务环境配置],
  supplement: [图],
) <env>

// [abs]
#pagebreak()

#v(1em)

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

#v(1em)

#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    rows: auto,
    gutter: 3pt,
    grid.cell(image("figures/video2.jpg", width: 100%)),
    grid.cell(image("figures/video2-1.jpg", width: 100%)),
    grid.cell(image("figures/video2-2.jpg", width: 100%)),
    grid.cell(image("figures/video2-3.jpg", width: 100%)),
  ),
  caption: "安放鞋子任务示意图",
  supplement: [图],
)

#v(1em)

#figure(
  caption: [实验结果],
  supplement: [表],
)[
  #show table.cell: set text(9pt)
  #show raw: set text(9pt)

  #table(
    columns: (1.2fr, 1.5fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    inset: (y: 0.8em),
    stroke: (_, y) => if y > 0 { (top: 0.8pt) },
    table.header[执行器][方法][摆放插头\ （成功率%）][摆放插头\ （时间/s）][折叠毛巾\ （成功率%）][折叠毛巾\ （时间/s）],

    [#rotate(-90deg)[Koch1.1\ OV7725 $170^degree$ FOV]],
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

#v(1em)

实验表明，通过单个超广角相机配置，基线实现和我们的改进实现均能获取足够的视觉信息来完成任务，省去了原始策略使用多个相机的复杂安装和标定过程。

为了验证改进模块中深度信息编码模块的有效性，我们在 SAPIEN 仿真环境中使用 D435 相机获取点云数据，将其合并到策略模型的观察中。

#v(1em)

#figure(
  caption: [实验结果],
  supplement: [表],
)[
  #show table.cell: set text(9pt)
  #show raw: set text(9pt)

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

#v(2em)

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

=== 结果分析

- *策略有效性：*本文采用的 Chunked Diffusion Policy 在多个仿真和真实世界任务中的平均成功率达 $78.25%$，超过了基线模型，包括扩散策略和 3D-扩散策略。在收敛速度上，CDP 通常在 1000 轮 (epoch) 内收敛，快于扩散策略。在折叠毛巾任务中，CDP 使用较少演示数据即超过了基线模型使用最多演示数据的得分，除了较高的动作精度外，CDP 通过平滑连贯的动作执行，使得机械臂执行轨迹与动作指令一致程度更高，并减少了执行停滞现象。相比 3D-扩散策略，我们的策略通过有效编码视觉信息，在任务稳健性上更具优势。
- *泛化能力：*在实验中我们发现，通过刻意引入执行失败后复原的动作序列，例如，保留抓取失败或抓取过程中掉落物体的轨迹数据，不仅能够增强模型在执行失败后的复原能力，还能让模型对初始相机姿态和物体位置等配置变化的敏感度有所降低。实验中，使用动作分块的 CDP 模型表现出了明显的纠错能力，即使首次抓取或折叠失败，也能通过后续动作调整姿态，最终提升任务完成率。
- *数据多样性和数量的影响：*在初期试验后，我们调整了演示数据集结构，使之包含约 $1 / 5$ 的失败-复原轨迹数据，并使物体-环境配置（如初始夹爪姿态、物体形态和位姿等）在所有数据中较均匀地分布。我们提取了数据集的子集继续实验，1）通过在数据集中随机采样 $25% ~ 80%$，保持数据多样性的同时减小数据量。2）仅删除包含失败情况的数据（仅 $20%$），或删除特定姿态范围内的数据，如所有鞋子初始朝右放置的数据。我们发现，仅 $20%$ 的数据多样性缺失即可能导致模型性能显著下降，其影响多倍于数据量减少的影响，如包含 40 条无失败数据的模型训练结果仅与包含 20 条随机数据的模型操作得分接近。

= 全文总结

== 主要结论

本研究围绕机器人操作（Manipulation）模仿学习中的运动生成与数据采集挑战，设计了一套高自由度、低门槛的机器人运动生成与便携数据采集系统，取得的主要结论如下：

- 成功设计并实现了一种包含多目标优化与在线插值的运动生成方法，从而提升欠驱动或冗余自由度的运动规划效果。通过引入关节空间偏移、任务空间误差等目标函数，我们的方法既能充分利用冗余自由度，又能同时保证运动平滑性。实验验证表明，该方法相比传统方案显著降低了执行延迟（最高 $60%$），提高了任务成功率，在折叠毛巾等任务场景下执行时间可缩短$15% ~ 40%$。
- 开发了一套基于移动设备的低成本、高效率数据采集系统。该系统易于携带，且能以毫米级精度（$4.5 plus.minus 2.4$mm）捕获末端执行器姿态，且单次数据录制仅需10-15秒，比传统VR遥操作方式提速3-4倍。系统在普通iPhone设备上即可高效运行，提供了在任意地点采集数据的可能性。
- 提出了改进的Chunked Diffusion Policy策略模型，引入动作分块、时序合并与可选的点云嵌入表示 ，验证实验表明，该模型在摆放插头、折叠毛巾等任务中取得平均78.25%的成功率，超越了基线模型。特别是在面对环境变化和执行失败的情况下，模型表现出更强的纠错能力和泛化能力。
- 通过实验证明，策略训练中数据的多样性比数据量更为关键。数据多样性缺失即可能导致模型性能显著下降，其影响远超数据总量减少的影响。这一发现对大规模机器人数据采集策略具有一定指导意义。

该系统的高泛用特性使其能够在不同机械臂平台间快速迁移，为大规模机器人数据采集和预训练奠定了基础。

== 研究展望

本研究开发的数据采集系统仍存在若干局限，未来研究可从以下几个方面入手改进：
- 当前的运动生成方法需要在传感器和机械臂端进行较多的手工适配工作，如记录初始末端执行器位姿、适配不同机械臂的控制器API、修改代码来调整优化目标等。未来研究将致力于设计统一的运动生成API接口，实现中间适配层的自动化配置，使不同机械臂和传感器设备之间能够实现"即插即用"。实践上，我们将探索使用流行机器人框架的插件架构、声明式配置文件或跨平台中间件，降低系统部署和迁移的技术门槛。
- 便携数据收集系统目前仍对用户手机机型有一定限制，理想效果只能在iPhone 12 Pro及以上带有LiDAR的机型上完全复现。我们考虑了以下改进方向：1）在数据流中嵌入基于标定内参的图像修正算法，解决鱼眼镜头带来的视觉里程计失效问题；2）以原生语言编写替代SLAM方案，构建跨平台采集软件，实现真正的"人人均可零成本采集数据"；3）目前硬件扩展件和前端界面仍在快速迭代，我们的目标是使其更加轻量化、更用户友好。
- 当前策略模型中采用的ResNet18在处理全图上下文关系方面存在局限，对视觉干扰的敏感度较高，限制了模型泛化到训练数据之外场景的能力。针对这一问题，未来研究将沿着两个方向展开：一方面，探索在大规模视觉-语言模型（VLM）基础上微调，使模型能够理解任务语义并生成相应的机器人控制动作；另一方面，将策略模型与大型多模态基础模型相结合，通过迁移学习增强策略对环境变化和干扰的适应能力，实现对新任务的零样本或少样本学习。
- 基于本研究开发的低成本采集系统，我们计划构建一个大规模的机器人操作预训练数据集，涵盖多种机器人平台、多样化任务和环境。我们希望新的数据集能够推动机器人操作领域的扩展规律（Scaling Laws for Robot Manipulation @lin2025datascalinglawsimitation）和泛化能力来源的研究。

// 参考文献
#bib(
  bibfunc: bibliography.with("ref.yaml"),
  full: false,
)// full: false 表示只显示已引用的文献，不显示未引用的文献；true 表示显示所有文献

#show: appendix

// 请根据文档类型，自行选择 if-else 中的内容


#if doctype == "bachelor" [

  #acknowledgement[
    本论文的顺利完成离不开众多师长和同窗的悉心指导和无私帮助。衷心感谢我的导师卢策吾教授在我的研究过程中给予极大的支持和耐心，卢老师严谨的治学态度、深厚的学术素养以及对细节的极致追求，令我受益匪浅，使我得以顺利克服重重困难，最终完成这次毕业设计。

    同时，感谢给予我重要支持和专业指导的薛寒学长、陈文迪学长。他们在理论和技术层面为我指点迷津，拓宽了我的专业视野，提升了实践能力。我刚来元知研究所的时候，他们通过小项目让我快速熟悉机器人领域的研究，包容和指正我的不足之处，点燃了我对 Manipulation 领域的兴趣，回首仍是一段美好时光。我还要感谢唐屠天学长、蒋伟学长对我的悉心指导和鼎力支持。感谢与我度过前面这一段科研时光的王毅同学、周方圆同学和永凯哥，和你们一起工作非常快乐，之后我们要继续努力，为解放人类双手贡献一份力。

    我要感谢我在 RM、ACM 和学业生涯中收获的好朋友谢奕同学、任知行同学、吴毅昕同学等，与你们的友谊给生活带来了无数快乐和积极的色彩，成长为更好的自己。同时感谢学院老师在基础和专业课上的谆谆教诲，我的成长离不开你们的培养和关怀。

    最后，特别感谢我的家人和李明珠同学，你们无条件的爱与支持，让我能够专心追求自己的科研和生活理想，你们是我最坚实的后盾，是我持续前进的动力。再次向所有在本论文撰写过程中以及我的求学生涯中给予我关心、支持和帮助的师长、家人、朋友们表示最诚挚的感谢！你们的每一份情谊，都将是我人生中宝贵的财富。

  ]
] else [
  #acknowledgement[ ]

  #achievement(
    papers: (
      "Chen H, Chan C T. Acoustic cloaking in three dimensions using acoustic metamaterials[J]. Applied Physics Letters, 2007, 91:183518.",
      "Chen H, Wu B I, Zhang B, et al. Electromagnetic Wave Interactions with a Metamaterial Cloak[J]. Physical Review Letters, 2007, 99(6):63903.",
    ),
    patents: ("第一发明人, 永动机[P], 专利申请号202510149890.0.",),
  )
]

#summary-en[
  This study focuses on the challenges of motion generation and data collection in robot manipulation imitation learning, and designs a high-degree-of-freedom, low-threshold robot motion generation and portable data collection system. The main conclusions are as follows:

  A motion generation method including multi-objective optimization and online interpolation is successfully designed and implemented to improve the motion planning effect of underactuated or redundant degrees of freedom. By introducing objective functions such as joint space offset and task space error, our method can fully utilize redundant degrees of freedom while ensuring motion smoothness. Experimental verification shows that this method significantly reduces execution delay (up to $60%$) and improves task success rate compared with traditional solutions. The execution time can be shortened by $15% ~ 40%$ in task scenarios such as folding towels.

  A low-cost and high-efficiency data collection system based on mobile devices is developed. The system is easy to carry and can capture the end effector posture with millimeter-level accuracy ($4.5 plus.minus 2.4$mm), and a single data recording takes only 10-15 seconds, which is 3-4 times faster than traditional VR teleoperation. The system can run efficiently on ordinary iPhone devices, providing the possibility of collecting data at any location.

  An improved Chunked Diffusion Policy strategy model is proposed, which introduces action chunking, time series merging and optional point cloud embedding representation. Verification experiments show that the model achieves an average success rate of 78.25% in tasks such as placing plugs and folding towels, surpassing the baseline model. Especially in the face of environmental changes and execution failures, the model shows stronger error correction and generalization capabilities.

  Experiments have shown that data diversity is more critical than data volume in strategy training. The lack of only 20% of data diversity may lead to a significant decline in model performance, The system's high versatility enables it to be quickly migrated between different robotic arm platforms, laying the foundation for large-scale robot data collection and pre-training.
  , laying the foundation for large-scale robot data collection and pre-training.
]

