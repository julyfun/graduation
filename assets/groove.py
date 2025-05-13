import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rcParams
import matplotlib.font_manager as fm

# 设置中文宋体字体
font_path = '/System/Library/Fonts/Supplemental/Songti.ttc'  # macOS上宋体路径
songti_font = fm.FontProperties(fname=font_path)
plt.rcParams['font.family'] = ['sans-serif']
plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号

print(plt.style.available
)
# 设置科研论文风格
plt.style.use('seaborn-whitegrid')
rcParams['figure.figsize'] = 10, 6
rcParams['figure.dpi'] = 150
rcParams['axes.linewidth'] = 1.5
rcParams['xtick.major.width'] = 1.5
rcParams['ytick.major.width'] = 1.5
rcParams['xtick.direction'] = 'in'
rcParams['ytick.direction'] = 'in'

# 定义函数 f_g(χ, g, Ω)
def f_g(chi, g, c, a_2, m):
    return -np.exp(-((chi-g)**2)/(2*c**2)) + a_2 * (chi-g)**m

# 设置参数
g = 0.0     # g 参数
c = 0.2     # c 参数
a_2 = 0.4   # a_2 参数
m = 2      # m 参数

# 生成 chi 值范围
chi = np.linspace(-2, 2, 1000)

# 计算函数值
y = f_g(chi, g, c, a_2, m)

# 创建图形
fig, ax = plt.subplots()

# 绘制函数
ax.plot(chi, y, 'b-', linewidth=2.5)

# 添加标题和标签
ax.set_title('谷形函数图像', fontproperties=songti_font, fontsize=16)
ax.set_xlabel('$\\chi$', fontsize=14)
ax.set_ylabel('$f_g(\\chi, g, \\Omega)$', fontsize=14)

# 添加网格
ax.grid(True, linestyle='--', alpha=0.7)

# 添加参数说明
param_text = f'$c={c}$, $a_2={a_2}$, $m={m}$'
ax.text(0.05, 0.05, param_text, transform=ax.transAxes, 
        fontproperties=songti_font, fontsize=12, bbox=dict(facecolor='white', alpha=0.8))

# 添加公式说明
formula = r'$f_g(\chi, g, \Omega) = -e^{-(\chi-g)^2/2c^2} + a_2 (\chi-g)^m$'
ax.text(0.05, 0.95, formula, transform=ax.transAxes, 
        fontsize=12, bbox=dict(facecolor='white', alpha=0.8))

# 设置坐标轴范围
ax.set_xlim([-2, 2])

# 显示图形
plt.tight_layout()
plt.savefig('function_plot.png', dpi=300, bbox_inches='tight')
plt.show()
