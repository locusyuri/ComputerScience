#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "数据科学",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style

// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "数据科学",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)


// ─────────────────────────────────────────────────────────────────────
// Part 1：数据科学基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：数据科学概述 ✅
// 1.1 数据科学定义：数据科学 vs 数据分析 vs 机器学习
// 1.2 数据科学生命周期：问题定义、数据收集、清洗、分析、建模、部署
// 1.3 数据科学家技能树：编程、统计、领域知识、沟通
// 1.4 数据伦理与隐私：GDPR、数据匿名化、偏见检测

// Chapter 2：Python 数据科学生态 ✅
// 2.1 NumPy：ndarray、广播机制、向量化运算、线性代数
// 2.2 Pandas：Series/DataFrame、索引、分组聚合、透视表
// 2.3 Matplotlib：绘图基础、子图布局、样式定制
// 2.4 Seaborn：统计可视化、分类图表、关系图表
// 2.5 Jupyter Notebook/Lab：交互式开发、魔法命令、扩展插件

// Chapter 3：数据获取与存储 🔶
// 3.1 数据来源：API 调用、Web 爬取、数据库查询、文件读取
// 3.2 文件格式：CSV、JSON、XML、Parquet、HDF5、Feather
// 3.3 数据库连接：SQLAlchemy、SQLite、PostgreSQL、MongoDB
// 3.4 大数据存储：HDFS、S3、数据湖概念


// ─────────────────────────────────────────────────────────────────────
// Part 2：数据清洗与预处理
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：数据质量评估 🔶
// 1.1 数据质量维度：完整性、准确性、一致性、时效性、唯一性
// 1.2 探索性数据分析（EDA）：describe()、info()、分布分析
// 1.3 数据剖析：缺失值统计、重复值检测、异常值识别
// 1.4 数据质量报告：自动生成、可视化展示

// Chapter 2：缺失值处理 🔶
// 2.1 缺失类型：MCAR、MAR、MNAR
// 2.2 删除策略：行删除、列删除、阈值判断
// 2.3 填充方法：均值/中位数/众数、前后向填充、插值法
// 2.4 高级填充：KNN 填充、多重插补、模型预测填充
// 2.5 缺失指示器：添加缺失标记列

// Chapter 3：异常值检测与处理 🔶
// 3.1 统计方法：Z-Score、IQR、箱线图
// 3.2 距离方法：DBSCAN、LOF 局部离群因子
// 3.3 孤立森林（Isolation Forest）：原理与应用
// 3.4 处理方法：删除、截断、转换、标记

// Chapter 4：数据转换与标准化 🔶
// 4.1 数据类型转换：数值转分类、日期解析、字符串处理
// 4.2 编码技术：Label Encoding、One-Hot Encoding、Target Encoding
// 4.3 标准化：Z-Score 标准化、Min-Max 归一化
// 4.4 变换：对数变换、Box-Cox 变换、Yeo-Johnson 变换
// 4.5 离散化：等宽分箱、等频分箱、聚类分箱

// Chapter 5：特征工程 🔶
// 5.1 特征提取：文本 TF-IDF、图像 HOG/SIFT、时间序列滞后特征
// 5.2 特征构造：多项式特征、交互特征、聚合特征
// 5.3 特征选择：过滤法（相关系数、卡方检验）、包裹法（RFE）、嵌入法（L1）
// 5.4 降维技术：PCA、t-SNE、UMAP、LDA
// 5.5 自动化特征工程：Featuretools、tsfresh

// Chapter 6：数据集成与变换 🔶
// 6.1 数据合并：merge、join、concat、append
// 6.2 数据重塑：pivot、melt、stack、unstack
// 6.3 时间序列处理：重采样、滚动窗口、时区转换
// 6.4 文本数据处理：分词、去停用词、词干提取、TF-IDF


