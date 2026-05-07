#include "app.h"

#include "build_info.generated.h"
#include "main_frame.h"

#include <string>

BEGIN_MESSAGE_MAP(CSerialToCanIspToolApp, CWinApp)
END_MESSAGE_MAP()

BOOL CSerialToCanIspToolApp::InitInstance() {
    CWinApp::InitInstance();

    const std::wstring title = std::wstring(L"Serial to CAN ISP tool v") + SERIAL_CAN_TOOL_VERSION;
    auto* frame = new CMainFrame();
    if (!frame->Create(nullptr,
                       title.c_str(),
                       WS_OVERLAPPEDWINDOW,
                       CRect(0, 0, 1160, 760))) {
        delete frame;
        return FALSE;
    }

    m_pMainWnd = frame;
    frame->ShowWindow(SW_SHOW);
    frame->UpdateWindow();
    return TRUE;
}
