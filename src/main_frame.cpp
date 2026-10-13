#include "main_frame.h"

#include <afxdlgs.h>

#include <algorithm>
#include <chrono>
#include <cstdio>
#include <cwchar>
#include <fstream>
#include <iterator>
#include <sstream>
#include <thread>
#include <vector>

#include "resource.h"
#include "build_info.generated.h"

namespace {
constexpr UINT_PTR kConnectPollTimerId = 1;
constexpr UINT kConnectPollIntervalMs = 2000;
constexpr DWORD kConnectPollLogIntervalMs = 2000;
constexpr UINT_PTR kProgramElapsedTimerId = 2;
constexpr UINT kProgramElapsedTimerIntervalMs = 100;
constexpr UINT kLogTextLimit = 8u * 1024u * 1024u;
constexpr const wchar_t* kIniSectionUi = L"ui";

std::wstring NowTimeText() {
    SYSTEMTIME st = {};
    GetLocalTime(&st);

    wchar_t buf[32] = {};
    swprintf_s(buf, L"%02u:%02u:%02u", st.wHour, st.wMinute, st.wSecond);
    return std::wstring(buf);
}

std::wstring NowFileTimeText() {
    SYSTEMTIME st = {};
    GetLocalTime(&st);

    wchar_t buf[48] = {};
    swprintf_s(buf, L"%04u%02u%02u_%02u%02u%02u",
               st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond);
    return std::wstring(buf);
}

std::string WideToUtf8(const std::wstring& ws) {
    if (ws.empty()) {
        return {};
    }
    const int bytes = WideCharToMultiByte(CP_UTF8, 0, ws.c_str(), -1, nullptr, 0, nullptr, nullptr);
    if (bytes <= 1) {
        return {};
    }
    std::string out(static_cast<std::size_t>(bytes - 1), '\0');
    WideCharToMultiByte(CP_UTF8, 0, ws.c_str(), -1, out.data(), bytes - 1, nullptr, nullptr);
    return out;
}

} // namespace

BEGIN_MESSAGE_MAP(CMainFrame, CFrameWnd)
    ON_WM_CREATE()
    ON_WM_SIZE()
    ON_BN_CLICKED(ID_TOP_REFRESH_COM_BTN, &CMainFrame::OnBnClickedRefreshCom)
    ON_BN_CLICKED(ID_TOP_OPEN_COM_BTN, &CMainFrame::OnBnClickedOpenCom)
    ON_BN_CLICKED(ID_TOP_CLOSE_COM_BTN, &CMainFrame::OnBnClickedCloseCom)
    ON_BN_CLICKED(ID_FILE_LOAD_BTN, &CMainFrame::OnBnClickedLoadBinary)
    ON_BN_CLICKED(ID_FLOW_ENTER_BOOT_BTN, &CMainFrame::OnBnClickedEnterBootloader)
    ON_BN_CLICKED(ID_FLOW_PROGRAM_BTN, &CMainFrame::OnBnClickedProgram)
    ON_BN_CLICKED(ID_FLOW_RUN_BTN, &CMainFrame::OnBnClickedRun)
    ON_BN_CLICKED(ID_LOG_CLEAR_BTN, &CMainFrame::OnBnClickedClearLog)
    ON_BN_CLICKED(ID_LOG_START_BTN, &CMainFrame::OnBnClickedStartLog)
    ON_BN_CLICKED(ID_LOG_STOP_BTN, &CMainFrame::OnBnClickedStopLog)
    ON_BN_CLICKED(ID_LOG_ADDR_DATA_CHK, &CMainFrame::OnBnClickedLogAddrData)
    ON_BN_CLICKED(ID_LOG_CAN_TXRX_CHK, &CMainFrame::OnBnClickedLogCanTxRx)
    ON_CBN_SELCHANGE(ID_TOP_COM_COMBO, &CMainFrame::OnCbnSelChangeCom)
    ON_CBN_SELCHANGE(ID_TOP_BAUD_COMBO, &CMainFrame::OnCbnSelChangeBaud)
    ON_CBN_SELCHANGE(ID_CAN_BITRATE_COMBO, &CMainFrame::OnCbnSelChangeCanBitrate)
    ON_CBN_SELCHANGE(ID_PREFETCH_COMBO, &CMainFrame::OnCbnSelChangePrefetch)
    ON_WM_TIMER()
    ON_WM_CLOSE()
END_MESSAGE_MAP()

CMainFrame::CMainFrame() {
    bridge_client_.SetPort(&serial_port_);
}

CMainFrame::~CMainFrame() {
    StopLogRecording(false);
    CloseCom();
}

BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs) {
    if (!CFrameWnd::PreCreateWindow(cs)) {
        return FALSE;
    }
    HICON hIcon = AfxGetApp()->LoadIcon(IDI_APP_ICON);
    cs.style |= WS_CLIPCHILDREN | WS_CLIPSIBLINGS;
    cs.lpszClass = AfxRegisterWndClass(
        CS_HREDRAW | CS_VREDRAW,
        ::LoadCursor(nullptr, IDC_ARROW),
        reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1),
        hIcon);
    return TRUE;
}

int CMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct) {
    if (CFrameWnd::OnCreate(lpCreateStruct) == -1) {
        return -1;
    }

    HICON hIcon = AfxGetApp()->LoadIcon(IDI_APP_ICON);
    SetIcon(hIcon, TRUE);
    SetIcon(hIcon, FALSE);

    ui_font_.CreatePointFont(90, L"Segoe UI");

    auto create_or_fail = [this](BOOL ok, const wchar_t* name) -> bool {
        if (!ok) {
            AppendLog(std::wstring(L"Create control failed: ") + name);
            return false;
        }
        return true;
    };

    if (!create_or_fail(com_label_.Create(L"COM", WS_CHILD | WS_VISIBLE, CRect(0, 0, 0, 0), this, ID_TOP_COM_LABEL), L"COM label")) return -1;
    if (!create_or_fail(com_combo_.Create(WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_VSCROLL | CBS_DROPDOWNLIST, CRect(0, 0, 0, 0), this, ID_TOP_COM_COMBO), L"COM combo")) return -1;
    if (!create_or_fail(baud_label_.Create(L"Baud", WS_CHILD | WS_VISIBLE, CRect(0, 0, 0, 0), this, ID_TOP_BAUD_LABEL), L"Baud label")) return -1;
    if (!create_or_fail(baud_combo_.Create(WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_VSCROLL | CBS_DROPDOWNLIST, CRect(0, 0, 0, 0), this, ID_TOP_BAUD_COMBO), L"Baud combo")) return -1;
    if (!create_or_fail(refresh_com_btn_.Create(L"Refresh", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_TOP_REFRESH_COM_BTN), L"Refresh button")) return -1;
    if (!create_or_fail(open_com_btn_.Create(L"Open COM", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_TOP_OPEN_COM_BTN), L"Open COM button")) return -1;
    if (!create_or_fail(close_com_btn_.Create(L"Close COM", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_TOP_CLOSE_COM_BTN), L"Close COM button")) return -1;

    if (!create_or_fail(load_binary_btn_.Create(L"Load Binary", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_FILE_LOAD_BTN), L"Load binary button")) return -1;
    if (!create_or_fail(file_path_label_.Create(L"File: (none)", WS_CHILD | WS_VISIBLE | SS_PATHELLIPSIS, CRect(0, 0, 0, 0), this, ID_FILE_PATH_LABEL), L"File path label")) return -1;

    if (!create_or_fail(can_bitrate_label_.Create(L"CAN Bitrate", WS_CHILD | WS_VISIBLE, CRect(0, 0, 0, 0), this, ID_CAN_BITRATE_LABEL), L"CAN bitrate label")) return -1;
    if (!create_or_fail(can_bitrate_combo_.Create(WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_VSCROLL | CBS_DROPDOWNLIST, CRect(0, 0, 0, 0), this, ID_CAN_BITRATE_COMBO), L"CAN bitrate combo")) return -1;
    if (!create_or_fail(prefetch_label_.Create(L"Prefetch", WS_CHILD | WS_VISIBLE, CRect(0, 0, 0, 0), this, ID_PREFETCH_LABEL), L"Prefetch label")) return -1;
    if (!create_or_fail(prefetch_combo_.Create(WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_VSCROLL | CBS_DROPDOWNLIST, CRect(0, 0, 0, 0), this, ID_PREFETCH_COMBO), L"Prefetch combo")) return -1;

    if (!create_or_fail(enter_bootloader_btn_.Create(L"Connect", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_FLOW_ENTER_BOOT_BTN), L"Connect button")) return -1;
    if (!create_or_fail(program_btn_.Create(L"Program", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_FLOW_PROGRAM_BTN), L"Program button")) return -1;
    if (!create_or_fail(run_btn_.Create(L"Disconnect", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_FLOW_RUN_BTN), L"Disconnect button")) return -1;
    if (!create_or_fail(program_timer_label_.Create(L"Elapsed: 00:00.0", WS_CHILD | WS_VISIBLE, CRect(0, 0, 0, 0), this, ID_PROGRAM_TIMER_LABEL), L"Program timer label")) return -1;

    if (!create_or_fail(progress_bar_.Create(WS_CHILD | WS_VISIBLE | PBS_SMOOTH, CRect(0, 0, 0, 0), this, ID_PROGRESS_BAR), L"Progress bar")) return -1;
    if (!create_or_fail(progress_label_.Create(L"Progress: 0%", WS_CHILD | WS_VISIBLE, CRect(0, 0, 0, 0), this, ID_PROGRESS_LABEL), L"Progress label")) return -1;
    if (!create_or_fail(build_info_label_.Create(L"", WS_CHILD | WS_VISIBLE | SS_RIGHT, CRect(0, 0, 0, 0), this, ID_BUILD_INFO_LABEL), L"Build info label")) return -1;

    if (!create_or_fail(log_edit_.Create(WS_CHILD | WS_VISIBLE | WS_BORDER | WS_VSCROLL | ES_MULTILINE | ES_AUTOVSCROLL | ES_READONLY,
                                         CRect(0, 0, 0, 0), this, ID_LOG_EDIT), L"Log edit")) return -1;
    if (!create_or_fail(clear_log_btn_.Create(L"Clear Log", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_LOG_CLEAR_BTN), L"Clear log button")) return -1;
    if (!create_or_fail(start_log_btn_.Create(L"Start Log", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_LOG_START_BTN), L"Start log button")) return -1;
    if (!create_or_fail(stop_log_btn_.Create(L"Stop Log", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, CRect(0, 0, 0, 0), this, ID_LOG_STOP_BTN), L"Stop log button")) return -1;
    if (!create_or_fail(log_addr_data_chk_.Create(L"Log Addr/Data", WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_AUTOCHECKBOX, CRect(0, 0, 0, 0), this, ID_LOG_ADDR_DATA_CHK), L"Log addr/data checkbox")) return -1;
    if (!create_or_fail(log_can_txrx_chk_.Create(L"Log CAN TX/RX", WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_AUTOCHECKBOX, CRect(0, 0, 0, 0), this, ID_LOG_CAN_TXRX_CHK), L"Log CAN TX/RX checkbox")) return -1;

    com_label_.SetFont(&ui_font_);
    com_combo_.SetFont(&ui_font_);
    baud_label_.SetFont(&ui_font_);
    baud_combo_.SetFont(&ui_font_);
    refresh_com_btn_.SetFont(&ui_font_);
    open_com_btn_.SetFont(&ui_font_);
    close_com_btn_.SetFont(&ui_font_);
    load_binary_btn_.SetFont(&ui_font_);
    file_path_label_.SetFont(&ui_font_);
    can_bitrate_label_.SetFont(&ui_font_);
    can_bitrate_combo_.SetFont(&ui_font_);
    prefetch_label_.SetFont(&ui_font_);
    prefetch_combo_.SetFont(&ui_font_);
    enter_bootloader_btn_.SetFont(&ui_font_);
    program_btn_.SetFont(&ui_font_);
    run_btn_.SetFont(&ui_font_);
    program_timer_label_.SetFont(&ui_font_);
    progress_label_.SetFont(&ui_font_);
    build_info_label_.SetFont(&ui_font_);
    log_edit_.SetFont(&ui_font_);
    clear_log_btn_.SetFont(&ui_font_);
    start_log_btn_.SetFont(&ui_font_);
    stop_log_btn_.SetFont(&ui_font_);
    log_addr_data_chk_.SetFont(&ui_font_);
    log_can_txrx_chk_.SetFont(&ui_font_);

    baud_combo_.AddString(L"115200");
    baud_combo_.AddString(L"460800");
    baud_combo_.AddString(L"921600");
    baud_combo_.SetCurSel(0);

    can_bitrate_combo_.AddString(L"125K");
    can_bitrate_combo_.AddString(L"250K");
    can_bitrate_combo_.AddString(L"500K");
    can_bitrate_combo_.AddString(L"800K");
    can_bitrate_combo_.AddString(L"1M");
    can_bitrate_combo_.SetCurSel(2);

    prefetch_combo_.AddString(L"2");
    prefetch_combo_.AddString(L"3");
    prefetch_combo_.AddString(L"4");
    prefetch_combo_.SetCurSel(0);

    progress_bar_.SetRange32(0, 100);
    progress_bar_.SetPos(0);
    log_edit_.SetLimitText(kLogTextLimit);
    build_info_label_.SetWindowTextW((std::wstring(L"Build ") + SERIAL_CAN_TOOL_VERSION + L"  " + SERIAL_CAN_TOOL_BUILD_TIME).c_str());

    InitializeSettingsFile();

    LoadUiSettings();
    log_addr_data_chk_.SetCheck(trace_expected_addr_data_ ? BST_CHECKED : BST_UNCHECKED);
    log_can_txrx_chk_.SetCheck(trace_can_tx_rx_ ? BST_CHECKED : BST_UNCHECKED);
    RefreshComPorts();
    UpdateConnectionUi();
    UpdateWorkflowUi();
    AppendLog(L"MFC UI initialized.");
    AppendLog(L"Protocol: SOF(55 AA) + Ver + Type + Seq + Cmd + Status + Len + HeaderCRC16 + Payload + PayloadCRC16");

    CRect rc;
    GetClientRect(&rc);
    LayoutControls(rc.Width(), rc.Height());

    return 0;
}

