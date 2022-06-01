# ihelper

效率工具；用于辅助记忆命令、快捷键等信息

![screenshot](https://github.com/fumeboy/ihelper/blob/main/README/1.png)

## 功能简介

用户可以自定义字典在 CSV 文件 `~/.ihelper.csv`；字典行记录 .tag、.desc、.text、.hotkey 四项

启用 ihelper 输入法，输入能匹配 .tag 的文本查找出匹配的字典行；使用方向键选择要输出一项；敲回车键输出选中的字典行的 .text 或执行 .hotkey

## 场景举例

比如因为我不熟悉 vim 的操作，于是配置了 `vim;cursor;,光标移动到非空格符的下一行,+,` 这一行到字典文件

使用时，首先启用输入法并输入 `v` 匹配到 .tag `vim`, 然后选择该行并回车，输入法将输出 .text `+`, vim 窗口接收到 `+`, 执行 “光标移动到非空格符的下一行”

## 使用细节

### 初始化

1. 编译得到的 app 文件放置在 `/Library/Input Methods` 目录

2. 字典文件放置在 `~/.ihelper.csv` （第一次使用可以复制本仓库的 `.ihelper.csv`）

*需要注意，系统需要重启（或注销重新登陆）才会加载新输入法*

### 字典格式

每一行为一个字典项，按顺序依次是 tag、desc、text、hotkey 四列；

#### tag

tag 允许多值，按照符号 ; 分割

#### desc

描述该字典行的 text 或 hotkey；无格式要求

#### text

要输出的文本；当有 hotkey 时，text 列的值被忽略

#### hotkey

输出时，`ctrl+C` 这样的 hotkey 会被执行

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




