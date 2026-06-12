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
#part("人工智能导论")

// Chapter 1：人工智能概述 ✅
// 1.1 AI 定义与发展历程：图灵测试、AI 寒冬、深度学习革命
// 1.2 AI 的分类：弱 AI vs 强 AI、符号主义 vs 连接主义、行为主义
// 1.3 AI 的研究领域：计算机视觉、自然语言处理、语音识别、机器人学
// 1.4 AI 伦理与社会影响：偏见、隐私、就业、安全、可解释性
= 人工智能概述

// Chapter 2：数学基础 🔶
// 2.1 线性代数：向量、矩阵、特征值分解、SVD、谱定理
// 2.2 概率论与统计：概率分布、贝叶斯定理、最大似然估计、假设检验
// 2.3 微积分：梯度、偏导数、链式法则、泰勒展开、雅可比矩阵
// 2.4 优化理论：凸优化、拉格朗日乘子法、KKT 条件、梯度下降
= 数学基础

// Chapter 3：信息论基础 ⚪
// 3.1 熵与信息量：香农熵、联合熵、条件熵
// 3.2 互信息：点互信息、归一化互信息
// 3.3 KL 散度：相对熵、JS 散度、交叉熵
// 3.4 编码理论：霍夫曼编码、算术编码
= 信息论基础

// Chapter 4：搜索与推理 🔶
// 4.1 无信息搜索：BFS、DFS、迭代加深、双向搜索
// 4.2 启发式搜索：A* 算法、IDA*、贪心最佳优先
// 4.3 对抗搜索：Minimax、Alpha-Beta 剪枝、Monte Carlo Tree Search
// 4.4 约束满足问题（CSP）：回溯搜索、弧相容、向前检查
= 搜索与推理


// ─────────────────────────────────────────────────────────────────────
// Part 2：机器学习基础
// ─────────────────────────────────────────────────────────────────────
#part("机器学习基础")

// Chapter 1：机器学习概述 🔶
// 1.1 机器学习定义与分类：监督学习、无监督学习、半监督学习、强化学习
// 1.2 机器学习工作流程：数据准备、模型训练、评估、部署
// 1.3 过拟合与欠拟合：偏差-方差权衡、正则化
// 1.4 模型评估指标：准确率、精确率、召回率、F1、AUC-ROC
= 机器学习概述

// Chapter 2：线性模型 🔶
// 2.1 线性回归：最小二乘法、正规方程、梯度下降
// 2.2 逻辑回归：sigmoid 函数、交叉熵损失、多分类
// 2.3 正则化：L1（Lasso）、L2（Ridge）、Elastic Net
// 2.4 广义线性模型：softmax 回归、感知机
= 线性模型

// Chapter 3：决策树与集成学习 🔶
// 3.1 决策树：ID3、C4.5、CART、信息增益、基尼系数
// 3.2 随机森林：Bagging、特征随机性、OOB 评估
// 3.3 Gradient Boosting：AdaBoost、GBDT、XGBoost
// 3.4 LightGBM 与 CatBoost：直方图算法、叶子生长策略
// 3.5 Stacking 与 Blending：模型融合技术
= 决策树与集成学习

// Chapter 4：支持向量机（SVM）🔶
// 4.1 SVM 原理：最大间隔超平面、支持向量
// 4.2 核技巧：线性核、多项式核、RBF 核
// 4.3 软间隔与正则化：松弛变量、C 参数
// 4.4 SVM 扩展：SVR、One-Class SVM
= 支持向量机

// Chapter 5：聚类算法 🔶
// 5.1 K-Means：算法流程、K 值选择、K-Means++
// 5.2 层次聚类：凝聚法、分裂法、树状图
// 5.3 DBSCAN：密度聚类、核心点、边界点、噪声点
// 5.4 GMM 高斯混合模型：EM 算法、软聚类
// 5.5 聚类评估：轮廓系数、Calinski-Harabasz 指数
= 聚类算法