void CMainFrame::OnSize(UINT nType, int cx, int cy) {
    CFrameWnd::OnSize(nType, cx, cy);
    LayoutControls(cx, cy);
}

void CMainFrame::LayoutControls(int cx, int cy) {
    if (cx <= 0 || cy <= 0) {
        return;
    }

    const int margin = 8;
    const int gap = 6;
    const int row_h = 28;
    const int btn_w = 100;

    int y = margin;
    int x = margin;

    com_label_.MoveWindow(x, y + 4, 40, 20);
    x += 42;
    com_combo_.MoveWindow(x, y, 140, 200);
    x += 146;

    baud_label_.MoveWindow(x, y + 4, 44, 20);
    x += 46;
    baud_combo_.MoveWindow(x, y, 120, 200);
    x += 126;

    refresh_com_btn_.MoveWindow(x, y, btn_w, row_h);
    x += btn_w + gap;
    open_com_btn_.MoveWindow(x, y, btn_w, row_h);
    x += btn_w + gap;
    close_com_btn_.MoveWindow(x, y, btn_w, row_h);

    y += row_h + gap;
    x = margin;

    load_binary_btn_.MoveWindow(x, y, 120, row_h);
    x += 126;
    file_path_label_.MoveWindow(x, y + 4, cx - x - margin, 20);

    y += row_h + gap;
    x = margin;

    can_bitrate_label_.MoveWindow(x, y + 4, 80, 20);
    x += 82;
    can_bitrate_combo_.MoveWindow(x, y, 100, 200);
    x += 106;
    prefetch_label_.MoveWindow(x, y + 4, 58, 20);
    x += 60;
    prefetch_combo_.MoveWindow(x, y, 60, 150);
    {
        const int flow_btn_w = 120;
        int flow_x = x + 60 + gap + 8;

        enter_bootloader_btn_.MoveWindow(flow_x, y, flow_btn_w, row_h);
        flow_x += flow_btn_w + gap;
        program_btn_.MoveWindow(flow_x, y, flow_btn_w, row_h);
        flow_x += flow_btn_w + gap;
        run_btn_.MoveWindow(flow_x, y, flow_btn_w, row_h);
        flow_x += flow_btn_w + gap + 8;
        program_timer_label_.MoveWindow(flow_x, y + 4, 180, 20);
    }

    y += row_h + gap;
    progress_label_.MoveWindow(margin, y + 4, 210, 20);
    progress_bar_.MoveWindow(margin + 214, y, cx - margin - (margin + 214), row_h);
    build_info_label_.MoveWindow(cx - margin - 360, margin + 4, 360, 20);

    y += row_h + gap;
    clear_log_btn_.MoveWindow(margin, y, 100, row_h);
    start_log_btn_.MoveWindow(margin + 100 + gap, y, 100, row_h);
    stop_log_btn_.MoveWindow(margin + (100 + gap) * 2, y, 100, row_h);
    log_addr_data_chk_.MoveWindow(margin + (100 + gap) * 3 + 8, y + 4, 140, 22);
    log_can_txrx_chk_.MoveWindow(margin + (100 + gap) * 3 + 156, y + 4, 160, 22);

    y += row_h + gap;
    const int log_h = cy - y - margin;
    if (log_h > 0) {
        log_edit_.MoveWindow(margin, y, cx - margin * 2, log_h);
    }
}

