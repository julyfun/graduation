import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rcParams
import matplotlib.font_manager as fm

# 设置中文宋体字体
font_path = '/usr/share/fonts/opentype/SourceHanSerifCN-Bold-2.otf'  # macOS上宋体路径
songti_font = fm.FontProperties(fname=font_path)
plt.rcParams['font.family'] = ['sans-serif']
plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号

# 设置科研论文风格
plt.style.use('seaborn-whitegrid')
rcParams['figure.figsize'] = 10, 6
rcParams['figure.dpi'] = 150
rcParams['axes.linewidth'] = 1.5
rcParams['xtick.major.width'] = 1.5
rcParams['ytick.major.width'] = 1.5
rcParams['xtick.direction'] = 'in'
rcParams['ytick.direction'] = 'in'

# 定义函数 f_r(χ, l, u, Ω)
def f_r(chi, l, m, a_1, a_2, b, n):
    return (a_1 + a_2 * chi**(l*m)) * (1 - np.exp(-chi**n / b**n)) - 1

# 设置参数
l = 1.0     # l 参数
m = 2.0     # m 参数
a_1 = 1.5   # a_1 参数
a_2 = 0.5   # a_2 参数
b = 1.0     # b 参数
n = 20.0     # n 参数

# 生成 chi 值范围
chi = np.linspace(-2, 2, 1000)  # 从0开始，因为可能有负数的幂

# 计算函数值
y = f_r(chi, l, m, a_1, a_2, b, n)

# 创建图形
fig, ax = plt.subplots()

# 绘制函数
ax.plot(chi, y, 'k-', linewidth=2.5)

# 添加标题和标签
ax.set_title('陷阱函数图像', fontproperties=songti_font, fontsize=16)
ax.set_xlabel('$\\chi$', fontsize=14)
ax.set_ylabel('$f_r(\\chi, l, u, \\Omega)$', fontsize=14)

# 添加网格
ax.grid(True, linestyle='--', alpha=0.7)

# 添加参数说明
param_text = f'$l={l}$, $m={m}$, $a_1={a_1}$, $a_2={a_2}$, $b={b}$, $n={n}$'
ax.text(0.05, 0.05, param_text, transform=ax.transAxes, 
        fontproperties=songti_font, fontsize=12, bbox=dict(facecolor='white', alpha=0.8))

# 添加公式说明
formula = r'$f_r(\chi, l, u, \Omega) = (a_1 + a_2 \chi^{lm}) \left( 1 - e^{-\chi^n / b^n} \right) - 1$'
ax.text(0.05, 0.95, formula, transform=ax.transAxes, 
        fontsize=12, bbox=dict(facecolor='white', alpha=0.8))

# 设置坐标轴范围
ax.set_xlim([-2, 2])
ax.set_ylim([-1.8, 3])

# 显示图形
plt.tight_layout()
plt.savefig('swap_function_plot.png', dpi=300, bbox_inches='tight')
plt.show() 