// ─────────────────────────────────────────────────────────────────────
// Part 3：探索性数据分析（EDA）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：单变量分析 🔶
// 1.1 数值型数据：集中趋势、离散程度、分布形态
// 1.2 分类型数据：频数分布、比例分析、条形图
// 1.3 可视化：直方图、密度图、箱线图、小提琴图
// 1.4 正态性检验：Shapiro-Wilk、Kolmogorov-Smirnov

// Chapter 2：双变量分析 🔶
// 2.1 数值-数值：散点图、相关系数（Pearson/Spearman）
// 2.2 数值-分类：分组箱线图、小提琴图、ANOVA
// 2.3 分类-分类：交叉表、卡方检验、堆叠条形图
// 2.4 相关性分析：热力图、层次聚类

// Chapter 3：多变量分析 🔶
// 3.1 配对图（Pairplot）：变量间关系矩阵
// 3.2 平行坐标图：高维数据可视化
// 3.3 主成分分析（PCA）：降维可视化、方差解释
// 3.4 t-SNE/UMAP：非线性降维、流形学习

// Chapter 4：时间序列分析 🔶
// 4.1 时间序列分解：趋势、季节性、残差
// 4.2 自相关与偏自相关：ACF、PACF
// 4.3 平稳性检验：ADF 检验、KPSS 检验
// 4.4 可视化：时序图、季节图、滞后图

// Chapter 5：自动化 EDA 工具 ⚪
// 5.1 Pandas Profiling / ydata-profiling：自动报告生成
// 5.2 Sweetviz：对比分析、HTML 报告
// 5.3 AutoViz：自动可视化、交互式图表
// 5.4 Dtale：交互式数据探索


// ─────────────────────────────────────────────────────────────────────
// Part 4：统计分析基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：描述性统计 🔶
// 1.1 集中趋势：均值、中位数、众数、分位数
// 1.2 离散程度：方差、标准差、极差、IQR
// 1.3 分布形态：偏度、峰度、矩
// 1.4 位置度量：百分位数、四分位数

// Chapter 2：概率分布 🔶
// 2.1 离散分布：伯努利、二项、泊松、几何
// 2.2 连续分布：均匀、正态、指数、伽马、Beta
// 2.3 多元分布：多元正态、Dirichlet
// 2.4 中心极限定理：样本均值的分布

// Chapter 3：参数估计 🔶
// 3.1 点估计：矩估计、最大似然估计（MLE）
// 3.2 区间估计：置信区间、Bootstrap 方法
// 3.3 贝叶斯估计：先验、后验、共轭先验
// 3.4 估计量性质：无偏性、一致性、有效性

// Chapter 4：假设检验 🔶
// 4.1 基本概念：原假设、备择假设、p 值、显著性水平
// 4.2 Z 检验与 t 检验：单样本、双样本、配对 t 检验
// 4.3 方差分析（ANOVA）：单因素、多因素、事后检验
// 4.4 非参数检验：Mann-Whitney U、Wilcoxon、Kruskal-Wallis
// 4.5 卡方检验：拟合优度、独立性检验

// Chapter 5：回归分析 🔶
// 5.1 简单线性回归：最小二乘法、R²、残差分析
// 5.2 多元线性回归：多重共线性、VIF、逐步回归
// 5.3 逻辑回归：sigmoid、 odds ratio、ROC 曲线
// 5.4 正则化回归：Ridge、Lasso、Elastic Net
// 5.5 广义线性模型（GLM）：链接函数、指数族分布


// ─────────────────────────────────────────────────────────────────────
// Part 5：数据可视化进阶
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Matplotlib 进阶 🔶
// 1.1 面向对象接口：Figure、Axes、Artist
// 1.2 自定义样式：rcParams、样式表、颜色映射
// 1.3 注释与文本：annotate、text、箭头
// 1.4 3D 绘图：mpl_toolkits、表面图、散点图
// 1.5 动画：FuncAnimation、保存 GIF/MP4

// Chapter 2：Seaborn 进阶 🔶
// 2.1 关系图表：relplot、scatterplot、lineplot
// 2.2 分布图表：displot、histplot、kdeplot
// 2.3 分类图表：catplot、boxplot、violinplot、barplot
// 2.4 矩阵图表：heatmap、clustermap
// 2.5 多图表组合：FacetGrid、PairGrid、JointGrid