void CMainFrame::AppendLog(const std::wstring& text) {
    const std::wstring line = L"[" + NowTimeText() + L"] " + text;
    int len = log_edit_.GetWindowTextLengthW();
    log_edit_.SetSel(len, len);
    std::wstring with_crlf = line + L"\r\n";
    log_edit_.ReplaceSel(with_crlf.c_str());

    if (log_recording_ && log_record_fp_ != nullptr) {
        const std::string utf8 = WideToUtf8(with_crlf);
        if (!utf8.empty()) {
            fwrite(utf8.data(), 1u, utf8.size(), log_record_fp_);
            fflush(log_record_fp_);
        }
    }
}

void CMainFrame::InitializeSettingsFile() {
    wchar_t module_path[MAX_PATH] = {};
    const DWORD len = GetModuleFileNameW(nullptr, module_path, MAX_PATH);
    std::wstring dir = L".";
    if (len > 0) {
        dir.assign(module_path, module_path + len);
        const std::size_t pos = dir.find_last_of(L"\\/");
        if (pos != std::wstring::npos) {
            dir.resize(pos);
        }
    }

    ini_path_ = dir + L"\\SerialToCanIspTool.ini";
    WritePrivateProfileStringW(kIniSectionUi, L"tool", L"Serial to CAN ISP tool", ini_path_.c_str());
}

std::wstring CMainFrame::ReadIniValue(const wchar_t* key, const wchar_t* fallback) const {
    wchar_t buffer[1024] = {};
    GetPrivateProfileStringW(kIniSectionUi, key, fallback, buffer, static_cast<DWORD>(std::size(buffer)), ini_path_.c_str());
    return std::wstring(buffer);
}

void CMainFrame::WriteIniValue(const wchar_t* key, const std::wstring& value) const {
    WritePrivateProfileStringW(kIniSectionUi, key, value.c_str(), ini_path_.c_str());
}

void CMainFrame::ApplyComboSelection(CComboBox& combo, const std::wstring& value) {
    if (value.empty()) {
        return;
    }
    const int idx = combo.FindStringExact(-1, value.c_str());
    if (idx >= 0) {
        combo.SetCurSel(idx);
    }
}

void CMainFrame::LoadUiSettings() {
    preferred_com_port_ = ReadIniValue(L"com_port", L"");
    ApplyComboSelection(baud_combo_, ReadIniValue(L"baud", L"115200"));
    ApplyComboSelection(can_bitrate_combo_, ReadIniValue(L"can_bitrate", L"500K"));
    ApplyComboSelection(prefetch_combo_, ReadIniValue(L"prefetch", L"4"));
    trace_expected_addr_data_ = (ReadIniValue(L"log_expected_addr_data", L"0") == L"1");
    trace_can_tx_rx_ = (ReadIniValue(L"log_can_tx_rx", L"0") == L"1");

    binary_path_ = ReadIniValue(L"binary_path", L"");
    if (!binary_path_.empty()) {
        if (!LoadBinaryFromPath(binary_path_, true)) {
            file_path_label_.SetWindowTextW((L"File: " + binary_path_ + L" (missing)").c_str());
            binary_data_.clear();
        }
    }

    AppendLog(std::wstring(L"Expected addr:data trace = ") + (trace_expected_addr_data_ ? L"ON" : L"OFF"));
    AppendLog(std::wstring(L"CAN TX/RX trace = ") + (trace_can_tx_rx_ ? L"ON" : L"OFF"));
}

void CMainFrame::SaveUiSettings() {
    WriteIniValue(L"com_port", SelectedComPort());
    WriteIniValue(L"baud", std::to_wstring(SelectedBaudrate()));
    WriteIniValue(L"can_bitrate", SelectedCanBitrate());
    WriteIniValue(L"prefetch", std::to_wstring(SelectedPrefetchWindow()));
    WriteIniValue(L"binary_path", binary_path_);
    WriteIniValue(L"log_expected_addr_data", trace_expected_addr_data_ ? L"1" : L"0");
    WriteIniValue(L"log_can_tx_rx", trace_can_tx_rx_ ? L"1" : L"0");
}

