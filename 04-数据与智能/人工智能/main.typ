#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "人工智能",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style

// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "人工智能",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)


// ─────────────────────────────────────────────────────────────────────
// Part 1：人工智能导论（基础知识）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：人工智能概述 ✅
// 1.1 AI 定义与发展历程：图灵测试、AI 寒冬、深度学习革命
// 1.2 AI 的分类：弱 AI vs 强 AI、符号主义 vs 连接主义、行为主义
// 1.3 AI 的研究领域：计算机视觉、自然语言处理、语音识别、机器人学
// 1.4 AI 伦理与社会影响：偏见、隐私、就业、安全、可解释性

// Chapter 2：数学基础 🔶
// 2.1 线性代数：向量、矩阵、特征值分解、SVD、谱定理
// 2.2 概率论与统计：概率分布、贝叶斯定理、最大似然估计、假设检验
// 2.3 微积分：梯度、偏导数、链式法则、泰勒展开、雅可比矩阵
// 2.4 优化理论：凸优化、拉格朗日乘子法、KKT 条件、梯度下降

// Chapter 3：信息论基础 ⚪
// 3.1 熵与信息量：香农熵、联合熵、条件熵
// 3.2 互信息：点互信息、归一化互信息
// 3.3 KL 散度：相对熵、JS 散度、交叉熵
// 3.4 编码理论：霍夫曼编码、算术编码

// Chapter 4：搜索与推理 🔶
// 4.1 无信息搜索：BFS、DFS、迭代加深、双向搜索
// 4.2 启发式搜索：A* 算法、IDA*、贪心最佳优先
// 4.3 对抗搜索：Minimax、Alpha-Beta 剪枝、Monte Carlo Tree Search
// 4.4 约束满足问题（CSP）：回溯搜索、弧相容、向前检查


// ─────────────────────────────────────────────────────────────────────
// Part 2：机器学习基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：机器学习概述 🔶
// 1.1 机器学习定义与分类：监督学习、无监督学习、半监督学习、强化学习
// 1.2 机器学习工作流程：数据准备、模型训练、评估、部署
// 1.3 过拟合与欠拟合：偏差-方差权衡、正则化
// 1.4 模型评估指标：准确率、精确率、召回率、F1、AUC-ROC

// Chapter 2：线性模型 🔶
// 2.1 线性回归：最小二乘法、正规方程、梯度下降
// 2.2 逻辑回归：sigmoid 函数、交叉熵损失、多分类
// 2.3 正则化：L1（Lasso）、L2（Ridge）、Elastic Net
// 2.4 广义线性模型：softmax 回归、感知机

// Chapter 3：决策树与集成学习 🔶
// 3.1 决策树：ID3、C4.5、CART、信息增益、基尼系数
// 3.2 随机森林：Bagging、特征随机性、OOB 评估
// 3.3 Gradient Boosting：AdaBoost、GBDT、XGBoost
// 3.4 LightGBM 与 CatBoost：直方图算法、叶子生长策略
// 3.5 Stacking 与 Blending：模型融合技术

// Chapter 4：支持向量机（SVM）🔶
// 4.1 SVM 原理：最大间隔超平面、支持向量
// 4.2 核技巧：线性核、多项式核、RBF 核
// 4.3 软间隔与正则化：松弛变量、C 参数
// 4.4 SVM 扩展：SVR、One-Class SVM

// Chapter 5：聚类算法 🔶
// 5.1 K-Means：算法流程、K 值选择、K-Means++
// 5.2 层次聚类：凝聚法、分裂法、树状图
// 5.3 DBSCAN：密度聚类、核心点、边界点、噪声点
// 5.4 GMM 高斯混合模型：EM 算法、软聚类
// 5.5 聚类评估：轮廓系数、Calinski-Harabasz 指数

// Chapter 6：降维与流形学习 🔶
// 6.1 PCA 主成分分析：协方差矩阵、特征向量、累计方差贡献率
// 6.2 t-SNE：高维数据可视化、困惑度参数
// 6.3 UMAP：统一流形逼近、保留全局结构
// 6.4 LDA 线性判别分析：类间散度、类内散度

