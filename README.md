# ImmortalWrt GitHub Actions 编译仓库

这个仓库用于通过 GitHub Actions 自动编译 ImmortalWrt，并支持：

- 默认编译 `openwrt-24.10` 分支
- 使用仓库根目录的 `.config`
- 在 feeds 更新前执行 `diy-part1.sh`
- 在 feeds 安装后执行 `diy-part2.sh`
- 增加第三方软件源：
  - `kenzo`
  - `small`
  - `helloworld`
- 将默认 LuCI 主题切换为 `argon`
- 上传固件产物
- 在编译前预下载固定第三方 `ipk`
- 支持通过 `ipk_urls` 继续追加额外第三方 `ipk`

## 仓库结构

- `.github/workflows/build.yml`：GitHub Actions 编译流程
- `diy-part1.sh`：feeds 更新前执行，适合加 feeds、补充源码或额外 package
- `diy-part2.sh`：feeds 安装后执行，适合改默认配置、主题，以及预下载 `ipk`
- `.config`：你的本地编译配置文件，需要放在仓库根目录

## 使用方法

1. 把你本地生成好的 `.config` 放到仓库根目录，建议这份配置基于 `openwrt-24.10` 生成。
2. 将仓库推送到 GitHub。
3. 在 GitHub 的 `Actions` 页面手动运行 `Build ImmortalWrt`，默认编译 `openwrt-24.10`。
4. 固件默认后台地址为 `http://192.168.1.1` 或 `http://immortalwrt.lan`，默认用户名为 `root`，默认密码为空。
5. 工作流会默认在编译前下载以下 `ipk`：
   - `luci-app-natfrp_amd64.ipk`
   - `uuplugin_latest-1_x86_64.ipk`
6. 如需继续追加其他第三方 `ipk`，可在手动触发时填写 `ipk_urls`。

`ipk_urls` 支持以下分隔方式：

- 空格
- 英文逗号
- 换行

这个工作流仅支持手动触发，不会在 `push` 后自动执行。

## 产物说明

工作流只会上传 1 类产物：

- `firmware-*`：编译后的固件与 target 目录产物

## 自定义说明

- 如果还需要在 feeds 更新前 `git clone` 额外 package，可以直接编辑 `diy-part1.sh`
- 如果还需要改默认 IP、主机名、主题或追加更多固定 `ipk`，可以直接编辑 `diy-part2.sh`