void CMainFrame::StartLogRecording() {
    if (log_recording_) {
        return;
    }
    if (ini_path_.empty()) {
        InitializeSettingsFile();
    }

    std::wstring dir = ini_path_;
    const std::size_t pos = dir.find_last_of(L"\\/");
    if (pos != std::wstring::npos) {
        dir.resize(pos);
    } else {
        dir = L".";
    }

    log_record_path_ = dir + L"\\serial_to_can_isp_" + NowFileTimeText() + L".log";

    FILE* fp = nullptr;
    if (_wfopen_s(&fp, log_record_path_.c_str(), L"wb") != 0 || fp == nullptr) {
        MessageBoxW(L"Failed to create log file.", L"Start Log", MB_ICONERROR | MB_OK);
        return;
    }

    const unsigned char bom[3] = {0xEFu, 0xBBu, 0xBFu};
    fwrite(bom, 1u, 3u, fp);

    log_record_fp_ = fp;
    log_recording_ = true;
    UpdateWorkflowUi();
    AppendLog(L"Log recording started: " + log_record_path_);
}

void CMainFrame::StopLogRecording(bool emit_log) {
    if (!log_recording_) {
        return;
    }

    const std::wstring path = log_record_path_;
    if (log_record_fp_ != nullptr) {
        fflush(log_record_fp_);
        fclose(log_record_fp_);
    }
    log_record_fp_ = nullptr;
    log_recording_ = false;
    log_record_path_.clear();
    UpdateWorkflowUi();

    if (emit_log) {
        AppendLog(L"Log recording stopped: " + path);
    }
}

void CMainFrame::RefreshComPorts() {
    std::wstring selected_before = SelectedComPort();
    com_combo_.ResetContent();

    for (int i = 1; i <= 256; ++i) {
        wchar_t name[16] = {};
        swprintf_s(name, L"COM%d", i);

        wchar_t target[256] = {};
        DWORD len = QueryDosDeviceW(name, target, static_cast<DWORD>(std::size(target)));
        if (len > 0) {
            com_combo_.AddString(name);
        }
    }

    if (com_combo_.GetCount() > 0) {
        std::wstring prefer = selected_before;
        if (prefer.empty()) {
            prefer = preferred_com_port_;
        }

        int idx = -1;
        if (!prefer.empty()) {
            idx = com_combo_.FindStringExact(-1, prefer.c_str());
        }
        if (idx < 0) {
            idx = 0;
        }
        com_combo_.SetCurSel(idx);
        preferred_com_port_.clear();
        SaveUiSettings();
        AppendLog(L"COM scan done.");
    } else {
        AppendLog(L"No COM ports found.");
    }
}

std::wstring CMainFrame::SelectedComPort() const {
    CString text;
    com_combo_.GetWindowTextW(text);
    return text.GetString();
}

DWORD CMainFrame::SelectedBaudrate() const {
    CString text;
    baud_combo_.GetWindowTextW(text);
    const std::wstring s = text.GetString();

    if (s == L"460800") {
        return 460800;
    }
    if (s == L"921600") {
        return 921600;
    }
    return 115200;
}

std::wstring CMainFrame::SelectedCanBitrate() const {
    CString text;
    can_bitrate_combo_.GetWindowTextW(text);
    return text.GetString();
}

std::uint32_t CMainFrame::SelectedPrefetchWindow() const {
    CString text;
    prefetch_combo_.GetWindowTextW(text);
    const std::wstring s = text.GetString();
    if (s == L"2") return 2;
    if (s == L"3") return 3;
    return 4;
}

bool CMainFrame::OpenSelectedCom() {
    if (IsComOpen()) {
        return true;
    }

    const std::wstring com = SelectedComPort();
    if (com.empty()) {
        AppendLog(L"Open COM failed: no COM selected.");
        return false;
    }

    std::wstring error;
    if (!serial_port_.Open(com, SelectedBaudrate(), &error)) {
        AppendLog(L"Open COM failed: " + com + L". " + error);
        return false;
    }

    opened_com_port_ = com;
    AppendLog(L"COM opened: " + com + L", baud=" + std::to_wstring(SelectedBaudrate()));
    return true;
}

void CMainFrame::CloseCom() {
    StopProgramElapsedTimer();
    StopTargetConnectPolling();
    target_connected_ = false;
    can_configured_ = false;
    b1_attempts_current_connect_ = 0;
    b1_attempts_last_connected_ = 0;

    if (serial_port_.IsOpen()) {
        serial_port_.Close();
        AppendLog(L"COM closed: " + opened_com_port_);
        opened_com_port_.clear();
    }
    UpdateConnectionUi();
    UpdateWorkflowUi();
}

bool CMainFrame::IsComOpen() const {
    return serial_port_.IsOpen();
}

void CMainFrame::UpdateConnectionUi() {
    const bool connected = IsComOpen();
    open_com_btn_.EnableWindow(!connected);
    close_com_btn_.EnableWindow(connected);
    refresh_com_btn_.EnableWindow(!connected);
    com_combo_.EnableWindow(!connected);
    baud_combo_.EnableWindow(!connected);
}

void CMainFrame::UpdateWorkflowUi() {
    const bool com_open = IsComOpen();
    const bool can_ready = com_open && can_configured_;
    const bool can_modify = com_open && !target_connect_polling_ && !target_connected_;
    const bool has_bin = !binary_data_.empty();
    const bool connected_or_polling = target_connected_ || target_connect_polling_;
    const bool busy = programming_in_progress_;

    can_bitrate_combo_.EnableWindow(!busy && can_modify);
    prefetch_combo_.EnableWindow(!busy && can_modify);
    load_binary_btn_.EnableWindow(!busy);
    log_addr_data_chk_.EnableWindow(!busy);
    log_can_txrx_chk_.EnableWindow(!busy);

    enter_bootloader_btn_.EnableWindow(!busy && com_open && !target_connected_ && !target_connect_polling_);
    run_btn_.EnableWindow(com_open && connected_or_polling);

    program_btn_.EnableWindow(!busy && can_ready && target_connected_ && has_bin);
    start_log_btn_.EnableWindow(!log_recording_);
    stop_log_btn_.EnableWindow(log_recording_);
}

