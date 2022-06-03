# ihelper

效率工具；辅助记忆；快速输入；

![screenshot](https://github.com/fumeboy/ihelper/blob/main/README/3.png)

![screenshot](https://github.com/fumeboy/ihelper/blob/main/README/1.png)

![screenshot](https://github.com/fumeboy/ihelper/blob/main/README/2.png)

## 功能简介

用户可以自定义字典在 CSV 文件 `~/.ihelper.csv`；字典行记录 .tag、.desc、.output、.output-type 四项

启用 ihelper 输入法，输入能匹配 .tag 的文本查找出匹配的字典行；使用方向键选择要输出一项；敲回车键输出 output 文本或执行对应的 hotkey

## 场景举例

比如因为我不熟悉 vim 的操作，于是配置了 `vim;cursor;,光标移动到非空格符的下一行,+,` 这一行到字典文件

使用时，首先启用输入法并输入 `v` 匹配到 .tag `vim`, 然后选择该行并回车，输入法将输出 .output `+`, vim 窗口接收到 `+`, 执行 “光标移动到非空格符的下一行”

## 使用细节

### 初始化

1. 编译得到的 app 文件放置在 `/Library/Input Methods` 目录

2. 字典文件放置在 `~/.ihelper.csv` （第一次使用可以复制本仓库的 `.ihelper.csv`）

3. 在系统设置中启用输入法；*需要注意，系统需要重启（或注销重新登陆）才会加载新输入法*

### 字典格式

每一行为一个字典项，按顺序依次是 tag、desc、output、output-type 四列；

#### tag

tag 作为索引项使用，允许多值，按照符号 ; 分割

#### desc

描述该字典行的 text 或 hotkey；无格式要求

#### output

当 output-type == 1 时，输出 output 原文本

当 output-type == 2 时，`ctrl+C` 这样的 hotkey 会被执行

hotkey 格式为 `<with>+<key>` 或 `<key>`

其中 `<with>` 的内容可以是：`[shift,ctrl,control,command,cmd,option]` 中的一项

其中 `key` 的内容格式请见源文件 `AnInputController.swift` 中的 `keycode`

### 按键功能

ascii(32~126) 对应的按键输入字符

`space`、`tab`、`enter` 确认输入并输出

`esc` 清空输入、切换输入模式

`del` 删除末尾字符

`arrow up`、`arrow down` 选择输出项

`arrow left`、 `arrow right` 切页

### 输入模式

输入模式分为 normal mode 和 banning mode

normal mode 下输入文本索引 origin，会进行字典查询；也可以直接输出 origin

banning mode 下输入纯文本，输入法不进行响应；目的是省略切换英文输入法

*需要注意，在 normal node 下直接输出 origin 时，会自动切换到 banning mode*

### 控制模式

连续按两次 `esc` 进入控制模式。控制模式下：

按 `w` 键打开 `~/.ihelper.csv` 编辑窗口

按 `s` 键读取 `~/.ihelper.csv`

## 常见问题

1. 切换到该输入法但是输入无响应 -> 到 Input Methods 文件夹手动启动 app，应该会弹出系统报错信息；一般是系统版本不匹配
2. 系统设置里找不到或者无法切换到该输入法 -> 可能是没有注销重新登录，系统未加载该输入法
3. 怎么判断系统有无加载输入法 -> 查看是否有 ihelper 进程，如果有就是已经加载
4. hotkey 不生效 -> 输出 hotkey 时，系统会告诉你需要在 “安全性与隐私-辅助功能” 里为 ihelper 添加权限；如果重新安装了输入法，需要删除原权限，注销重新登录后再添加权限
5. 字典行未加载 -> 检查格式是否正确，特殊符号需要满足 csv 转义规则 