// Chapter 6：降维与流形学习 🔶
// 6.1 PCA 主成分分析：协方差矩阵、特征向量、累计方差贡献率
// 6.2 t-SNE：高维数据可视化、困惑度参数
// 6.3 UMAP：统一流形逼近、保留全局结构
// 6.4 LDA 线性判别分析：类间散度、类内散度
= 降维与流形学习

// Chapter 7：启发式优化算法 ⚪
// 7.1 遗传算法（GA）：选择、交叉、变异、适应度函数
// 7.2 模拟退火（SA）：Metropolis 准则、温度调度、冷却策略
// 7.3 粒子群优化（PSO）：个体最优、全局最优、速度更新
// 7.4 蚁群算法（ACO）：信息素更新、启发因子、路径选择
// 7.5 其他启发式算法：禁忌搜索、人工蜂群、差分进化
// 7.6 应用场景：组合优化、超参数调优、特征选择
= 启发式优化算法

// Chapter 8：概率图模型 ⚪
// 8.1 贝叶斯网络：有向图、条件独立性、推断算法
// 8.2 马尔可夫随机场：无向图、势函数、团
// 8.3 隐马尔可夫模型（HMM）：前向算法、Viterbi 算法
// 8.4 条件随机场（CRF）：序列标注、分词应用
= 概率图模型


// ─────────────────────────────────────────────────────────────────────
// Part 3：深度学习基础
// ─────────────────────────────────────────────────────────────────────
#part("深度学习基础")

// Chapter 1：神经网络基础 🔶
// 1.1 感知机与多层感知机（MLP）：神经元模型、激活函数
// 1.2 反向传播算法：链式法则、梯度计算、权重更新
// 1.3 激活函数：Sigmoid、Tanh、ReLU、Leaky ReLU、Swish
// 1.4 损失函数：MSE、交叉熵、Huber Loss、Focal Loss
// 1.5 优化器：SGD、Momentum、Adam、AdamW、LAMB
= 神经网络基础

// Chapter 2：深度学习框架 🔶
// 2.1 PyTorch 基础：Tensor、自动求导、nn.Module
// 2.2 PyTorch 数据加载：Dataset、DataLoader、transforms
// 2.3 模型训练循环：forward、backward、optimizer.step
// 2.4 模型保存与加载：state_dict、checkpoint
// 2.5 TensorBoard 可视化：损失曲线、计算图、 embeddings
= 深度学习框架

// Chapter 3：训练技巧与调优 🔶
// 3.1 权重初始化：Xavier、He、正交初始化
// 3.2 批量归一化（BatchNorm）：原理、实现、LayerNorm
// 3.3 Dropout 正则化：随机失活、Inverted Dropout
// 3.4 学习率调度：StepLR、Cosine Annealing、Warmup
// 3.5 早停法（Early Stopping）：验证集监控、patience
// 3.6 梯度裁剪：防止梯度爆炸、范数裁剪
= 训练技巧与调优

// Chapter 4：卷积神经网络（CNN）🔶
// 4.1 卷积操作：卷积核、步长、填充、输出尺寸计算
// 4.2 池化层：最大池化、平均池化、全局池化
// 4.3 经典 CNN 架构：LeNet、AlexNet、VGG、GoogLeNet
// 4.4 ResNet：残差连接、瓶颈结构、深度网络训练
// 4.5 现代 CNN：EfficientNet、ConvNeXt、MobileNet
= 卷积神经网络

// Chapter 5：循环神经网络（RNN）🔶
// 5.1 RNN 基础：时序建模、隐藏状态、BPTT
// 5.2 LSTM：遗忘门、输入门、输出门、细胞状态
// 5.3 GRU：简化 LSTM、更新门、重置门
// 5.4 双向 RNN：前向 + 后向、上下文信息
// 5.5 RNN 应用：语言模型、机器翻译、语音识别
= 循环神经网络（RNN）

