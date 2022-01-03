#include "methods_plugin.h"
#include <iostream>
#include <thread>

namespace {


    class MethodsPlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        MethodsPlugin();

        virtual ~MethodsPlugin();

    private:
        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(
                const flutter::MethodCall<flutter::EncodableValue> &method_call,
                std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

// static
    void MethodsPlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarWindows *registrar) {
        auto channel =
                std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
                        registrar->messenger(), "methods",
                                &flutter::StandardMethodCodec::GetInstance());

        auto plugin = std::make_unique<MethodsPlugin>();

        channel->SetMethodCallHandler(
                [plugin_pointer = plugin.get()](const auto &call, auto result) {
                    plugin_pointer->HandleMethodCall(call, std::move(result));
                });

        registrar->AddPlugin(std::move(plugin));
    }

    MethodsPlugin::MethodsPlugin() {}

    MethodsPlugin::~MethodsPlugin() {}

    void MethodsPlugin::HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result
            ) {

        if (method_call.method_name().compare("invoke") == 0) {
            const auto *title = std::get_if<std::string>(method_call.arguments());
            auto* rspFlag = invoke_ffi((title)->c_str());
            result->Success(flutter::EncodableValue(std::string(rspFlag)));
            free_str_ffi(rspFlag);
        } else {
            result->NotImplemented();
        }

    }

}  // namespace


void MethodsPluginRegisterWithRegistrar(
        FlutterDesktopPluginRegistrarRef registrar) {
    MethodsPlugin::RegisterWithRegistrar(
            flutter::PluginRegistrarManager::GetInstance()
                    ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