void CMainFrame::SetProgress(int value, const std::wstring& label) {
    const int clamped = (std::max)(0, (std::min)(value, 100));
    progress_bar_.SetPos(clamped);
    progress_label_.SetWindowTextW((label + L" " + std::to_wstring(clamped) + L"%").c_str());
}

void CMainFrame::StartProgramElapsedTimer() {
    program_timer_start_ms_ = GetTickCount64();
    program_timer_running_ = true;
    SetTimer(kProgramElapsedTimerId, kProgramElapsedTimerIntervalMs, nullptr);
    UpdateProgramElapsedText();
}

void CMainFrame::StopProgramElapsedTimer() {
    if (!program_timer_running_) {
        return;
    }
    KillTimer(kProgramElapsedTimerId);
    program_timer_running_ = false;
    UpdateProgramElapsedText();
}

void CMainFrame::UpdateProgramElapsedText() {
    ULONGLONG elapsed_ms = 0;
    if (program_timer_running_) {
        elapsed_ms = GetTickCount64() - program_timer_start_ms_;
    }

    const ULONGLONG total_tenths = elapsed_ms / 100;
    const ULONGLONG tenths = total_tenths % 10;
    const ULONGLONG total_sec = total_tenths / 10;
    const ULONGLONG sec = total_sec % 60;
    const ULONGLONG min = total_sec / 60;

    wchar_t buf[64] = {};
    swprintf_s(buf, L"Elapsed: %02llu:%02llu.%01llu", min, sec, tenths);
    program_timer_label_.SetWindowTextW(buf);
}

bool CMainFrame::EnsurePreconditions(bool need_com, bool need_bin) {
    if (need_com && !IsComOpen()) {
        AppendLog(L"Action blocked: COM not opened.");
        return false;
    }
    if (need_bin && binary_data_.empty()) {
        AppendLog(L"Action blocked: binary not loaded.");
        return false;
    }
    return true;
}

void CMainFrame::PumpUiMessages() {
    MSG msg = {};
    while (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
}

void CMainFrame::OnBnClickedRefreshCom() {
    RefreshComPorts();
}

void CMainFrame::OnBnClickedOpenCom() {
    const bool ok = OpenSelectedCom();
    UpdateConnectionUi();
    UpdateWorkflowUi();
    if (ok) {
        SaveUiSettings();
    }
    if (!ok) {
        MessageBoxW(L"Failed to open selected COM port.", L"Open COM", MB_ICONERROR | MB_OK);
    }
}

void CMainFrame::OnBnClickedCloseCom() {
    CloseCom();
}

void CMainFrame::OnBnClickedLoadBinary() {
    CFileDialog dlg(TRUE,
                    L"bin",
                    nullptr,
                    OFN_FILEMUSTEXIST | OFN_HIDEREADONLY,
                    L"Binary Files (*.bin;*.hex)|*.bin;*.hex|All Files (*.*)|*.*||",
                    this);
    if (dlg.DoModal() != IDOK) {
        return;
    }

    const std::wstring path = dlg.GetPathName().GetString();
    if (!LoadBinaryFromPath(path, false)) {
        MessageBoxW(L"Failed to open binary file.", L"Load Binary", MB_ICONERROR | MB_OK);
    }
}

bool CMainFrame::LoadBinaryFromPath(const std::wstring& path, bool silent) {
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        if (!silent) {
            AppendLog(L"Load binary failed: " + path);
        }
        return false;
    }

    binary_data_.assign(std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>());
    if (binary_data_.empty()) {
        if (!silent) {
            AppendLog(L"Load binary failed: empty file.");
        }
        return false;
    }

    binary_path_ = path;
    file_path_label_.SetWindowTextW((L"File: " + binary_path_).c_str());
    if (silent) {
        AppendLog(L"Binary restored from INI: " + binary_path_ + L", size=" + std::to_wstring(binary_data_.size()) + L" bytes");
    } else {
        AppendLog(L"Binary loaded: " + binary_path_ + L", size=" + std::to_wstring(binary_data_.size()) + L" bytes");
    }
    SaveUiSettings();
    SetProgress(0, L"Progress:");
    UpdateWorkflowUi();
    return true;
}

bool CMainFrame::ConfigureCanBitrate(bool show_error) {
    serial_can::core::IspClientOptions opt = bridge_client_.Options();
    opt.prefetch_window = 1;
    opt.max_retries = 1;
    opt.trace_expected_addr_data = trace_expected_addr_data_;
    opt.trace_can_tx_rx = trace_can_tx_rx_;
    bridge_client_.SetOptions(opt);

    std::wstring error;
    if (!bridge_client_.SetCanBitrate(SelectedCanBitrate(), &error)) {
        if (show_error) {
            AppendLog(L"Set CAN bitrate failed: " + error);
            MessageBoxW(error.c_str(), L"Set CAN Bitrate", MB_ICONERROR | MB_OK);
        }
        return false;
    }

    AppendLog(L"Set CAN bitrate OK: " + SelectedCanBitrate());
    can_configured_ = true;
    SaveUiSettings();
    UpdateWorkflowUi();
    return true;
}

