/*
 * AUI Framework - Declarative UI toolkit for modern C++20
 * Copyright (C) 2020-2025 Alex2772 and Contributors
 *
 * SPDX-License-Identifier: MPL-2.0
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

//
// Created by Alex2772 on 6/20/2022.
//

#include "ARenderingContextOptions.h"
#include <AUI/Platform/Entry.h>
#include <AUI/Util/ACommandLineArgs.h>
#include <AUI/Logging/ALogger.h>

ARenderingContextOptions& ARenderingContextOptions::inst() {
    static ARenderingContextOptions o = {
        {
            OpenGL {},
            Software {},
        },
    };
    return o;
}

const ARenderingContextOptions& ARenderingContextOptions::get() noexcept {
    auto& o = inst();
    static bool cliParsed = false;
    if (!cliParsed) {
        cliParsed = true;
        if (auto arg = aui::args().value("aui-renderer")) {
            auto& val = arg.value();
            if (val == "gl") {
                o.initializationOrder = { OpenGL {} };
            } else if (val == "soft") {
                o.initializationOrder = { Software {} };
            //} else if (val == "dx11") {
            //    o.initializationOrder = { DirectX11 { 11 } };
            } else {
                ALogger::warn("ARenderingContextOptions")
                    << "Unknown --aui-renderer value: \"" << val
                    << "\". Expected: gl, soft";
            }
        }
    }
    return o;
}