// Chapter 6：Transformer 架构 🔶
// 6.1 Self-Attention 机制：Scaled Dot-Product、Multi-Head Attention
// 6.2 Positional Encoding：绝对位置编码、相对位置编码、RoPE
// 6.3 Encoder-Decoder 架构：Pre-LN、Post-LN、FFN
// 6.4 高效 Transformer：Linformer、Performer、Reformer、FlashAttention
= Transformer 架构


// ─────────────────────────────────────────────────────────────────────
// Part 4：计算机视觉
// ─────────────────────────────────────────────────────────────────────
#part("计算机视觉")

// Chapter 1：图像分类与识别 🔶
// 1.1 图像分类任务概述：ImageNet、CIFAR、评估指标（Top-1、Top-5）
// 1.2 经典分类器回顾：k-NN 决策边界、线性分类器 score function（参见 Part 2 Ch2/Ch4）
// 1.3 损失与正则化：折叶损失（SVM）、交叉熵损失、L1/L2 正则（参见 Part 2 Ch2）
// 1.4 优化算法回顾：SGD、Momentum、Adam、学习率调度（参见 Part 3 Ch1/Ch3）
// 1.5 数据增强：几何变换、颜色抖动、Mixup、CutMix、AutoAugment、RandAugment
// 1.6 迁移学习与微调：冻结策略、判别式微调、线性探测、LoRA
= 图像分类与识别

// Chapter 2：卷积神经网络进阶 🔶
// 2.1 卷积与池化回顾：卷积核、步长、填充、通道（参见 Part 3 Ch4）
// 2.2 经典 CNN 架构演进：LeNet → AlexNet → VGGNet → GoogLeNet → ResNet
// 2.3 现代 CNN 设计：EfficientNet、ConvNeXt、MobileNet、Swin Transformer
// 2.4 CNN 可视化：特征图可视化、滤波器可视化、Grad-CAM、DeepDream
// 2.5 轻量化技术：深度可分离卷积、分组卷积、模型剪枝、知识蒸馏
= 卷积神经网络进阶

// Chapter 3：目标检测 🔶
// 3.1 目标检测概述：边界框、IoU、mAP、NMS
// 3.2 Two-Stage 检测器：R-CNN、Fast R-CNN、Faster R-CNN
// 3.3 One-Stage 检测器：YOLO 系列、SSD、RetinaNet
// 3.4 Anchor-Free 检测器：FCOS、CenterNet、DETR
// 3.5 检测优化：FPN、PANet、BiFPN
= 目标检测

// Chapter 4：图像分割 🔶
// 4.1 语义分割：FCN、U-Net、DeepLab 系列
// 4.2 实例分割：Mask R-CNN、SOLO、YOLACT
// 4.3 全景分割：Panoptic FPN
// 4.4 分割评估：IoU、Dice Coefficient、Pixel Accuracy
= 图像分割

// Chapter 5：图卷积网络（GCN）🔶
// 5.1 图数据基础：图结构表示、邻接矩阵、度矩阵、拉普拉斯矩阵
// 5.2 图卷积原理：谱图卷积（ChebNet、GCN）vs 空间图卷积（消息传递范式）
// 5.3 经典 GCN 模型：GCN、GraphSAGE、GAT（图注意力网络）
// 5.4 点云处理：PointNet、PointNet++、DGCNN
// 5.5 场景图生成：目标关系推理、Visual Genome 数据集
// 5.6 图结构在视觉推理中的应用：视觉问答、关系检测
= 图卷积网络（GCN）

// Chapter 6：生成模型与视觉生成 ⚪
// 6.1 自编码器与 VAE：编码-解码、重参数化技巧、KL 散度
// 6.2 生成对抗网络：GAN 训练技巧、DCGAN、StyleGAN、CycleGAN
// 6.3 扩散模型：前向过程、反向过程、DDPM、Stable Diffusion
// 6.4 图像超分辨率：SRCNN、ESRGAN、Real-ESRGAN
// 6.5 视觉生成评估：Inception Score（IS）、FID、CLIP Score
= 生成模型与视觉生成

