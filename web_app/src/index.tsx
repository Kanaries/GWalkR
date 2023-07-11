import React from "react";
import { createRoot } from "react-dom/client";
import { observer } from "mobx-react-lite";
import { IAppProps } from "./interfaces";
import { GraphicWalker } from "@kanaries/graphic-walker";
import "./index.css";

const App: React.FC<IAppProps> = observer((props) => {
  const toolbarConfig = {
    exclude: ["export_code"],
  };
  return (
    <React.StrictMode>
      <div style={{ height: "100%", width: "100%", overflowY: "scroll" }}>
        <GraphicWalker {...props} toolbar={toolbarConfig} />
      </div>
    </React.StrictMode>
  );
});

const GWalker = (props: IAppProps, id: string) => {
  const container = document.getElementById(id);
  if (container) {
    const root = createRoot(container);
    root.render(<App {...props} />);
  }
  // If you want to execute GWalker after the document has loaded, you can do it here.
  // But remember, you will need to provide the 'props' and 'id' parameters.
  // GWalker(someProps, someId);
  // });
};

export default GWalker;