// Chapter 7：启发式优化算法 ⚪
// 7.1 遗传算法（GA）：选择、交叉、变异、适应度函数
// 7.2 模拟退火（SA）：Metropolis 准则、温度调度、冷却策略
// 7.3 粒子群优化（PSO）：个体最优、全局最优、速度更新
// 7.4 蚁群算法（ACO）：信息素更新、启发因子、路径选择
// 7.5 其他启发式算法：禁忌搜索、人工蜂群、差分进化
// 7.6 应用场景：组合优化、超参数调优、特征选择

// Chapter 8：概率图模型 ⚪
// 8.1 贝叶斯网络：有向图、条件独立性、推断算法
// 8.2 马尔可夫随机场：无向图、势函数、团
// 8.3 隐马尔可夫模型（HMM）：前向算法、Viterbi 算法
// 8.4 条件随机场（CRF）：序列标注、分词应用


// ─────────────────────────────────────────────────────────────────────
// Part 3：深度学习基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：神经网络基础 🔶
// 1.1 感知机与多层感知机（MLP）：神经元模型、激活函数
// 1.2 反向传播算法：链式法则、梯度计算、权重更新
// 1.3 激活函数：Sigmoid、Tanh、ReLU、Leaky ReLU、Swish
// 1.4 损失函数：MSE、交叉熵、Huber Loss、Focal Loss
// 1.5 优化器：SGD、Momentum、Adam、AdamW、LAMB

// Chapter 2：深度学习框架 🔶
// 2.1 PyTorch 基础：Tensor、自动求导、nn.Module
// 2.2 PyTorch 数据加载：Dataset、DataLoader、transforms
// 2.3 模型训练循环：forward、backward、optimizer.step
// 2.4 模型保存与加载：state_dict、checkpoint
// 2.5 TensorBoard 可视化：损失曲线、计算图、 embeddings

// Chapter 3：训练技巧与调优 🔶
// 3.1 权重初始化：Xavier、He、正交初始化
// 3.2 批量归一化（BatchNorm）：原理、实现、LayerNorm
// 3.3 Dropout 正则化：随机失活、Inverted Dropout
// 3.4 学习率调度：StepLR、Cosine Annealing、Warmup
// 3.5 早停法（Early Stopping）：验证集监控、patience
// 3.6 梯度裁剪：防止梯度爆炸、范数裁剪

// Chapter 4：卷积神经网络（CNN）🔶
// 4.1 卷积操作：卷积核、步长、填充、输出尺寸计算
// 4.2 池化层：最大池化、平均池化、全局池化
// 4.3 经典 CNN 架构：LeNet、AlexNet、VGG、GoogLeNet
// 4.4 ResNet：残差连接、瓶颈结构、深度网络训练
// 4.5 现代 CNN：EfficientNet、ConvNeXt、MobileNet

// Chapter 5：循环神经网络（RNN）🔶
// 5.1 RNN 基础：时序建模、隐藏状态、BPTT
// 5.2 LSTM：遗忘门、输入门、输出门、细胞状态
// 5.3 GRU：简化 LSTM、更新门、重置门
// 5.4 双向 RNN：前向 + 后向、上下文信息
// 5.5 RNN 应用：语言模型、机器翻译、语音识别


// ─────────────────────────────────────────────────────────────────────
// Part 4：计算机视觉
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：图像分类 🔶
// 1.1 图像分类任务：单标签、多标签、细粒度分类
// 1.2 数据增强：翻转、旋转、裁剪、颜色抖动、Mixup、CutMix
// 1.3 迁移学习：预训练模型、微调策略、特征提取
// 1.4 模型压缩：剪枝、量化、知识蒸馏

// Chapter 2：目标检测 🔶
// 2.1 目标检测概述：边界框、IoU、mAP、NMS
// 2.2 Two-Stage 检测器：R-CNN、Fast R-CNN、Faster R-CNN
// 2.3 One-Stage 检测器：YOLO 系列、SSD、RetinaNet
// 2.4 Anchor-Free 检测器：FCOS、CenterNet、DETR
// 2.5 检测优化：FPN、PANet、BiFPN

