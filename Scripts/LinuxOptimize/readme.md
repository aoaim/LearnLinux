整合自互聯網的 Linux 内核優化方案。參數部分主要參考自 Vultr HighFrequency 系列服務器的預設值。

Usage:

溫和版：應大佬建議，設置溫和版，僅更新源而不更新系統組件，比較適合生產環境服務器。

```bash
wget --no-check-certificate -O optimize_mild.sh https://raw.githubusercontent.com/aoaim/LearnLinux/master/Scripts/LinuxOptimize/optimize_mild && bash optimize_mild.sh
```

激進版：梭哈！梭哈！
```bash
wget --no-check-certificate -O optimize_aggressive.sh https://raw.githubusercontent.com/aoaim/LearnLinux/master/Scripts/LinuxOptimize/optimize_aggressive.sh && bash optimize_aggressive.sh
```