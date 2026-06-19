# MATLAB 公共函数说明

本目录存放第三部分“算法设计与仿真验证”中两个仿真实验共用的 MATLAB 函数。公共函数不单独运行，主要由以下两个实验脚本调用：

- `../task1_fuzzy_control/run_task1_fuzzy_control.m`
- `../task2_bp_nn_pid/run_task2_bp_nn_pid.m`

仿真对象为：

```matlab
G(s) = 10 / (s^2 + 5s + 10)
```

## 函数分类

### 1. 被控对象与基础仿真

- `rk4Plant.m`：使用四阶 Runge-Kutta 方法更新二阶被控对象状态。
- `simulateOpenLoop.m`：计算被控对象的开环阶跃响应。

### 2. 控制器仿真

- `simulatePID.m`：固定参数 PID 控制器仿真。
- `simulateFuzzyPid.m`：二维模糊 PID 控制器仿真，输入为误差 `e` 和误差变化率 `ec`。
- `simulateBPAdaptivePID.m`：BP 神经网络自适应 PID 控制器仿真，在线输出 `Kp`、`Ki`、`Kd`。

### 3. 模糊控制相关函数

- `fuzzifyVariable.m`：计算输入变量在各语言变量上的隶属度。
- `fuzzyInference.m`：根据模糊规则表完成推理并输出模糊补偿量。
- `saveFuzzyRuleTable.m`：保存模糊规则表，便于报告引用。
- `saveMembershipFigure.m`：绘制并保存隶属函数图。

### 4. 结果保存与性能指标

- `stepMetrics.m`：计算稳态误差、超调量、上升时间、2% 调节时间、IAE 和 ITAE。
- `metricsRow.m`：将性能指标整理为表格行。
- `saveSeries.m`：保存仿真时间序列数据。
- `saveFigure.m`：保存仿真曲线图。

### 5. 工具函数

- `limitValue.m`：对单个数值进行上下限幅。
- `limitVector.m`：对向量进行上下限幅。

## 使用方式

在实验脚本中加入公共函数路径后即可调用：

```matlab
matlabDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(matlabDir, 'common'));
```

也可以直接运行总入口：

```matlab
run('../run_all_simulations.m')
```

运行后，任务一和任务二的仿真结果会分别保存到：

- `../../results/task1_fuzzy_control`
- `../../results/task2_bp_nn_pid`

## 说明

本目录只包含可复用的公共函数。两个具体实验的参数设置、控制器调用流程、图表输出逻辑分别保存在任务一和任务二的主程序中。