// Chapter 7：视频理解 ⚪
// 7.1 视频分类：3D CNN、Two-Stream Network、SlowFast
// 7.2 动作检测：时空定位、Tubelet 检测
// 7.3 视频目标跟踪：Siamese Network、Transformer Tracker
// 7.4 视频生成：Video GAN、Diffusion Video
= 视频理解

// ─────────────────────────────────────────────────────────────────────
// Part 5：自然语言处理（NLP）
// ─────────────────────────────────────────────────────────────────────
#part("自然语言处理")

// Chapter 1：NLP 基础 🔶
// 1.1 文本预处理：分词、去停用词、词干提取、词形还原
// 1.2 词表示：One-Hot、TF-IDF、Word2Vec、GloVe、FastText
// 1.3 语言模型：N-Gram、神经语言模型、 perplexity
// 1.4 文本分类：情感分析、主题分类、意图识别
= NLP 基础

// Chapter 2：序列到序列模型 🔶
// 2.1 Encoder-Decoder 架构：编码、解码、注意力机制
// 2.2 注意力机制（Attention）：Scaled Dot-Product、Multi-Head
// 2.3 机器翻译：BLEU 评分、束搜索（Beam Search）
// 2.4 文本摘要：抽取式摘要、生成式摘要、ROUGE 评分
= 序列到序列模型

// Chapter 3：Transformer 架构 🔶
// 3.1 Transformer 详解：Self-Attention、Positional Encoding、FFN
// 3.2 BERT：预训练任务（MLM、NSP）、微调策略
// 3.3 GPT 系列：自回归语言模型、提示工程、In-Context Learning
// 3.4 T5：Text-to-Text 框架、统一 NLP 任务
// 3.5 高效 Transformer：Linformer、Performer、Reformer
= Transformer 架构

// Chapter 4：大语言模型（LLM）🔶
// 4.1 LLM 概述：规模定律、涌现能力、指令跟随
// 4.2 预训练语料：Common Crawl、The Pile、清洗与去重
// 4.3 对齐技术：SFT（监督微调）、RLHF、DPO
// 4.4 提示工程：Zero-Shot、Few-Shot、Chain-of-Thought
// 4.5 LLM 应用：问答系统、代码生成、Agent、RAG
= 大语言模型

// Chapter 5：信息抽取与知识图谱 ⚪
// 5.1 命名实体识别（NER）：BiLSTM-CRF、BERT-NER
// 5.2 关系抽取：远程监督、联合抽取、Graph Neural Network
// 5.3 知识图谱构建：实体链接、关系补全、知识融合
// 5.4 知识图谱应用：问答、推荐、推理
= 信息抽取与知识图谱


// ─────────────────────────────────────────────────────────────────────
// Part 6：强化学习
// ─────────────────────────────────────────────────────────────────────
#part("强化学习")

// Chapter 1：强化学习基础 🔶
// 1.1 RL 基本概念：Agent、Environment、State、Action、Reward
// 1.2 MDP 马尔可夫决策过程：状态转移、奖励函数、折扣因子
// 1.3 价值函数：状态价值 V(s)、动作价值 Q(s,a)
// 1.4 探索与利用：ε-greedy、UCB、Thompson Sampling
= 强化学习基础

// Chapter 2：表格方法 🔶
// 2.1 动态规划：策略迭代、价值迭代、贝尔曼方程
// 2.2 Monte Carlo 方法：首次访问、每次访问、重要性采样
// 2.3 Temporal Difference（TD）：TD(0)、Sarsa、Q-Learning
// 2.4 n-step TD：n-step Sarsa、n-step Q-Learning
= 表格方法

