import numpy as np
import matplotlib.pyplot as plt
from matplotlib import rcParams
import matplotlib.font_manager as fm
import numpy as np

# 设置中文宋体字体
font_path = '/System/Library/Fonts/Supplemental/Songti.ttc'  # macOS上宋体路径
songti_font = fm.FontProperties(fname=font_path)
plt.rcParams['font.family'] = ['sans-serif']
plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号

# 设置科研论文风格
plt.style.use('seaborn-whitegrid')
rcParams['figure.figsize'] = 6, 4.5
rcParams['figure.dpi'] = 150
rcParams['axes.linewidth'] = 1.5
rcParams['xtick.major.width'] = 1.5
rcParams['ytick.major.width'] = 1.5
rcParams['xtick.direction'] = 'in'
rcParams['ytick.direction'] = 'in'

# 数据
x = [0, 10, 20, 30, 40, 50]
y1 = np.array([0, 22, 26, 25, 28, 27]) / 30 * 100
y2 = np.array([0, 26, 27, 28, 28, 28]) / 30 * 100

# [0, 3, 5, 9, 13, 13]
# [0, 14, 18, 21, 16, 20]
y1 = np.array([0, 96, 98, 90, 92, 98])
y2 = np.array([0, 89, 92, 98, 93, 96])

# y1 = np.array([0, 13, 22, 36, 34, 40])
# y2 = np.array([0, 20, 31, 55, 58, 59])

# 创建图形
fig, ax = plt.subplots()

# set title
ax.set_title('摆放杯子', fontproperties=songti_font, fontsize=18)

# 绘制两条折线
line1, = ax.plot(x, y1, 'o-', linewidth=2, markersize=8, label='3D Diffusion Policy', color='#e6ab43')
line2, = ax.plot(x, y2, 's-', linewidth=2, markersize=8, label='CDP', color='#41b696')

# 添加标题和标签
ax.set_xlabel('演示数据数量', fontproperties=songti_font, fontsize=14)
ax.set_ylabel('得分', fontproperties=songti_font, fontsize=14)

# 设置刻度
ax.set_xticks(x)

# 增大坐标轴刻度字体大小
plt.xticks(fontsize=14)
plt.yticks(fontsize=14)

# 添加网格
ax.grid(True, linestyle='--', alpha=0.7)

# 添加图例
ax.legend(prop=songti_font, loc='best', frameon=True, facecolor='white', edgecolor='gray')

# 标注数据点
# for i, (v1, v2) in enumerate(zip(y1, y2)):
#     ax.annotate(f'{v1}', (x[i], v1), textcoords="offset points", 
#                 xytext=(0,10), ha='center', fontproperties=songti_font)
#     ax.annotate(f'{v2}', (x[i], v2), textcoords="offset points", 
#                 xytext=(0,10), ha='center', fontproperties=songti_font)

# 调整布局并保存
plt.ylim(0, 100)
plt.tight_layout()
plt.savefig('policy_comparison.png', dpi=300, bbox_inches='tight')
plt.show()