bool CMainFrame::TryEnterBootloaderOnce(bool show_error) {
    b1_attempts_current_connect_ += 1;
    std::wstring error;
    if (bridge_client_.EnterBootloader(&error)) {
        last_connect_error_.clear();
        target_connected_ = true;
        b1_attempts_last_connected_ = b1_attempts_current_connect_;
        target_connect_polling_ = false;
        KillTimer(kConnectPollTimerId);
        AppendLog(L"Connect target OK (bootloader reachable).");
        UpdateWorkflowUi();
        return true;
    }

    last_connect_error_ = error;
    if (show_error) {
        AppendLog(L"Connect target failed: " + error);
        MessageBoxW(error.c_str(), L"Connect", MB_ICONERROR | MB_OK);
    }
    return false;
}

void CMainFrame::StartTargetConnectPolling() {
    target_connect_polling_ = true;
    target_connected_ = false;
    b1_attempts_current_connect_ = 0;
    last_connect_error_.clear();
    last_connect_poll_log_tick_ = GetTickCount();
    SetTimer(kConnectPollTimerId, kConnectPollIntervalMs, nullptr);
    AppendLog(L"Connect polling started.");
    UpdateWorkflowUi();
}

void CMainFrame::StopTargetConnectPolling() {
    if (target_connect_polling_) {
        KillTimer(kConnectPollTimerId);
        target_connect_polling_ = false;
        AppendLog(L"Connect polling stopped.");
    }
}

void CMainFrame::OnBnClickedEnterBootloader() {
    if (!EnsurePreconditions(true, false)) {
        return;
    }
    if (!ConfigureCanBitrate(true)) {
        return;
    }
    if (target_connected_ || target_connect_polling_) {
        return;
    }

    if (!TryEnterBootloaderOnce(false)) {
        StartTargetConnectPolling();
        AppendLog(L"Target not in bootloader yet. polling...");
    }
}

void CMainFrame::OnBnClickedProgram() {
    if (!EnsurePreconditions(true, true)) {
        return;
    }
    if (!can_configured_) {
        MessageBoxW(L"Please set CAN bitrate first.", L"Program", MB_ICONWARNING | MB_OK);
        return;
    }
    if (!target_connected_ && target_connect_polling_) {
        TryEnterBootloaderOnce(false);
    }
    if (!target_connected_) {
        MessageBoxW(L"Please connect target first.", L"Program", MB_ICONWARNING | MB_OK);
        return;
    }

    serial_can::core::IspClientOptions opt = bridge_client_.Options();
    opt.prefetch_window = 1;
    opt.max_retries = 1;
    opt.trace_expected_addr_data = trace_expected_addr_data_;
    opt.trace_can_tx_rx = trace_can_tx_rx_;
    bridge_client_.SetOptions(opt);
    program_cancel_requested_ = false;
    programming_in_progress_ = true;
    UpdateWorkflowUi();
    struct ProgramScopeGuard {
        CMainFrame* self;
        ~ProgramScopeGuard() {
            self->programming_in_progress_ = false;
            self->UpdateWorkflowUi();
        }
    } guard{this};
    StartProgramElapsedTimer();

    AppendLog(L"Program flow start: Erase -> Program -> CRC Verify -> Run");
    SetProgress(2, L"Progress:");

    std::wstring error;
    if (!bridge_client_.Erase(&error)) {
        if (program_cancel_requested_) {
            AppendLog(L"Program canceled by user.");
            SetProgress(0, L"Progress:");
            StopProgramElapsedTimer();
            return;
        }
        AppendLog(L"Erase failed: " + error);
        StopProgramElapsedTimer();
        MessageBoxW(error.c_str(), L"Program", MB_ICONERROR | MB_OK);
        return;
    }
    AppendLog(L"Erase OK.");
    SetProgress(15, L"Progress:");

    AppendLog(L"Program start: block=" + std::to_wstring(opt.program_block_size) +
              L", prefetch=1 (NuLink2-style single in-flight), max_retry=1, boundary=512B-first-word, boundary_ack_timeout=" +
              std::to_wstring(opt.page_boundary_ack_timeout_ms) + L"ms");

    bool last_logged = false;
    const bool ok = bridge_client_.ProgramImage(
        binary_data_,
        [this, &last_logged](const serial_can::core::ProgramProgress& p) {
            const int percent = p.total_blocks == 0 ? 0 : static_cast<int>((p.acked_blocks * 100u) / p.total_blocks);
            SetProgress(percent, L"Program:");

            if (!last_logged && p.total_blocks > 0 && p.acked_blocks == p.total_blocks) {
                AppendLog(L"Program blocks ACK complete.");
                last_logged = true;
            } else if ((p.acked_blocks % 16u) == 0u || p.acked_blocks == p.total_blocks) {
                AppendLog(L"Program ACK " + std::to_wstring(p.acked_blocks) + L"/" + std::to_wstring(p.total_blocks));
            }
            PumpUiMessages();
        },
        [this](const std::wstring& text) {
            AppendLog(text);
            PumpUiMessages();
        },
        [this]() {
            PumpUiMessages();
        },
        &error);

    if (!ok) {
        if (program_cancel_requested_) {
            AppendLog(L"Program canceled by user.");
            SetProgress(0, L"Progress:");
            StopProgramElapsedTimer();
            return;
        }
        AppendLog(L"Program failed: " + error);
        StopProgramElapsedTimer();
        MessageBoxW(error.c_str(), L"Program", MB_ICONERROR | MB_OK);
        return;
    }

    AppendLog(L"Readback verify stage skipped (NuLink2-compatible flow).");

    const std::uint32_t crc = serial_can::core::IspBridgeClient::Crc32(binary_data_.data(), binary_data_.size());
    if (!bridge_client_.Verify(crc, static_cast<std::uint32_t>(binary_data_.size()), &error)) {
        if (program_cancel_requested_) {
            AppendLog(L"Program canceled by user.");
            SetProgress(0, L"Progress:");
            StopProgramElapsedTimer();
            return;
        }
        AppendLog(L"Bridge CRC verify failed: " + error);
        StopProgramElapsedTimer();
        MessageBoxW(error.c_str(), L"Program", MB_ICONERROR | MB_OK);
        return;
    }

    wchar_t crc_text[16] = {};
    swprintf_s(crc_text, L"%08X", crc);
    AppendLog(std::wstring(L"Bridge CRC verify OK. crc32=0x") + crc_text);
    SetProgress(95, L"Progress:");

    if (!bridge_client_.Run(&error)) {
        if (program_cancel_requested_) {
            AppendLog(L"Program canceled by user.");
            SetProgress(0, L"Progress:");
            StopProgramElapsedTimer();
            return;
        }
        AppendLog(L"Run failed: " + error);
        StopProgramElapsedTimer();
        MessageBoxW(error.c_str(), L"Program", MB_ICONERROR | MB_OK);
        return;
    }

    AppendLog(L"Run OK.");
    StopProgramElapsedTimer();
    SetProgress(100, L"Progress:");
    AppendLog(L"Program flow done. Flashing success.");
    {
        const auto& s = bridge_client_.LastProgramCanSummary();
        if (s.valid) {
            std::wstringstream ss;
            ss << L"Sequence summary: B1=" << b1_attempts_last_connected_
               << L", A2=" << s.a2_warmup_count
               << L", ADDR=" << s.address_word_count
               << L" (" << std::hex << std::uppercase << L"0x" << s.first_address
               << L" -> 0x" << s.last_address << std::dec << L")"
               << L", dup_addr=" << s.consecutive_duplicate_address
               << L", AB=" << s.ab_count;
            AppendLog(ss.str());

            if (s.address_to_last_ack_ms > 0u) {
                const double sec = static_cast<double>(s.address_to_last_ack_ms) / 1000.0;
                const double kib = static_cast<double>(binary_data_.size()) / 1024.0;
                const double kibps = kib / sec;
                std::wstringstream perf;
                perf.setf(std::ios::fixed);
                perf.precision(3);
                perf << L"Sequence timing: addr->last_ack=" << sec << L"s, throughput=" << kibps << L" KiB/s";
                AppendLog(perf.str());
            }
            AppendLog(L"Reference (teraterm): B1=2, A2=14, ADDR=32768, AB=1, addr->AB=100.047s");
        }
    }
    AppendLog(L"Auto disconnect after success (VCOM/CAN).");
    CloseCom();
}