// Chapter 3：Plotly 交互式可视化 ⚪
// 3.1 Plotly Express：快速绘图、交互功能
// 3.2 Graph Objects：精细控制、自定义布局
// 3.3 Dash：Web 应用框架、回调机制
// 3.4 图表类型：3D 图表、地图、金融图表

// Chapter 4：地理数据可视化 ⚪
// 4.1 GeoPandas：地理数据处理、空间连接
// 4.2 Folium：交互式地图、标记、热力图
// 4.3 Choropleth 地图：分级统计图、等值线
// 4.4 空间分析：缓冲区、叠加分析、最近邻

// Chapter 5：信息图表设计原则 ⚪
// 5.1 视觉编码：位置、长度、角度、面积、颜色
// 5.2 图表选择指南：比较、分布、关系、组成
// 5.3 色彩理论：色相、饱和度、亮度、色盲友好
// 5.4 故事叙述：数据叙事、上下文、标注


// ─────────────────────────────────────────────────────────────────────
// Part 6：SQL 与数据库
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：SQL 基础 🔶
// 1.1 基本查询：SELECT、FROM、WHERE、ORDER BY
// 1.2 聚合函数：COUNT、SUM、AVG、MIN/MAX、GROUP BY
// 1.3 多表连接：INNER/LEFT/RIGHT/FULL JOIN
// 1.4 子查询：标量子查询、表子查询、相关子查询

// Chapter 2：SQL 进阶 🔶
// 2.1 窗口函数：ROW_NUMBER、RANK、DENSE_RANK、LEAD/LAG
// 2.2 CTE 公用表表达式：WITH 子句、递归 CTE
// 2.3 条件逻辑：CASE WHEN、COALESCE、NULLIF
// 2.4 集合操作：UNION、INTERSECT、EXCEPT

// Chapter 3：数据库设计 🔶
// 3.1 范式理论：1NF、2NF、3NF、BCNF
// 3.2 ER 图：实体、关系、属性、基数
// 3.3 索引优化：B-Tree、Hash、覆盖索引、最左前缀
// 3.4 视图与物化视图：创建、更新、性能

// Chapter 4：Python 与 SQL 集成 🔶
// 4.1 SQLAlchemy：ORM、Core、引擎、会话
// 4.2 Pandas SQL：read_sql、to_sql、SQLAlchemy 集成
// 4.3 数据库连接池：连接管理、超时设置
// 4.4 NoSQL 数据库：MongoDB、Redis、Cassandra


// ─────────────────────────────────────────────────────────────────────
// Part 7：大数据基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：大数据生态概览 ⚪
// 1.1 大数据 4V：Volume、Velocity、Variety、Veracity
// 1.2 Hadoop 生态：HDFS、MapReduce、YARN
// 1.3 Spark 架构：RDD、DataFrame、Spark SQL
// 1.4 数据湖 vs 数据仓库：概念、架构、选型

// Chapter 2：PySpark 基础 ⚪
// 2.1 SparkSession：创建、配置、停止
// 2.2 DataFrame API：读写、转换、行动操作
// 2.3 Spark SQL：临时视图、SQL 查询
// 2.4 性能优化：缓存、分区、广播变量

// Chapter 3：分布式数据处理 ⚪
// 3.1 MapReduce 编程模型：Map、Shuffle、Reduce
// 3.2 Spark RDD：创建、转换、行动、持久化
// 3.3 Dask：并行计算、延迟执行、大规模数组
// 3.4 Ray：分布式 Python、Actor 模型

// Chapter 4：数据管道与工作流 ⚪
// 4.1 Apache Airflow：DAG、Operator、调度
// 4.2 Prefect：现代工作流编排、任务依赖
// 4.3 dbt：数据转换、测试、文档
// 4.4 实时数据流：Kafka、Spark Streaming、Flink
