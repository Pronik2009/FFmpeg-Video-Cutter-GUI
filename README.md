# FFmpeg Video Cutter GUI (PowerShell)

This is a lightweight, no-installation-needed GUI utility for trimming videos using `ffmpeg`.  
It was built entirely with PowerShell and Windows Forms, and works via right-click context menu on `.mp4`, `.mkv`, `.webm`, and `.avi` files.

---

## ✨ Features

- Trims video using `ffmpeg` without re-encoding (`-c copy`)
- GUI form for setting start and end times
- Optional overwrite of original file
- Automatically fetches video duration via `ffprobe`
- Integrates into Windows Explorer context menu
- No dependencies beyond ffmpeg and ffprobe in PATH

![image](https://github.com/user-attachments/assets/b8cb2e55-ea2b-4d2c-8246-3c20ef66b8f0)

---

## 📦 Files

- [`ffmpeg_gui_cutter.ps1`](ffmpeg_gui_cutter.ps1) — main PowerShell GUI script
- [`add_ffmpeg_context.reg`](add_ffmpeg_context.reg) — Windows context menu integration

---

## 🛠 Requirements

- Windows 10 or 11
- `ffmpeg.exe` and `ffprobe.exe` in your system PATH

---

## 🧰 Installation
Simple: download and run [`FFmpeg_Video_Cutter_GUI_setup.exe`](FFmpeg_Video_Cutter_GUI_setup.exe)

Manual:
1. Copy [`ffmpeg_gui_cutter.ps1`](ffmpeg_gui_cutter.ps1) to:

   ```
   C:\Scripts\ffmpeg_gui_cutter.ps1
   ```

2. Double-click to apply [`add_ffmpeg_context.reg`](add_ffmpeg_context.reg)

3. Right-click any `.mp4`, `.mkv`, `.webm`, or `.avi` file and select:

   ```
   Trim video (FFmpeg GUI)
   ```

4. Set time range and click Trim

---

## 🤖 Created with Help From

This tool was designed by the author, with iterative improvements made with assistance from ChatGPT (OpenAI).

---

## 📜 License

This project is licensed under the **Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)**.  
See the [LICENSE](LICENSE) file or visit [creativecommons.org/licenses/by-nc/4.0](https://creativecommons.org/licenses/by-nc/4.0/) for full terms.
