#pragma once

#include <afxcmn.h>
#include <afxwin.h>

#include <cstdio>
#include <cstdint>
#include <string>
#include <vector>

#include "core/isp_bridge_client.h"
#include "core/serial_port.h"

class CMainFrame : public CFrameWnd {
public:
    CMainFrame();
    ~CMainFrame() override;

protected:
    BOOL PreCreateWindow(CREATESTRUCT& cs) override;
    afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
    afx_msg void OnSize(UINT nType, int cx, int cy);

    afx_msg void OnBnClickedRefreshCom();
    afx_msg void OnBnClickedOpenCom();
    afx_msg void OnBnClickedCloseCom();
    afx_msg void OnBnClickedLoadBinary();
    afx_msg void OnBnClickedEnterBootloader();
    afx_msg void OnBnClickedProgram();
    afx_msg void OnBnClickedRun();
    afx_msg void OnBnClickedClearLog();
    afx_msg void OnBnClickedStartLog();
    afx_msg void OnBnClickedStopLog();
    afx_msg void OnBnClickedLogAddrData();
    afx_msg void OnBnClickedLogCanTxRx();
    afx_msg void OnCbnSelChangeCom();
    afx_msg void OnCbnSelChangeBaud();
    afx_msg void OnCbnSelChangeCanBitrate();
    afx_msg void OnCbnSelChangePrefetch();
    afx_msg void OnTimer(UINT_PTR nIDEvent);
    afx_msg void OnClose();

    DECLARE_MESSAGE_MAP()

private:
    void LayoutControls(int cx, int cy);
    void RefreshComPorts();
    bool OpenSelectedCom();
    void CloseCom();
    void AppendLog(const std::wstring& text);
    void UpdateConnectionUi();
    bool IsComOpen() const;
    std::wstring SelectedComPort() const;
    DWORD SelectedBaudrate() const;
    std::wstring SelectedCanBitrate() const;
    std::uint32_t SelectedPrefetchWindow() const;
    void SetProgress(int value, const std::wstring& label);
    bool EnsurePreconditions(bool need_com, bool need_bin);
    void PumpUiMessages();
    void UpdateWorkflowUi();
    void StartTargetConnectPolling();
    void StopTargetConnectPolling();
    bool TryEnterBootloaderOnce(bool show_error);
    bool ConfigureCanBitrate(bool show_error);
    void InitializeSettingsFile();
    void LoadUiSettings();
    void SaveUiSettings();
    std::wstring ReadIniValue(const wchar_t* key, const wchar_t* fallback) const;
    void WriteIniValue(const wchar_t* key, const std::wstring& value) const;
    void ApplyComboSelection(CComboBox& combo, const std::wstring& value);
    void StartLogRecording();
    void StopLogRecording(bool emit_log);
    bool LoadBinaryFromPath(const std::wstring& path, bool silent);
    void StartProgramElapsedTimer();
    void StopProgramElapsedTimer();
    void UpdateProgramElapsedText();

private:
    CFont ui_font_;

    CStatic com_label_;
    CComboBox com_combo_;
    CStatic baud_label_;
    CComboBox baud_combo_;
    CButton refresh_com_btn_;
    CButton open_com_btn_;
    CButton close_com_btn_;

    CButton load_binary_btn_;
    CStatic file_path_label_;

    CStatic can_bitrate_label_;
    CComboBox can_bitrate_combo_;

    CStatic prefetch_label_;
    CComboBox prefetch_combo_;

    CButton enter_bootloader_btn_;
    CButton program_btn_;
    CButton run_btn_;
    CStatic program_timer_label_;

    CProgressCtrl progress_bar_;
    CStatic progress_label_;
    CStatic build_info_label_;

    CEdit log_edit_;
    CButton clear_log_btn_;
    CButton start_log_btn_;
    CButton stop_log_btn_;
    CButton log_addr_data_chk_;
    CButton log_can_txrx_chk_;

    std::wstring opened_com_port_;
    std::wstring binary_path_;
    std::wstring preferred_com_port_;
    std::wstring ini_path_;
    std::wstring log_record_path_;
    FILE* log_record_fp_ = nullptr;
    bool log_recording_ = false;
    std::vector<std::uint8_t> binary_data_;

    serial_can::core::SerialPort serial_port_;
    serial_can::core::IspBridgeClient bridge_client_;

    bool can_configured_ = false;
    bool target_connected_ = false;
    bool target_connect_polling_ = false;
    bool programming_in_progress_ = false;
    bool program_cancel_requested_ = false;
    bool program_timer_running_ = false;
    ULONGLONG program_timer_start_ms_ = 0;
    DWORD last_connect_poll_log_tick_ = 0;
    std::uint32_t b1_attempts_current_connect_ = 0;
    std::uint32_t b1_attempts_last_connected_ = 0;
    std::wstring last_connect_error_;
    bool trace_expected_addr_data_ = false;
    bool trace_can_tx_rx_ = false;
};
