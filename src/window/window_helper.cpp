#include "window_helper.hpp"

#include <godot_cpp/variant/utility_functions.hpp>
#include <set>

#if defined(_MSC_VER)
#include <windows.h>
#endif

using namespace godot;

static WindowHelper *instance = nullptr;
void initCallback();

#if defined(_MSC_VER)

static void Callback(
    [[maybe_unused]] HWINEVENTHOOK hWinEventHook,
    DWORD event,
    HWND hwnd,
    [[maybe_unused]] LONG idObject,
    [[maybe_unused]] LONG idChild,
    [[maybe_unused]] DWORD idEventThread,
    [[maybe_unused]] DWORD dwmsEventTime
)
{
    std::set needFlags = {EVENT_SYSTEM_MINIMIZEEND, EVENT_SYSTEM_FOREGROUND};
    if (!needFlags.contains(event) || !instance)
        return;
    const size_t bufferSize = 4096;
    wchar_t buffer[bufferSize];
    const size_t realSize = GetWindowTextW(hwnd, buffer, (int) bufferSize);
    buffer[realSize] = '\0';
    auto name = String(buffer);
    instance->onWindowChanged(name);
}

static void initCallback()
{
    SetWinEventHook(EVENT_MIN , EVENT_MAX, NULL, &Callback, 0, 0, WINEVENT_OUTOFCONTEXT);
}
#else
#error "Unknow implementation!"
#endif

void WindowHelper::_bind_methods()
{
    ClassDB::add_signal("WindowHelper", MethodInfo("window_changed"));
}

WindowHelper::WindowHelper()
{
    instance = this;
    initCallback();
}

WindowHelper::~WindowHelper()
{
    instance = nullptr;
}

void WindowHelper::_process(double delta)
{

}

void WindowHelper::onWindowChanged(String name)
{
    emit_signal("window_changed", name);
}