// Chapter 3：深度强化学习 🔶
// 3.1 DQN：经验回放、目标网络、Double DQN、Dueling DQN
// 3.2 Policy Gradient：REINFORCE、Actor-Critic、A2C
// 3.3 PPO： clipped surrogate objective、信任区域
// 3.4 SAC：最大熵 RL、软 Q-Learning、自动温度调节
// 3.5 DDPG/TD3：连续动作空间、确定性策略梯度
= 深度强化学习

// Chapter 4：高级强化学习 ⚪
// 4.1 Model-Based RL：世界模型、规划、MuZero
// 4.2 多智能体 RL：合作、竞争、MARL 算法
// 4.3 模仿学习：行为克隆、逆强化学习、GAIL
// 4.4 Meta-RL：元学习、快速适应、MAML
// 4.5 RL 应用：游戏 AI（AlphaGo、OpenAI Five）、机器人控制
= 高级强化学习


// ─────────────────────────────────────────────────────────────────────
// Part 7：AI 工程化与部署
// ─────────────────────────────────────────────────────────────────────
#part("AI 工程化与部署")

// Chapter 1：模型训练工程化 🔶
// 1.1 分布式训练：数据并行、模型并行、ZeRO
// 1.2 混合精度训练：FP16、BF16、AMP、损失缩放
// 1.3 实验管理：MLflow、Weights & Biases、TensorBoard
// 1.4 超参数优化：网格搜索、随机搜索、贝叶斯优化、Optuna
= 模型训练工程化

// Chapter 2：模型部署 🔶
// 2.1 模型导出：ONNX、TorchScript、SavedModel
// 2.2 推理引擎：TensorRT、OpenVINO、ONNX Runtime
// 2.3 服务化部署：Flask/FastAPI、TorchServe、Triton Inference Server
// 2.4 边缘部署：TensorFlow Lite、Core ML、NCNN、MNN
// 2.5 模型监控：延迟、吞吐量、错误率、漂移检测
= 模型部署

// Chapter 3：MLOps ⚪
// 3.1 数据版本控制：DVC、LakeFS
// 3.2 持续集成/持续部署：GitHub Actions、Jenkins、Kubeflow
// 3.3 实验追踪与注册：MLflow、Weights & Biases、Model Registry
// 3.4 模型压缩：量化、剪枝、知识蒸馏
// 3.5 模型治理：合规性、审计、可解释性、公平性与偏见
= MLOps

// Chapter 4：云计算与 AI 平台 ⚪
// 4.1 GPU 云计算：AWS EC2、Azure VM、GCP Compute Engine
// 4.2 AI 平台：SageMaker、Vertex AI、Azure ML
// 4.3 容器化：Docker、Kubernetes、GPU 资源调度
// 4.4 无服务器推理：AWS Lambda、Cloud Functions
= 云计算与 AI 平台


// ─────────────────────────────────────────────────────────────────────
// Part 8：AI 治理与安全
// ─────────────────────────────────────────────────────────────────────
#part("AI 治理与安全")

// Chapter 1：可解释 AI 🔶
// 1.1 可解释性的重要性：黑盒问题、信任、监管
// 1.2 事后解释方法：LIME、SHAP、Grad-CAM、Integrated Gradients
// 1.3 内在可解释模型：决策树、规则列表、注意力可视化
= 可解释 AI

// Chapter 2：公平性与偏见 ⚪
// 2.1 群体公平与个体公平：统计均等、机会均等、反事实公平
// 2.2 偏见来源：数据偏见、算法偏见、部署偏见
// 2.3 去偏见技术：数据重采样、公平约束、对抗去偏
= 公平性与偏见

// Chapter 3：AI 安全 🔶
// 3.1 对抗样本：FGSM、PGD、对抗训练
// 3.2 数据投毒与后门攻击：脏标签、触发器
// 3.3 模型窃取与隐私：模型反转、成员推理、差分隐私
// 3.4 红队测试与安全评估：自动化红队、对抗性评估
= AI 安全

