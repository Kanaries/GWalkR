import React, { useState } from "react";
import { createRoot } from "react-dom/client";
import { observer } from "mobx-react-lite";
import { IAppProps } from "./interfaces";
import { GraphicWalker } from "@kanaries/graphic-walker";
import type { VizSpecStore } from '@kanaries/graphic-walker/store/visualSpecStore';
import { getExportTool } from "./tools/exportTool";
import CodeExportModal from "./components/codeExportModal";
import { StyleSheetManager } from "styled-components";
import tailwindStyle from "tailwindcss/tailwind.css?inline";
import formatSpec from "./utils/formatSpec";

const App: React.FC<IAppProps> = observer((propsIn) => {
    const { dataSource, visSpec, rawFields, ...props } = propsIn;
    const storeRef = React.useRef<VizSpecStore|null>(null);

    const specList = visSpec ? formatSpec(JSON.parse(visSpec) as any[], rawFields) : undefined
    const [exportOpen, setExportOpen] = useState(false);

    const exportTool = getExportTool(setExportOpen);

    const tools = [exportTool];

    const toolbarConfig = {
        exclude: ["export_code"],
        extra: tools,
    };
    return (
        <React.StrictMode>
            <div className="h-full w-full overflow-y-scroll font-sans">
                <CodeExportModal open={exportOpen} setOpen={setExportOpen} globalStore={storeRef} />
                <GraphicWalker {...props} storeRef={storeRef} data={dataSource} toolbar={toolbarConfig} fields={rawFields} chart={specList} />
            </div>
        </React.StrictMode>
    );
});

const GWalker = (props: IAppProps, id: string) => {
    const container = document.getElementById(id);
    if (container) {
        const shadowRoot = container.attachShadow({ mode: "open" });

        // Add Tailwind CSS to the shadow root
        const styleElement = document.createElement("style");
        styleElement.textContent = tailwindStyle;
        shadowRoot.appendChild(styleElement);

        const root = createRoot(shadowRoot);
        root.render(
            <StyleSheetManager target={shadowRoot}>
                <App {...props} />
            </StyleSheetManager>
        );
    }
    // If you want to execute GWalker after the document has loaded, you can do it here.
    // But remember, you will need to provide the 'props' and 'id' parameters.
    // GWalker(someProps, someId);
    // });
};

export default GWalker;