// Chapter 3：语义分割与实例分割 🔶
// 3.1 语义分割：FCN、U-Net、DeepLab 系列
// 3.2 实例分割：Mask R-CNN、SOLO、YOLACT
// 3.3 全景分割：结合语义与实例、Panoptic FPN
// 3.4 分割评估：IoU、Dice Coefficient、Pixel Accuracy

// Chapter 4：图像生成 ⚪
// 4.1 自编码器（AE）：编码-解码、潜在空间
// 4.2 变分自编码器（VAE）：重参数化技巧、KL 散度
// 4.3 生成对抗网络（GAN）：Generator、Discriminator、训练技巧
// 4.4 扩散模型（Diffusion）：前向过程、反向过程、DDPM、Stable Diffusion
// 4.5 图像超分辨率：SRCNN、ESRGAN、Real-ESRGAN

// Chapter 5：视频理解 ⚪
// 5.1 视频分类：3D CNN、Two-Stream Network、SlowFast
// 5.2 动作检测：时空定位、Tubelet 检测
// 5.3 视频目标跟踪：Siamese Network、Transformer Tracker
// 5.4 视频生成：Video GAN、Diffusion Video


// ─────────────────────────────────────────────────────────────────────
// Part 5：自然语言处理（NLP）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：NLP 基础 🔶
// 1.1 文本预处理：分词、去停用词、词干提取、词形还原
// 1.2 词表示：One-Hot、TF-IDF、Word2Vec、GloVe、FastText
// 1.3 语言模型：N-Gram、神经语言模型、 perplexity
// 1.4 文本分类：情感分析、主题分类、意图识别

// Chapter 2：序列到序列模型 🔶
// 2.1 Encoder-Decoder 架构：编码、解码、注意力机制
// 2.2 注意力机制（Attention）：Scaled Dot-Product、Multi-Head
// 2.3 机器翻译：BLEU 评分、束搜索（Beam Search）
// 2.4 文本摘要：抽取式摘要、生成式摘要、ROUGE 评分

// Chapter 3：Transformer 架构 🔶
// 3.1 Transformer 详解：Self-Attention、Positional Encoding、FFN
// 3.2 BERT：预训练任务（MLM、NSP）、微调策略
// 3.3 GPT 系列：自回归语言模型、提示工程、In-Context Learning
// 3.4 T5：Text-to-Text 框架、统一 NLP 任务
// 3.5 高效 Transformer：Linformer、Performer、Reformer

// Chapter 4：大语言模型（LLM）🔶
// 4.1 LLM 概述：规模定律、涌现能力、指令跟随
// 4.2 预训练语料：Common Crawl、The Pile、清洗与去重
// 4.3 对齐技术：SFT（监督微调）、RLHF、DPO
// 4.4 提示工程：Zero-Shot、Few-Shot、Chain-of-Thought
// 4.5 LLM 应用：问答系统、代码生成、Agent、RAG

// Chapter 5：信息抽取与知识图谱 ⚪
// 5.1 命名实体识别（NER）：BiLSTM-CRF、BERT-NER
// 5.2 关系抽取：远程监督、联合抽取、Graph Neural Network
// 5.3 知识图谱构建：实体链接、关系补全、知识融合
// 5.4 知识图谱应用：问答、推荐、推理


// ─────────────────────────────────────────────────────────────────────
// Part 6：强化学习
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：强化学习基础 🔶
// 1.1 RL 基本概念：Agent、Environment、State、Action、Reward
// 1.2 MDP 马尔可夫决策过程：状态转移、奖励函数、折扣因子
// 1.3 价值函数：状态价值 V(s)、动作价值 Q(s,a)
// 1.4 探索与利用：ε-greedy、UCB、Thompson Sampling

// Chapter 2：表格方法 🔶
// 2.1 动态规划：策略迭代、价值迭代、贝尔曼方程
// 2.2 Monte Carlo 方法：首次访问、每次访问、重要性采样
// 2.3 Temporal Difference（TD）：TD(0)、Sarsa、Q-Learning
// 2.4 n-step TD：n-step Sarsa、n-step Q-Learning