// Chapter 4：AI 对齐 ⚪
// 4.1 对齐问题概述：外延对齐与内涵对齐
// 4.2 RLHF 与 DPO：基于人类反馈的强化学习、直接偏好优化
// 4.3 宪法 AI：原则驱动的自我训练
// 4.4 可扩展监督：弱到强泛化、递归奖励建模
= AI 对齐


// ─────────────────────────────────────────────────────────────────────
// Part 9：Agent 理论与 AI 编程实践
// ─────────────────────────────────────────────────────────────────────
#part("Agent 理论与 AI 编程实践")

// Chapter 1：AI 编程工具概述 ⚪
// 1.1 Claude Code：Anthropic 的 AI 编程助手，原生支持 Agent-Skill 标准
// 1.2 Trae IDE：国产 AI 原生 IDE，规则系统与 MCP 集成
// 1.3 Kiro：AWS AI IDE，Spec 驱动开发与三阶段工作流
// 1.4 Cursor IDE：AI 代码编辑器，MDC 规则与链式 Agent 调用
// 1.5 GitHub Copilot：代码补全与生成，仓库级指令支持
= AI 编程工具概述

// Chapter 2：Agent-Skill 开放标准（行业事实标准）🔶
// 2.1 核心术语定义：Skill（最小可复用能力单元）、Agent（调度单元）、Command（用户入口）
// 2.2 目录结构标准：全局目录 ~/.anthropic/、项目目录 .claude/.trae/.kiro.claude/
// 2.3 SKILL.md 规范：YAML 元数据（name、description、version、tags）+ Markdown 正文
// 2.4 AGENTS.md 智能体调度标准：技能绑定、规划策略、约束规则
// 2.5 渐进式披露机制：Discovery → Activation → Execution 分层加载
// 2.6 作用域分层：全局级、项目级、文件级
= Agent-Skill 开放标准

// Chapter 3：MCP（Model Context Protocol）工具调用标准 🔶
// 3.1 MCP 定位：Agent 与本地工具的统一接口（USB-C 级通用协议）
// 3.2 三大核心能力：Tools（可执行操作）、Resources（读取文件）、Prompts（模板）
// 3.3 协议架构：JSON-RPC 2.0、客户端-主机-服务器模式
// 3.4 安全机制：最小权限原则、工具白名单、用户授权流程
// 3.5 各工具实现：.trae/mcp.json、Claude Code MCP 配置
= MCP（Model Context Protocol）工具调用标准

// Chapter 4：A2A（Agent-to-Agent）通信标准 ⚪
// 4.1 A2A 定位：Agent 间跨工具/跨平台通信协议
// 4.2 核心概念：AgentCard、消息格式、RPC 方法
// 4.3 应用场景：多智能体分工协作、任务委托、工件传递
// 4.4 多智能体模式：前端 Agent + 后端 Agent + 测试 Agent 协作
= A2A（Agent-to-Agent）通信标准

// Chapter 5：Rules 与 Spec 工作流标准 ⚪
// 5.1 Rules 标准：长期静态约束（编码规范、框架偏好）
// 5.2 加载模式：always（全局加载）、filematch（文件匹配）、manual（手动调用）
// 5.3 Spec 工作流（Kiro）：requirements.md → design.md → tasks.md 三段式
// 5.4 各工具规则实现对比：Trae 的 rules 嵌套、Cursor 的 MDC 格式
= Rules 与 Spec 工作流标准

// Chapter 6：Skill 开发实践 🔶
// 6.1 Skill 目录结构：SKILL.md、scripts/、references/、assets/
// 6.2 SKILL.md 设计原则：元数据精准化、指令分层、Token 优化
// 6.3 本地测试 Skill 设计：Maven 打包 → JAR 启动 → cURL 测试 → 进程清理
// 6.4 脚本封装：确定性任务 vs AI 生成任务、Shell/Python 脚本集成
// 6.5 技能分发：团队共享、版本控制、社区模板复用