void CMainFrame::OnBnClickedRun() {
    if (programming_in_progress_) {
        program_cancel_requested_ = true;
        AppendLog(L"Disconnect requested: cancel programming and close COM.");
        CloseCom();
        return;
    }
    StopProgramElapsedTimer();
    StopTargetConnectPolling();
    target_connected_ = false;
    AppendLog(L"Target disconnected.");
    UpdateWorkflowUi();
}

void CMainFrame::OnBnClickedClearLog() {
    log_edit_.SetWindowTextW(L"");
}

void CMainFrame::OnBnClickedStartLog() {
    StartLogRecording();
}

void CMainFrame::OnBnClickedStopLog() {
    StopLogRecording(true);
}

void CMainFrame::OnBnClickedLogAddrData() {
    trace_expected_addr_data_ = (log_addr_data_chk_.GetCheck() == BST_CHECKED);
    SaveUiSettings();
    AppendLog(std::wstring(L"Expected addr:data trace = ") + (trace_expected_addr_data_ ? L"ON" : L"OFF"));
}

void CMainFrame::OnBnClickedLogCanTxRx() {
    trace_can_tx_rx_ = (log_can_txrx_chk_.GetCheck() == BST_CHECKED);
    SaveUiSettings();
    AppendLog(std::wstring(L"CAN TX/RX trace = ") + (trace_can_tx_rx_ ? L"ON" : L"OFF"));
}

void CMainFrame::OnCbnSelChangeCom() {
    SaveUiSettings();
}

void CMainFrame::OnCbnSelChangeBaud() {
    SaveUiSettings();
}

void CMainFrame::OnCbnSelChangeCanBitrate() {
    SaveUiSettings();
}

void CMainFrame::OnCbnSelChangePrefetch() {
    SaveUiSettings();
}

void CMainFrame::OnTimer(UINT_PTR nIDEvent) {
    if (nIDEvent == kConnectPollTimerId && target_connect_polling_) {
        if (target_connected_) {
            StopTargetConnectPolling();
            UpdateWorkflowUi();
            return;
        }

        if (!IsComOpen()) {
            StopTargetConnectPolling();
            target_connected_ = false;
            UpdateWorkflowUi();
            return;
        }

        if (!TryEnterBootloaderOnce(false)) {
            const DWORD now = GetTickCount();
            if (now - last_connect_poll_log_tick_ >= kConnectPollLogIntervalMs) {
                if (last_connect_error_.empty()) {
                    AppendLog(L"Polling bootloader...");
                } else {
                    AppendLog(L"Polling bootloader... last error: " + last_connect_error_);
                }
                last_connect_poll_log_tick_ = now;
            }
        }
        return;
    }
    if (nIDEvent == kProgramElapsedTimerId && program_timer_running_) {
        UpdateProgramElapsedText();
        return;
    }

    CFrameWnd::OnTimer(nIDEvent);
}

void CMainFrame::OnClose() {
    SaveUiSettings();
    StopLogRecording(false);
    CloseCom();
    CFrameWnd::OnClose();
}