// Chapter 3：深度强化学习 🔶
// 3.1 DQN：经验回放、目标网络、Double DQN、Dueling DQN
// 3.2 Policy Gradient：REINFORCE、Actor-Critic、A2C
// 3.3 PPO： clipped surrogate objective、信任区域
// 3.4 SAC：最大熵 RL、软 Q-Learning、自动温度调节
// 3.5 DDPG/TD3：连续动作空间、确定性策略梯度

// Chapter 4：高级强化学习 ⚪
// 4.1 Model-Based RL：世界模型、规划、MuZero
// 4.2 多智能体 RL：合作、竞争、MARL 算法
// 4.3 模仿学习：行为克隆、逆强化学习、GAIL
// 4.4 Meta-RL：元学习、快速适应、MAML
// 4.5 RL 应用：游戏 AI（AlphaGo、OpenAI Five）、机器人控制


// ─────────────────────────────────────────────────────────────────────
// Part 7：AI 工程化与部署
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：模型训练工程化 🔶
// 1.1 分布式训练：数据并行、模型并行、ZeRO
// 1.2 混合精度训练：FP16、BF16、AMP、损失缩放
// 1.3 实验管理：MLflow、Weights & Biases、TensorBoard
// 1.4 超参数优化：网格搜索、随机搜索、贝叶斯优化、Optuna

// Chapter 2：模型部署 🔶
// 2.1 模型导出：ONNX、TorchScript、SavedModel
// 2.2 推理引擎：TensorRT、OpenVINO、ONNX Runtime
// 2.3 服务化部署：Flask/FastAPI、TorchServe、Triton Inference Server
// 2.4 边缘部署：TensorFlow Lite、Core ML、NCNN、MNN
// 2.5 模型监控：延迟、吞吐量、错误率、漂移检测

// Chapter 3：MLOps ⚪
// 3.1 数据版本控制：DVC、LakeFS
// 3.2 持续集成/持续部署：GitHub Actions、Jenkins、Kubeflow
// 3.3 模型注册表：MLflow Model Registry、SageMaker Model Registry
// 3.4 A/B 测试：流量分割、指标对比、灰度发布
// 3.5 模型治理：合规性、审计、可解释性

// Chapter 4：云计算与 AI 平台 ⚪
// 4.1 GPU 云计算：AWS EC2、Azure VM、GCP Compute Engine
// 4.2 AI 平台：SageMaker、Vertex AI、Azure ML
// 4.3 容器化：Docker、Kubernetes、GPU 资源调度
// 4.4 无服务器推理：AWS Lambda、Cloud Functions


// ─────────────────────────────────────────────────────────────────────
// Part 8：AI 前沿与伦理
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：可解释 AI（XAI）⚪
// 1.1 可解释性的重要性：黑盒问题、信任、监管
// 1.2 事后解释：LIME、SHAP、Grad-CAM、Integrated Gradients
// 1.3 内在可解释模型：决策树、规则列表、注意力可视化
// 1.4 公平性与偏见：群体公平、个体公平、去偏见技术

// Chapter 2：AI 安全与对抗攻击 ⚪
// 2.1 对抗样本：FGSM、PGD、CW Attack、防御方法
// 2.2 数据投毒：后门攻击、标签翻转、防御策略
// 2.3 模型窃取：模型提取攻击、水印保护
// 2.4 隐私保护：差分隐私、联邦学习、同态加密

// Chapter 3：多模态学习 ⚪
// 3.1 多模态融合：早期融合、晚期融合、中间融合
// 3.2 CLIP：对比学习、图文匹配、零样本分类
// 3.3 DALL-E / Midjourney：文生图、扩散模型
// 3.4 多模态大模型：GPT-4V、Gemini、Qwen-VL

// Chapter 4：AI 未来展望 ⚪
// 4.1 AGI 通用人工智能：定义、挑战、路径
// 4.2 神经符号 AI：结合符号推理与深度学习
// 4.3 脑机接口：Neuralink、EEG 解码、应用前景
// 4.4 AI 与社会：就业变革、教育、医疗、法律
