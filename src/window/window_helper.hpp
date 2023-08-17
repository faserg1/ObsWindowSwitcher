#pragma once

#include <godot_cpp/classes/node.hpp>

namespace godot
{
    class WindowHelper : public Node
    {
        GDCLASS(WindowHelper, Node)
    protected:
        static void _bind_methods();

    public:
        WindowHelper();
        ~WindowHelper();

        void _process(double delta);
        void onWindowChanged(String name);
    };

}