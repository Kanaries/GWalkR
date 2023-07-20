import React, { useEffect, useState } from "react";
import Modal from "../modal";
import { observer } from "mobx-react-lite";
import DefaultButton from "../button/default";
import { encodeSpec } from "../../utils/graphicWalkerParser";

import type { IGlobalStore } from "@kanaries/graphic-walker/dist/store";
import type { IVisSpec } from "@kanaries/graphic-walker/dist/interfaces";

interface ICodeExport {
    globalStore: React.MutableRefObject<IGlobalStore | null>;
    open: boolean;
    setOpen: (open: boolean) => void;
}

const CodeExport: React.FC<ICodeExport> = observer((props) => {
    const [code, setCode] = useState<IVisSpec[]>([]);

    useEffect(() => {
        if (props.open) {
            const res = props.globalStore.current?.vizStore.exportViewSpec();
            if (res) setCode(res);
        }
    }, [props.open]);

    return (
        <Modal
            show={props.open}
            onClose={() => {
                props.setOpen(false);
            }}
        >
            <div className="dark:text-white">
                <h1 className="mb-4 font-bold text-base">Config Export</h1>
                <div className="text-sm max-h-64 overflow-auto w-full">
                    <code className="font-mono text-xs whitespace-nowrap w-full">
                        visConfig &lt;- '{JSON.stringify(JSON.parse(encodeSpec(code)))}'
                        <br />
                        gwalkr(data="name of your data frame", visConfig=visConfig)
                    </code>
                </div>
                <div className="mt-4 flex justify-start">
                    <DefaultButton
                        text="Cancel"
                        className="mr-2 px-6"
                        onClick={() => {
                            props.setOpen(false);
                        }}
                    />
                </div>
                <div className="text-sm max-h-56 mt-4 text-right">Please copy the R code above and paste it into your script.</div>
            </div>
        </Modal>
    );
});

export default CodeExport;
