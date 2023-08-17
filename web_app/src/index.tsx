import React, { useMemo, useState } from "react";
import { createRoot } from "react-dom/client";
import { observer } from "mobx-react-lite";
import { IAppProps } from "./interfaces";
import { GraphicWalker } from "@kanaries/graphic-walker";
import type { IGlobalStore } from "@kanaries/graphic-walker/dist/store";
import type { IDataSetInfo, IMutField, IRow, IVisSpec } from "@kanaries/graphic-walker/dist/interfaces";
import type { IStoInfo } from "@kanaries/graphic-walker/dist/utils/save";
import { getExportTool } from "./tools/exportTool";
import CodeExportModal from "./components/codeExportModal";
import { StyleSheetManager } from 'styled-components';
import tailwindStyle from 'tailwindcss/tailwind.css?inline'

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const App: React.FC<IAppProps> = observer((propsIn) => {
    const { dataSource, ...props } = propsIn;
    const storeRef = React.useRef<IGlobalStore>(null);
    const specList: IVisSpec[] = useMemo(() => {
        return props.visSpec ? (JSON.parse(props.visSpec) as IVisSpec[]) : [];
    }, []);
    const [exportOpen, setExportOpen] = useState(false);

    const setData = (data?: IRow[], rawFields?: IMutField[]) => {
        if (specList.length !== 0) {
            setTimeout(() => {
                storeRef?.current?.vizStore?.importStoInfo({
                    dataSources: [
                        {
                            id: "dataSource-0",
                            data: data,
                        },
                    ],
                    datasets: [
                        {
                            id: "dataset-0",
                            name: "DataSet",
                            rawFields: rawFields,
                            dsId: "dataSource-0",
                        },
                    ],
                    specList,
                } as IStoInfo)
            }, 1);
        } else {
            storeRef?.current?.commonStore?.updateTempSTDDS({
                name: "Dataset",
                rawFields: rawFields,
                dataSource: data,
            } as IDataSetInfo);
            storeRef?.current?.commonStore?.commitTempDS();
        }
    }

    React.useEffect(() => {
        setData(dataSource, props.rawFields)
    }, []);

    const exportTool = getExportTool(setExportOpen);

    const tools = [exportTool];

    const toolbarConfig = {
        exclude: ["export_code"],
        extra: tools,
    };
    return (
        <React.StrictMode>
            <div className="h-full w-full overflow-y-scroll font-sans">
            {/* <div style={{ height: "100%", width: "100%", overflowY: "scroll" }}> */}
                <CodeExportModal open={exportOpen} setOpen={setExportOpen} globalStore={storeRef} />
                <GraphicWalker {...props} storeRef={storeRef} toolbar={toolbarConfig} />
            </div>
        </React.StrictMode>
    );
});

const GWalker = (props: IAppProps, id: string) => {
    const container = document.getElementById(id);
    if (container) {
        const shadowRoot = container.attachShadow({ mode: 'open' });

        // Add Tailwind CSS to the shadow root
        const styleElement = document.createElement('style');
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
